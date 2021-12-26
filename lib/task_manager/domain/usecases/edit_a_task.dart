import 'package:careshare/task_manager/domain/errors/task_manager_exception.dart';
import 'package:careshare/task_manager/domain/models/task.dart';
import 'package:careshare/task_manager/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';

class EditATask {
  final TaskRepository repository;

  EditATask(this.repository);

  Future<Either<TaskManagerException, CareTask>> call(CareTask task) {
    return repository.editTask(task);
  }
}
