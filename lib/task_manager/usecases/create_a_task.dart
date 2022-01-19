import 'package:firebase_database/firebase_database.dart';

import '../models/task.dart';

import 'package:firebase_auth/firebase_auth.dart';

class CreateATask {
  Future<CareTask> call(String taskName) async {
    final task = CareTask(
      title: taskName,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdBy: FirebaseAuth.instance.currentUser!.uid,
      dateCreated: DateTime.now(),
    );
    DatabaseReference reference = FirebaseDatabase.instance.ref('tasks_test');

    reference.child(task.id).set(task.toJson());

    return task;
  }
}
