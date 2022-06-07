import 'package:bloc/bloc.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_history.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/repository/create_a_task.dart';
import 'package:careshare/task_manager/repository/edit_task_field_repository.dart';
import 'package:careshare/task_manager/repository/remove_a_task.dart';
import 'package:careshare/task_manager/repository/update_a_task.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final CreateATask createATaskRepository;
  final EditTaskFieldRepository editTaskFieldRepository;
  final UpdateATask updateATaskRepository;
  final RemoveATask removeATaskRepository;

  TaskCubit({
    required this.createATaskRepository,
    required this.editTaskFieldRepository,
    required this.updateATaskRepository,
    required this.removeATaskRepository,
  }) : super(const TaskInitial());

  final List<CareTask> taskList = [];

  Future fetchTasks({required String caregroupId}) async {
    try {
      emit(const TaskLoading());
      final reference = FirebaseDatabase.instance.ref('tasks').orderByChild('caregroup').equalTo(caregroupId);
      final response = reference.onValue;
      response.listen((event) {
        emit(const TaskLoading());
        if (event.snapshot.value == null) {
          emit(
            TaskLoaded(
              careTaskList: taskList,
            ),
          );
        } else {
          Map<dynamic, dynamic> returnedList = event.snapshot.value as Map<dynamic, dynamic>;

          taskList.clear();
          returnedList.forEach(
            (key, value) {
              taskList.add(CareTask.fromJson(key, value));
            },
          );
          taskList.sort(
            (a, b) => b.taskCreatedDate!.compareTo(a.taskCreatedDate!),
          );

          emit(
            TaskLoaded(
              careTaskList: taskList,
            ),
          );
        }
      });
    } catch (error) {
      emit(TaskError(error.toString()));
    }
  }

  fetchTasksForCaregroup({required String caregroupId}) async {
    try {
      emit(const TaskLoading());
      taskList.clear();
      final reference = FirebaseDatabase.instance.ref('tasks').orderByChild('caregroup').equalTo(caregroupId);

      final response = reference.onValue;
      response.listen((event) {
        emit(const TaskLoading());
        Map<dynamic, dynamic> returnedList;
        if (event.snapshot.value == null) {
          print("no task found");
          returnedList = {};
        } else {
          returnedList = event.snapshot.value as Map<dynamic, dynamic>;
        }
        taskList.clear();
        returnedList.forEach(
          (key, value) {
            taskList.add(CareTask.fromJson(key, value));
          },
        );
        taskList.sort(
          (a, b) => b.taskCreatedDate!.compareTo(a.taskCreatedDate!),
        );

        emit(
          TaskLoaded(
            careTaskList: taskList,
          ),
        );
        // }
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
  createTask({required CareTask task, required String profileId}) {
    if (task.assignedTo == null || task.assignedTo == '') {
      editTask(
        task: task,
        taskField: TaskField.taskStatus,
        newValue: TaskStatus.created,
      );

      editTask(
        task: task,
        taskField: TaskField.taskHistory,
        newValue: TaskHistory(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            profileId: profileId,
            taskStatus: TaskStatus.created,
            dateTime: DateTime.now()),
      );
    } else {
      editTask(
        task: task,
        taskField: TaskField.taskStatus,
        newValue: TaskStatus.assigned,
      );
      editTask(
        task: task,
        taskField: TaskField.taskHistory,
        newValue: TaskHistory(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            profileId: profileId,
            taskStatus: TaskStatus.assigned,
            dateTime: DateTime.now()),
      );
    }
  }

  acceptTask({required CareTask task, required String profileId}) {
    editTask(
      task: task,
      taskField: TaskField.taskStatus,
      newValue: TaskStatus.accepted,
    );
    editTask(
      task: task,
      taskField: TaskField.taskHistory,
      newValue: TaskHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          profileId: profileId,
          taskStatus: TaskStatus.accepted,
          dateTime: DateTime.now()),
    );
  }

  rejectTask({required CareTask task, required String profileId}) {
    editTask(
      task: task,
      taskField: TaskField.taskStatus,
      newValue: TaskStatus.created,
    );
    editTask(
      task: task,
      taskField: TaskField.assignedTo,
      newValue: '',
    );
    editTask(
      task: task,
      taskField: TaskField.taskHistory,
      newValue: TaskHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          profileId: profileId,
          taskStatus: TaskStatus.created,
          dateTime: DateTime.now()),
    );
  }

  editTask({required CareTask task, required TaskField taskField, required dynamic newValue}) {
    emit(const TaskLoading());

    editTaskFieldRepository(task: task, taskField: taskField, newValue: newValue);
  }

  completeTask({required CareTask task, required String profileId, required DateTime dateTime}) {
    editTask(
      task: task,
      taskField: TaskField.completedBy,
      newValue: profileId,
    );
    editTask(
      task: task,
      taskField: TaskField.taskCompleteDate,
      newValue: dateTime,
    );
    editTask(
      task: task,
      taskField: TaskField.taskStatus,
      newValue: TaskStatus.completed,
    );
    editTask(
      task: task,
      taskField: TaskField.taskHistory,
      newValue: TaskHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          profileId: profileId,
          taskStatus: TaskStatus.completed,
          dateTime: DateTime.now()),
    );
  }

  assignTask({required CareTask task, required String? assignedToId, required String assignedById}) {
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
      editTask(
        task: task,
        taskField: TaskField.taskHistory,
        newValue: TaskHistory(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            profileId: assignedById,
            taskStatus: TaskStatus.assigned,
            dateTime: DateTime.now()),
      );
    }
  }

  updateTask(CareTask task) {
    emit(const TaskUpdating());
    updateATaskRepository(task);
    taskList.removeWhere((element) => element.id == task.id);
    taskList.add(task);

    emit(
      TaskLoaded(
        careTaskList: taskList,
      ),
    );
  }

  removeTask(String id) {
    emit(const TaskLoading());
    removeATaskRepository(id);
    taskList.removeWhere((element) => element.id == id);

    emit(
      TaskLoaded(
        careTaskList: taskList,
      ),
    );
  }

  showTaskDetails(CareTask task) {
    emit(
      TaskLoaded(
        careTaskList: taskList,
      ),
    );
  }

  showTasksOverview() {
    emit(
      TaskLoaded(
        careTaskList: taskList,
      ),
    );
  }

  CareTask? fetchTaskFromID(String id) {
    return taskList.firstWhereOrNull((element) => element.id == id);
  }

  clearList() {
    taskList.clear();
  }
}
