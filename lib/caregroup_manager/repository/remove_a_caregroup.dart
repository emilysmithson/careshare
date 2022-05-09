import 'package:firebase_database/firebase_database.dart';

class RemoveACaregroup {
  call(String id) {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("caregroups/$id");
    reference.remove();
  }
}
