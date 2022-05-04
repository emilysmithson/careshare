import 'package:bloc/bloc.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_history.dart';
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
            (a, b) => b.taskCreatedDate!.compareTo(a.taskCreatedDate!),
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

  Future<CareTask?> draftTask(String title, String caregroupId) async {
    CareTask? task;
    try {
      task = await createATaskRepository(title, caregroupId);

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

  // Create Task
  // Update the task status to Created, unless the task is already assigned
  // in which case set the status to Assigned
  createTask({
    required CareTask task,
    required String id
  }) {
    if (task.assignedTo == null || task.assignedTo == '' ) {
      editTaskFieldRepository(
        task: task,
        taskField: TaskField.taskStatus,
        newValue: TaskStatus.created,
      );
      editTaskFieldRepository(
        task: task,
        taskField: TaskField.taskHistory,
        newValue: TaskHistory(
            id: id, taskStatus: TaskStatus.created, dateTime: DateTime.now()),
      );
    }
    else {
      editTaskFieldRepository(
        task: task,
        taskField: TaskField.taskStatus,
        newValue: TaskStatus.assigned,
      );
      editTaskFieldRepository(
        task: task,
        taskField: TaskField.taskHistory,
        newValue: TaskHistory(
            id: id, taskStatus: TaskStatus.assigned, dateTime: DateTime.now()),
      );
    }
  }

  acceptTask({
    required CareTask task,
    required String id
  }) {
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.taskStatus,
      newValue: TaskStatus.accepted,
    );
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.taskHistory,
      newValue: TaskHistory(
          id: id,
          taskStatus: TaskStatus.accepted,
          dateTime: DateTime.now()),
    );
  }

  rejectTask({
    required CareTask task,
    required String id
  }) {
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.taskStatus,
      newValue: TaskStatus.created,
    );
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.assignedTo,
      newValue: '',
    );
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.taskHistory,
      newValue: TaskHistory(
          id: id,
          taskStatus: TaskStatus.created,
          dateTime: DateTime.now()),
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
    editTaskFieldRepository(
      task: task,
      taskField: TaskField.taskHistory,
      newValue: TaskHistory(
          id: id, taskStatus: TaskStatus.assigned, dateTime: DateTime.now()),
    );
  }


  assignTask({
    required CareTask task,
    required String assignedToId,
    required String assignedById
  }) {
   editTask(
      newValue: assignedToId,
      task: task,
      taskField: TaskField.assignedTo,
    );
    editTask(
      newValue: assignedToId == null ? null : DateTime.now(),
      task: task,
      taskField: TaskField.assignedDate,
    );
    if (task.taskStatus != TaskStatus.draft) {
      editTask(
        newValue: assignedToId == null ? TaskStatus.created : TaskStatus.assigned,
        task: task,
        taskField: TaskField.taskStatus,
      );
      editTaskFieldRepository(
        task: task,
        taskField: TaskField.taskHistory,
        newValue: TaskHistory(
            id: assignedById, taskStatus: TaskStatus.assigned, dateTime: DateTime.now()),
      );
    }
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
