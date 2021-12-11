import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/models/task.dart';
import '../../domain/usecases/fetch_tasks.dart';
import '../../external/task_datasource_impl.dart';
import '../../infrastructure/repositories/task_repository_impl.dart';

enum PageStatus {
  loading,
  error,
  success,
}

class TaskManagerController {
  final List<CareTask> careTaskList = [];
  final ValueNotifier<PageStatus> status =
      ValueNotifier<PageStatus>(PageStatus.loading);
  fetchTasks() async {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepoositoryImpl repository = TaskRepoositoryImpl(datasource);
    final FetchTasks fetchTasksUsecase = FetchTasks(repository);
    final response = await fetchTasksUsecase();

    response.fold((l) {
      status.value = PageStatus.error;
      status.notifyListeners();
    }, (r) {
      careTaskList.addAll(r);
      status.value = PageStatus.success;
      status.notifyListeners();
    });
  }
}
