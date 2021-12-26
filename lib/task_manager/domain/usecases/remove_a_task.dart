import 'package:careshare/task_manager/domain/errors/task_manager_exception.dart';
import 'package:careshare/task_manager/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';

class RemoveATask {
  final TaskRepository repository;

  RemoveATask(this.repository);

  Future<Either<TaskManagerException, bool>> call(String taskId) {
    return repository.removeTask(taskId);
  }
}
