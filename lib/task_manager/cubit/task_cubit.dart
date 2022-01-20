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

  createTask(String title) {
    try {
      createATask(title);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  fetchTasks() {
    try {
      emit(const TaskLoading());
      DatabaseReference reference = FirebaseDatabase.instance.ref('tasks_test');
      final response = reference.onValue;
      response.listen((event) {
        final List<CareTask> _careTaskList = [];
        if (event.snapshot.value == null) {
          emit(const TaskLoaded([]));
        } else {
          Map<dynamic, dynamic> returnedList =
              event.snapshot.value as Map<dynamic, dynamic>;

          returnedList.forEach(
            (key, value) {
              _careTaskList.add(CareTask.fromJson(key, value));
            },
          );

          emit(TaskLoaded(_careTaskList));
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
}
