import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/models/task.dart';
import '../../domain/usecases/all_task_usecases.dart';
import '../../domain/usecases/remove_a_task.dart';
import '../../external/task_datasource_impl.dart';
import '../../infrastructure/repositories/task_repository_impl.dart';

enum PageStatus {
  loading,
  error,
  success,
}

class TaskController {
  final List<CareTask> careTaskList = [];
  final ValueNotifier<PageStatus> status = ValueNotifier<PageStatus>(PageStatus.loading);

  fetchTasks() async {
    final response = await AllTasksUseCases.fetchTasks();

    response.fold((l) {
      status.value = PageStatus.error;
    }, (r) {
      careTaskList.clear();
      careTaskList.addAll(r);
      status.value = PageStatus.success;
    });
  }

  removeATask(String? taskId) {
    if (taskId == null) {
      return;
    }
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepoositoryImpl repository = TaskRepoositoryImpl(datasource);
    final RemoveATask remove = RemoveATask(repository);
    remove(taskId);
    status.value = PageStatus.loading;
    fetchTasks();
  }
}
