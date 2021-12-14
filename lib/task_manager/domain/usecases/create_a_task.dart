import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Errors/task_manager_exception.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class CreateATask {
  final TaskRepository repository;

  CreateATask(this.repository);
  Future<Either<TaskManagerException, String>> call(CareTask task) async {
    CareTask taskWithId = task;
    String? id = FirebaseAuth.instance.currentUser?.uid;

    if (id != null) {
      taskWithId.createdBy = id;
    }

    switch(taskWithId.priority.value) {
      case 1: //Highest
        taskWithId.dueDate = DateTime.now().add(const Duration(days: 0));
        break;
      case 2: //High
        taskWithId.dueDate = DateTime.now().add(const Duration(days: 1));
        break;
      case 3: //Medium
        taskWithId.dueDate = DateTime.now().add(const Duration(days: 3));
        break;
      case 4: //Low
        taskWithId.dueDate = DateTime.now().add(const Duration(days: 7));
        break;
      case 5: //Lowest
        taskWithId.dueDate = DateTime.now().add(const Duration(days: 14));
        break;

      default: {
        taskWithId.dueDate = DateTime.now();
      }
      break;
    }


    print('-------------------------------------------------');
    print('dueDate: '+taskWithId.dueDate.toString());
    print('-------------------------------------------------');

    return repository.createTask(taskWithId);
  }
}
