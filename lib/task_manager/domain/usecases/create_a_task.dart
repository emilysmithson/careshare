import 'package:dartz/dartz.dart';

import '../Errors/task_manager_exception.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateATask {
  final TaskRepository repoository;

  CreateATask(this.repoository);
  Future<Either<TaskManagerException, String>> call(CareTask task) async {
    CareTask taskWithId = task;
    String? id = FirebaseAuth.instance.currentUser?.uid;

    if (id != null) {
      taskWithId.createdBy = id;
    }

    return repoository.createTask(taskWithId);
  }
}
