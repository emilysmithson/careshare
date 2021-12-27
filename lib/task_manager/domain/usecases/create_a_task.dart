import 'package:dartz/dartz.dart';
import '../errors/task_manager_exception.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'package:careshare/global.dart';

class CreateATask {
  final TaskRepository repository;

  CreateATask(this.repository);
  Future<Either<TaskManagerException, String>> call(CareTask task) async {
    CareTask taskWithId = task;
    task.createdBy = myProfileId;

    return repository.createTask(taskWithId);
  }
}
