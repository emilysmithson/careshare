import 'package:bloc/bloc.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/repository/create_a_task.dart';
import 'package:careshare/task_manager/repository/edit_task_field_repository.dart';
import 'package:careshare/task_manager/repository/remove_a_task.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
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
          careTaskList.sort(
            (a, b) => b.dateCreated!.compareTo(a.dateCreated!),
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

  Future<CareTask?> draftTask(String title) async {
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

  createTask({required CareTask task}) {
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.taskStatus,
      newValue: TaskStatus.created,
    );
  }

  editTask(
      {required CareTask task,
      required TaskField taskField,
      required dynamic newValue}) {
    emit(const TaskLoading());

    editTaskFieldRepository(
        task: task, taskField: taskField, newValue: newValue);
  }

  completeTask(
      {required CareTask task,
      required String id,
      required DateTime dateTime}) {
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.completedBy,
      newValue: id,
    );
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.taskCompleteDate,
      newValue: dateTime,
    );
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.taskStatus,
      newValue: TaskStatus.completed,
    );
  }

  assignTask(
    CareTask task,
    String? id,
  ) {
    editTask(
      newValue: id,
      task: task,
      taskField: TaskField.acceptedBy,
    );
    editTask(
      newValue: id == null ? null : DateTime.now(),
      task: task,
      taskField: TaskField.acceptedOnDate,
    );
    editTask(
      newValue: id == null ? TaskStatus.created : TaskStatus.accepted,
      task: task,
      taskField: TaskField.taskStatus,
    );
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

  CareTask? fetchTaskFromID(String id) {
    return careTaskList.firstWhereOrNull((element) => element.id == id);
  }
}
