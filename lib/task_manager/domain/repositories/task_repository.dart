import 'package:dartz/dartz.dart';

import '../errors/task_manager_exception.dart';
import '../models/task.dart';

abstract class TaskRepository {
  Future<Either<TaskManagerException, String>> createTask(CareTask task);
  Future<Either<TaskManagerException, List<CareTask>>> fetchAllTasks();
  Future<Either<TaskManagerException, List<CareTask>>> fetchSomeTasks(String search);
  Future<Either<TaskManagerException, CareTask>> editTask(CareTask task);
  Future<Either<TaskManagerException, bool>> removeTask(String taskId);
}
