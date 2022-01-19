import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/models/task.dart';
import '../domain/usecases/all_task_usecases.dart';
import '../domain/usecases/remove_a_task.dart';
import '../external/task_datasource_impl.dart';
import '../infrastructure/repositories/task_repository_impl.dart';

enum PageStatus {
  loading,
  error,
  loaded,
}

class TasksViewController {
  final ValueNotifier<List<CareTask>> careTaskList =
      ValueNotifier<List<CareTask>>([]);
  final ValueNotifier<PageStatus> status =
      ValueNotifier<PageStatus>(PageStatus.loading);

  fetchTasks() async {
    final response = await AllTaskUseCases.fetchAllTasks();

    response.fold((l) {
      status.value = PageStatus.error;
    }, (r) {
      careTaskList.value.clear();
      careTaskList.value.addAll(r);
      status.value = PageStatus.loaded;
    });
  }

  removeATask(String? taskId) {
    if (taskId == null) {
      return;
    }
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final RemoveATask remove = RemoveATask(repository);
    remove(taskId);
    status.value = PageStatus.loading;
    fetchTasks();
  }
}
