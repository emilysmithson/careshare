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
  Future<DatabaseEvent> fetchAllTasks() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("tasks");
    final response = await reference.once();

    return response;
  }

  @override
  Future editTask(CareTask task) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("tasks/${task.id}");

    await reference.set(task.toJson());
  }

  @override
  Future removeTask(String taskId) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("tasks/$taskId");
    reference.remove();
  }

  @override
  Future<DatabaseEvent> fetchSomeTasks(String search) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("tasks/" + search);
    final response = await reference.once();

    return response;
  }

  @override
  Future<String> addComment(Comment comment, String taskId) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("tasks/$taskId/comments");
    final String newkey = reference.push().key as String;
    reference.child(newkey).set(comment.toJson());

    return newkey;
  }
}
