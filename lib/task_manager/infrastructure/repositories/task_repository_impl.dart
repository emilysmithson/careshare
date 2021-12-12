import 'package:careshare/task_manager/domain/models/task_type.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/Errors/task_manager_exception.dart';
import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_datasource.dart';

class TaskRepoositoryImpl implements TaskRepository {
  final TaskDatasource datasource;

  TaskRepoositoryImpl(this.datasource);
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
  Future<Either<TaskManagerException, List<CareTask>>> fetchTasks() async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchTasks();
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
          careTaskList.add(
            CareTask(
                title: value['title'] ?? '',
                description: value['description'] ?? '',
                createdBy: value['created_by'] ?? '',
                id: key,
                taskType: TaskType.taskTypeList.firstWhere(
                  (element) => element.type == value['task_type'],
                )),
          );
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
}
