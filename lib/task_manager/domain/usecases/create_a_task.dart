import 'package:dartz/dartz.dart';
import '../errors/task_manager_exception.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateATask {
  final TaskRepository repository;

  CreateATask(this.repository);
  Future<Either<TaskManagerException, CareTask>> call(String taskName) async {
    final newCareTask = CareTask(
      title: taskName,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdBy: FirebaseAuth.instance.currentUser!.uid,
      dateCreated: DateTime.now(),
    );
    return repository.createTask(newCareTask);
  }
}
