import 'package:firebase_database/firebase_database.dart';

import '../models/task.dart';

class UpdateATask {
  Future<CareTask> call(CareTask task) async {

    DatabaseReference reference = FirebaseDatabase.instance.ref('tasks');

    reference.child(task.id).set(task.toJson());

    return task;
  }
}
