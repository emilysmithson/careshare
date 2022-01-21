import 'package:bloc/bloc.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/repository/create_a_task.dart';
import 'package:careshare/task_manager/repository/edit_task_field.dart';
import 'package:careshare/task_manager/repository/remove_a_task.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final CreateATask createATask;
  final EditTaskField editTaskField;
  final RemoveATask removeATask;
  TaskCubit({
    required this.createATask,
    required this.editTaskField,
    required this.removeATask,
  }) : super(const TaskInitial());
  bool init = true;
  final List<CareTask> careTaskList = [];

  createTask(
    String title,
  ) async {
    CareTask? task;
    try {
      task = await createATask(title);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
    if (task == null) {
      emit(const TaskError('Something went wrong, task is null'));
    } else {
      emit(TaskDetailsState(task));
    }
  }

  fetchTasks() {
    try {
      if (init) {
        emit(const TaskLoading());
      }
      DatabaseReference reference = FirebaseDatabase.instance.ref('tasks_test');
      final response = reference.onValue;
      response.listen((event) {
        if (event.snapshot.value == null) {
          emit(const TaskLoaded([]));
        } else {
          Map<dynamic, dynamic> returnedList =
              event.snapshot.value as Map<dynamic, dynamic>;

          returnedList.forEach(
            (key, value) {
              careTaskList.add(CareTask.fromJson(key, value));
            },
          );
          if (init) {
            emit(TaskLoaded(careTaskList));
            init = false;
          }
        }
      });
    } catch (error) {
      emit(TaskError(error.toString()));
    }
  }

  editTask(
      {required CareTask task,
      required TaskField taskField,
      required dynamic newValue}) {
    editTaskField(task: task, taskField: taskField, newValue: newValue);
  }

  removeTask(String id) {
    removeATask(id);
  }

  showTaskDetails(CareTask task) {
    emit(TaskDetailsState(task));
  }

  showTasksView() {
    emit(TaskLoaded(careTaskList));
  }
}
