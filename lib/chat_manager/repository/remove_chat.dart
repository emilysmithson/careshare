import 'package:firebase_database/firebase_database.dart';

class RemoveChat {
  call(String id) {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("chats/$id");
    reference.remove();
  }
}
