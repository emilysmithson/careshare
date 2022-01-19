import 'package:careshare/task_manager/domain/errors/task_manager_exception.dart';
import 'package:careshare/task_manager/domain/models/task.dart';
import 'package:careshare/task_manager/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';

class EditTaskTitle {
  final TaskRepository repository;

  EditTaskTitle(this.repository);

  Future<Either<TaskManagerException, CareTask>> call(
      CareTask task, String title) {
    CareTask newTask = task;
    newTask.title = title;
    return repository.editTask(newTask);
  }
}
