import 'package:careshare/task_manager/domain/models/task_status.dart';
import 'package:firebase_database/firebase_database.dart';

import '../domain/models/task.dart';
import '../infrastructure/datasources/task_datasource.dart';

const String dbName = 'tasks_test';

class TaskDatasourceImpl implements TaskDatasource {
  @override
  Future<CareTask> createTask(CareTask task) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref(dbName);

    reference.child(task.id).set(task.toJson());

    return task;
  }

  @override
  Future<DatabaseEvent> fetchAllTasks() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref(dbName);
    final response = await reference.once();

    return response;
  }

  @override
  Future editTask(CareTask task) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("$dbName/${task.id}");

    await reference.set(task.toJson());
  }

  @override
  Future editTaskTitle(CareTask task) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("$dbName/${task.id}/title");

    await reference.set(task.title);
  }

  @override
  Future removeTask(String taskId) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("$dbName/$taskId");
    reference.remove();
  }

  @override
  Future<DatabaseEvent> fetchSomeTasks(String search) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("$dbName/" + search);
    final response = await reference.once();

    return response;
  }

  // acceptTask
  @override
  Future<String> acceptTask({
    required Comment comment,
    required String taskId,
    required DateTime acceptedDateTime,
    required String profileId,
    String? displayName,
  }) async {
    // Update status
    DatabaseReference status =
        FirebaseDatabase.instance.ref("$dbName/$taskId/status");
    try {
      await status.set(TaskStatus.accepted.status);
    } catch (error) {
      print(error);
    }

    // Update accepted_for_date
    DatabaseReference time =
        FirebaseDatabase.instance.ref("$dbName/$taskId/accepted_for_date");
    try {
      await time.set(acceptedDateTime.toString());
    } catch (error) {
      print(error);
    }

    // Update accepted_by
    DatabaseReference profile =
        FirebaseDatabase.instance.ref("$dbName/$taskId/accepted_by");
    try {
      await profile.set(profileId);
    } catch (error) {
      print(error);
    }

    // Update accepted_by_display_name
    DatabaseReference profileName = FirebaseDatabase.instance
        .ref("$dbName/$taskId/accepted_by_display_name");
    try {
      await profileName.set(displayName);
    } catch (error) {
      print(error);
    }

    // Update comments
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("$dbName/$taskId/comments");

    final String newkey = reference.push().key as String;
    reference.child(newkey).set(comment.toJson());

    return newkey;
  }

  // completeTask
  @override
  Future<String> completeTask({
    required Comment comment,
    required String taskId,
    required DateTime completedDateTime,
    required String profileId,
    String? displayName,
  }) async {
    // Update status
    DatabaseReference status =
        FirebaseDatabase.instance.ref("$dbName/$taskId/status");
    try {
      await status.set(TaskStatus.completed.status);
    } catch (error) {
      print(error);
    }

    // Update completed_for_date
    DatabaseReference time =
        FirebaseDatabase.instance.ref("$dbName/$taskId/completed_for_date");
    try {
      await time.set(completedDateTime.toString());
    } catch (error) {
      print(error);
    }

    // Update completed_by
    DatabaseReference profile =
        FirebaseDatabase.instance.ref("$dbName/$taskId/completed_by");
    try {
      await profile.set(profileId);
    } catch (error) {
      print(error);
    }

    // Update completed_by_display_name
    DatabaseReference profileName = FirebaseDatabase.instance
        .ref("$dbName/$taskId/completed_by_display_name");
    try {
      await profileName.set(displayName);
    } catch (error) {
      print(error);
    }

    // Update comments
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("$dbName/$taskId/comments");

    final String newkey = reference.push().key as String;
    reference.child(newkey).set(comment.toJson());

    return newkey;
  }

  @override
  Future editTaskField(
      {required CareTask task, required String field, required value}) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("$dbName/${task.id}/$field");

    await reference.set(value);
  }
}
