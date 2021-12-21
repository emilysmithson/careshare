import 'package:dartz/dartz.dart';

import '../../external/task_datasource_impl.dart';
import '../../infrastructure/repositories/task_repository_impl.dart';
import '../Errors/task_manager_exception.dart';
import '../models/task.dart';
import 'create_a_task.dart';
import 'edit_a_task.dart';
import 'fetch_tasks.dart';
import 'remove_a_task.dart';

class TasksUseCases {
  static Future<Either<TaskManagerException, String>> createATask(
    CareTask task,
  ) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepoositoryImpl repository = TaskRepoositoryImpl(datasource);
    final CreateATask createATaskUseCase = CreateATask(repository);
    return createATaskUseCase(task);
  }

  static Future<Either<TaskManagerException, CareTask>> editATask(
      CareTask task) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepoositoryImpl repository = TaskRepoositoryImpl(datasource);
    final EditATask editATaskUseCase = EditATask(repository);
    return editATaskUseCase(task);
  }

  static Future<Either<TaskManagerException, List<CareTask>>> fetchTasks() {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepoositoryImpl repository = TaskRepoositoryImpl(datasource);
    final FetchTasks fetchTasksUseCase = FetchTasks(repository);
    return fetchTasksUseCase();
  }

  static Future<Either<TaskManagerException, bool>> removeTask(
    String id,
  ) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepoositoryImpl repository = TaskRepoositoryImpl(datasource);
    final RemoveATask removeTaskUseCase = RemoveATask(repository);
    return removeTaskUseCase(id);
  }
}

