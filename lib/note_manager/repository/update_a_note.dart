import 'package:firebase_database/firebase_database.dart';

import '../models/note.dart';

class UpdateANote {
  Future<Note> call(Note note) async {

    DatabaseReference reference = FirebaseDatabase.instance.ref('notes');

    reference.child(note.id).set(note.toJson());

    return note;
  }
}
