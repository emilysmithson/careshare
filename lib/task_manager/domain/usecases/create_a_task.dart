import 'package:dartz/dartz.dart';

import '../Errors/task_manager_exception.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class CreateATask {
  final TaskRepository repoository;

  CreateATask(this.repoository);
  Future<Either<TaskManagerException, String>> call(CareTask task) async {
    return repoository.createTask(task);
  }
}
