import 'package:bloc/bloc.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/repository/create_a_task.dart';
import 'package:careshare/task_manager/repository/edit_task_field_repository.dart';
import 'package:careshare/task_manager/repository/remove_a_task.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final CreateATask createATaskRepository;
  final EditTaskFieldRepository editTaskFieldRepository;
  final RemoveATask removeATaskRepository;
  TaskCubit({
    required this.createATaskRepository,
    required this.editTaskFieldRepository,
    required this.removeATaskRepository,
  }) : super(const TaskInitial());

  final List<CareTask> careTaskList = [];

  fetchTasks() async {
    try {
      emit(const TaskLoading());
      DatabaseReference reference = FirebaseDatabase.instance.ref('tasks');
      final response = reference.onValue;
      response.listen((event) {
        emit(const TaskLoading());
        if (event.snapshot.value == null) {
          emit(
            TaskLoaded(
              careTaskList: careTaskList,
            ),
          );
        } else {
          Map<dynamic, dynamic> returnedList =
              event.snapshot.value as Map<dynamic, dynamic>;
          careTaskList.clear();
          returnedList.forEach(
            (key, value) {
              careTaskList.add(CareTask.fromJson(key, value));
            },
          );

          emit(
            TaskLoaded(
              careTaskList: careTaskList,
            ),
          );
        }
      });
    } catch (error) {
      emit(TaskError(error.toString()));
    }
  }

  Future<CareTask?> createTask(String title) async {
    CareTask? task;
    try {
      task = await createATaskRepository(title);
      return task;
    } catch (e) {
      emit(TaskError(e.toString()));
    }
    if (task == null) {
      emit(
        const TaskError('Something went wrong, task is null'),
      );
    }
    return null;
  }

  editTask(
      {required CareTask task,
      required TaskField taskField,
      required dynamic newValue}) {
    emit(const TaskLoading());

    editTaskFieldRepository(
        task: task, taskField: taskField, newValue: newValue);
  }

  removeTask(String id) {
    emit(const TaskLoading());
    removeATaskRepository(id);
    careTaskList.removeWhere((element) => element.id == id);

    emit(
      TaskLoaded(
        careTaskList: careTaskList,
      ),
    );
  }

  showTaskDetails(CareTask task) {
    emit(
      TaskLoaded(
        careTaskList: careTaskList,
      ),
    );
  }

  showTasksOverview() {
    emit(
      TaskLoaded(
        careTaskList: careTaskList,
      ),
    );
  }
}
