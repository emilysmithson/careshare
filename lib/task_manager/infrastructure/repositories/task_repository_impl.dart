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
//  final DatabaseReference reference =
//         FirebaseDatabase.instance.reference().child("observations");
//     final DataSnapshot snapshot = await reference.once();

//     observations.clear();
//     if (snapshot.value == null) {
//       return true;
//     }
//     final returnedList = snapshot.value;
//     returnedList.forEach((key, value) {
//       observations.add(
//         Sighting(
//           id: key as String,
//           dateTime: DateTime.parse(value['date_time'] as String),
//           user: value['user'] as String,
//           userEmail: value['userEmail'],
//           bird: value['bird'],
//           birdBox: value['bird_box'] as int,
//         ),
//       );
//     });

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

      returnedList.forEach((key, value) {
        print(value);
        print(value['description']);
        careTaskList.add(CareTask(
            title: value['title'] ?? '',
            description: value['description'] ?? '',
            createdBy: value['created_by'] ?? ''));
      });
      // if (returnedList != null) {
      //   returnedList.forEach((key, value) {
      //     print(value);
      //     careTaskList.add(CareTask.fromJson(value));
      //   });
      // }
      // for (final Key key in returnedList) {
      //   careTaskList.add(CareTask.fromJson(key.value));
      // }
    }
    return Right(careTaskList);
  }
}
