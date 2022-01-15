import '../errors/task_manager_exception.dart';
import 'package:careshare/task_manager/domain/models/task.dart';
import 'package:careshare/task_manager/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';

class CompleteTask {
  final TaskRepository repository;
//task.taskCompletedForDate = completedDateTime;
  // task.taskStatus = TaskStatus.completed;

  // task.completedBy = myProfile.id;
  // task.completedByDisplayName = myProfile.displayName ?? 'anonymous';

  CompleteTask(this.repository);
  Future<Either<TaskManagerException, String>> call(
      {required Comment comment,
      required String taskId,
      required DateTime completedDateTime,
      required String profileId,
      String? displayName}) {
    return repository.completeTask(
      comment: comment,
      taskId: taskId,
      completedDateTime: completedDateTime,
      profileId: profileId,
      displayName: displayName,
    );
  }
}
