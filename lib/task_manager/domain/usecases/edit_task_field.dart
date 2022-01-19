import 'package:careshare/task_manager/domain/errors/task_manager_exception.dart';
import 'package:careshare/task_manager/domain/models/task.dart';
import 'package:careshare/task_manager/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';

class EditTaskField {
  final TaskRepository repository;

  EditTaskField(this.repository);

  Future<Either<TaskManagerException, CareTask>> call(
      {required CareTask task,
      required TaskField taskField,
      required dynamic newValue}) {
    CareTask newTask = task;
    late String field;
    switch (taskField) {
      case TaskField.title:
        newTask.title = newValue;
        field = 'title';
        break;
      case TaskField.details:
        newTask.details = newValue;
        field = 'details';
        break;
      case TaskField.taskEffort:
        newTask.taskEffort = newValue;
        field = 'task_effort';
        break;
      case TaskField.taskPriority:
        newTask.taskPriority = newValue;
        field = 'task_priority';
        break;
      case TaskField.category:
        newTask.category = newValue;
        field = 'category';
        break;
      case TaskField.taskStatus:
        newTask.taskStatus = newValue;
        field = 'task_status';
        break;
      case TaskField.acceptedBy:
        newTask.acceptedBy = newValue;
        field = 'accepted_by';
        break;
      case TaskField.completedBy:
        newTask.completedBy = newValue;
        field = 'completed_by';
        break;
      case TaskField.taskCompleteDate:
        newTask.taskCompletedDate = newValue;
        field = 'task_completed_date';
        break;
    }

    return repository.editTaskField(
      task: newTask,
      field: field,
      value: newValue,
    );
  }
}
