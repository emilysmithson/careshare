import 'package:dartz/dartz.dart';

import '../errors/task_manager_exception.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class FetchTasks {
  final TaskRepository repository;

  FetchTasks(this.repository);
  Future<Either<TaskManagerException, List<CareTask>>> call() {
    return repository.fetchAllTasks();
  }

}

class FetchSomeTasks {
  final TaskRepository repository;

  FetchSomeTasks(this.repository);
  Future<Either<TaskManagerException, List<CareTask>>> call(String search) {
    return repository.fetchSomeTasks(search);
  }

}
