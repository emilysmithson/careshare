import '../errors/task_manager_exception.dart';
import 'package:careshare/task_manager/domain/models/task.dart';
import 'package:careshare/task_manager/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';

class AddComment {
  final TaskRepository repository;

  AddComment(this.repository);
  Future<Either<TaskManagerException, String>> call(
    Comment comment,
    String taskId,
  ) {
    return repository.addComment(comment, taskId);
  }
}
