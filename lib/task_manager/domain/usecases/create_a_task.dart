import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Errors/task_manager_exception.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class CreateATask {
  final TaskRepository repository;

  CreateATask(this.repository);
  Future<Either<TaskManagerException, String>> call(CareTask task) async {
    CareTask taskWithExtraDetails = task;
    String? id = FirebaseAuth.instance.currentUser?.uid;

    if (id != null) {
      taskWithExtraDetails.createdBy = id;
    }

    switch(taskWithExtraDetails.priority.value) {
      case 1: //Highest
        taskWithExtraDetails.dueDate = DateTime.now().add(const Duration(hours: 1));
        break;
      case 2: //High
        taskWithExtraDetails.dueDate = DateTime.now().add(const Duration(days: 1));
        break;
      case 3: //Medium
        taskWithExtraDetails.dueDate = DateTime.now().add(const Duration(days: 3));
        break;
      case 4: //Low
        taskWithExtraDetails.dueDate = DateTime.now().add(const Duration(days: 7));
        break;
      case 5: //Lowest
        taskWithExtraDetails.dueDate = DateTime.now().add(const Duration(days: 14));
        break;

      default: {
        taskWithExtraDetails.dueDate = DateTime.now();
      }
      break;
    }

    return repository.createTask(taskWithExtraDetails);
  }
}
