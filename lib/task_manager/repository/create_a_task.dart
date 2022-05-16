import 'package:firebase_database/firebase_database.dart';

import '../models/task.dart';

import 'package:firebase_auth/firebase_auth.dart';

class CreateATask {
  Future<CareTask> call(String taskName, String caregroupId) async {
    final task = CareTask(
      title: taskName,
      caregroup: caregroupId,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdBy: FirebaseAuth.instance.currentUser!.uid,
      taskCreatedDate: DateTime.now(),
      dueDate: DateTime.now(),
    );
    DatabaseReference reference = FirebaseDatabase.instance.ref('tasks');

    reference.child(task.id).set(task.toJson());

    return task;
  }
}
