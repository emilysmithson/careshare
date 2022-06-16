import 'package:firebase_database/firebase_database.dart';

class RemoveNote {
  call(String id) {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("notes/$id");
    reference.remove();
  }
}
