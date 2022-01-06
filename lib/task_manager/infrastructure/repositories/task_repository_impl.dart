import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/task_manager_exception.dart';
import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDatasource datasource;

  TaskRepositoryImpl(this.datasource);

  @override
  Future<Either<TaskManagerException, String>> createTask(CareTask task) async {
    String response;
    try {
      response = await datasource.createTask(task);
    } catch (error) {
      return Left(TaskManagerException(error.toString()));
    }
    return Right(response);
  }

  @override
  Future<Either<TaskManagerException, List<CareTask>>> fetchAllTasks() async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchAllTasks();
    } catch (error) {
      return Left(TaskManagerException(error.toString()));
    }
    final List<CareTask> careTaskList = [];
    if (response.snapshot.value == null) {
      return Left(TaskManagerException('no values'));
    } else {
      Map<dynamic, dynamic> returnedList =
          response.snapshot.value as Map<dynamic, dynamic>;

      returnedList.forEach(
        (key, value) {
          careTaskList.add(CareTask.fromJson(key, value));
        },
      );
    }
    return Right(careTaskList);
  }

  @override
  Future<Either<TaskManagerException, CareTask>> editTask(CareTask task) async {
    try {
      datasource.editTask(task);
    } catch (error) {
      return Left(TaskManagerException(error.toString()));
    }
    return Right(task);
  }

  @override
  Future<Either<TaskManagerException, bool>> removeTask(String taskId) async {
    try {
      datasource.removeTask(taskId);
    } catch (error) {
      return Left(TaskManagerException(error.toString()));
    }
    return const Right(true);
  }

  @override
  Future<Either<TaskManagerException, List<CareTask>>> fetchSomeTasks(
      String search) async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchSomeTasks(search);
    } catch (error) {
      return Left(TaskManagerException(error.toString()));
    }
    final List<CareTask> careTaskList = [];
    if (response.snapshot.value == null) {
      return Left(TaskManagerException('no values'));
    } else {
      Map<dynamic, dynamic> returnedList =
          response.snapshot.value as Map<dynamic, dynamic>;

      returnedList.forEach(
        (key, value) {
          careTaskList.add(CareTask.fromJson(key, value));
        },
      );
    }
    return Right(careTaskList);
  }

  @override
  Future<Either<TaskManagerException, String>> addComment(
      {required Comment comment,
      required String taskId,
      required DateTime acceptedDateTime,
      required String profileId,
      String? displayName}) async {
    String response;
    try {
      response = await datasource.addComment(
        comment: comment,
        taskId: taskId,
        acceptedDateTime: acceptedDateTime,
        profileId: profileId,
        displayName: displayName,
      );
    } catch (error) {
      return Left(TaskManagerException(error.toString()));
    }
    return Right(response);
  }
}
