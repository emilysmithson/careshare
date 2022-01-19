import 'package:careshare/task_manager/domain/usecases/edit_task_field.dart';
import 'package:careshare/task_manager/domain/usecases/edit_title.dart';
import 'package:dartz/dartz.dart';

import '../../external/task_datasource_impl.dart';
import '../../infrastructure/repositories/task_repository_impl.dart';
import '../errors/task_manager_exception.dart';
import '../models/task.dart';
import 'create_a_task.dart';
import 'edit_a_task.dart';
import 'fetch_tasks.dart';
import 'remove_a_task.dart';
import 'accept_task.dart';
import 'complete_task.dart';

class AllTaskUseCases {
  static Future<Either<TaskManagerException, CareTask>> createATask(
      String taskName) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final CreateATask createATaskUseCase = CreateATask(repository);
    return createATaskUseCase(taskName);
  }

  static Future<Either<TaskManagerException, CareTask>> editATask(
      CareTask task) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final EditATask editATaskUseCase = EditATask(repository);
    return editATaskUseCase(task);
  }

  static Future<Either<TaskManagerException, CareTask>> editTaskTitle({
    required CareTask task,
    required String title,
  }) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final EditTaskTitle editTaskTitleUseCase = EditTaskTitle(repository);
    return editTaskTitleUseCase(task, title);
  }

  static Future<Either<TaskManagerException, CareTask>> editTaskField(
      {required CareTask task,
      required dynamic value,
      required TaskField taskField}) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final EditTaskField editTaskField = EditTaskField(repository);
    return editTaskField(
      task: task,
      newValue: value,
      taskField: taskField,
    );
  }

  static Future<Either<TaskManagerException, List<CareTask>>> fetchAllTasks() {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final FetchTasks fetchTasksUseCase = FetchTasks(repository);
    return fetchTasksUseCase();
  }

  static Future<Either<TaskManagerException, List<CareTask>>> fetchSomeTasks(
      String search) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final FetchSomeTasks fetchTasksUseCase = FetchSomeTasks(repository);
    return fetchTasksUseCase(search);
  }

  static Future<Either<TaskManagerException, bool>> removeTask(String id) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final RemoveATask removeTaskUseCase = RemoveATask(repository);
    return removeTaskUseCase(id);
  }

  static Future<Either<TaskManagerException, String>> acceptTask(
      {required Comment comment,
      required String taskId,
      required DateTime acceptedDateTime,
      required String profileId,
      String? displayName}) async {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final AcceptTask acceptTaskUseCase = AcceptTask(repository);
    return acceptTaskUseCase(
      comment: comment,
      taskId: taskId,
      acceptedDateTime: acceptedDateTime,
      profileId: profileId,
      displayName: displayName,
    );
  }

  static Future<Either<TaskManagerException, String>> completeTask(
      {required Comment comment,
      required String taskId,
      required DateTime completedDateTime,
      required String profileId,
      String? displayName}) async {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepositoryImpl repository = TaskRepositoryImpl(datasource);
    final CompleteTask completeTaskUseCase = CompleteTask(repository);
    return completeTaskUseCase(
      comment: comment,
      taskId: taskId,
      completedDateTime: completedDateTime,
      profileId: profileId,
      displayName: displayName,
    );
  }
}
