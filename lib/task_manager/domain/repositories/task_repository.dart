import 'package:dartz/dartz.dart';

import '../Errors/task_manager_exception.dart';
import '../models/task.dart';

abstract class TaskRepository {
  Future<Either<TaskManagerException, String>> createTask(CareTask task);
  Future<Either<TaskManagerException, List<CareTask>>> fetchTasks();
  Future<Either<TaskManagerException, CareTask>> editTask(CareTask task);
  Future<Either<TaskManagerException, bool>> removeTask(String taskId);
}
