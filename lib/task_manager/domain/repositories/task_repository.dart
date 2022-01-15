import 'package:dartz/dartz.dart';

import '../errors/task_manager_exception.dart';
import '../models/task.dart';

abstract class TaskRepository {
  Future<Either<TaskManagerException, String>> createTask(CareTask task);
  Future<Either<TaskManagerException, List<CareTask>>> fetchAllTasks();
  Future<Either<TaskManagerException, List<CareTask>>> fetchSomeTasks(
      String search);
  Future<Either<TaskManagerException, CareTask>> editTask(CareTask task);
  Future<Either<TaskManagerException, bool>> removeTask(String taskId);
  Future<Either<TaskManagerException, String>> acceptTask(
      {required Comment comment,
        required String taskId,
        required DateTime acceptedDateTime,
        required String profileId,
        String? displayName});
  Future<Either<TaskManagerException, String>> completeTask(
      {required Comment comment,
        required String taskId,
        required DateTime completedDateTime,
        required String profileId,
        String? displayName});
}
