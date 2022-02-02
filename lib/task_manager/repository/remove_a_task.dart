import 'package:firebase_database/firebase_database.dart';

class RemoveATask {
  call(String id) {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("tasks/$id");
    reference.remove();
  }
}
