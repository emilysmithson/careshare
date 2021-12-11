import 'package:firebase_database/firebase_database.dart';

import '../domain/models/task.dart';
import '../infrastructure/datasources/task_datasource.dart';

class TaskDatasourceImpl implements TaskDatasource {
  @override
  Future<String> createTask(CareTask task) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("tasks");
    final String newkey = reference.push().key as String;
    reference.child(newkey).set(task.toJson());
    return newkey;
  }

  @override
  Future<DatabaseEvent> fetchTasks() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("tasks");
    final response = await reference.once();

    return response;
  }

  @override
  Future editTask(CareTask task) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("tasks/$task.id");
    await reference.set(task.toJson());
  }

  @override
  Future removeTask(String taskId) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("tasks/$taskId");
    reference.remove();
  }
}
