import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/note.dart';

import 'package:firebase_auth/firebase_auth.dart';

class CreateNote {
  Future<Note> call(
      String caregroupId,
      String title,
      CareCategory category,
      String details,
      String content,
      String link,
      ) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      caregroupId: caregroupId,
      title: title,
      category: category,
      details: details,
      createdById: FirebaseAuth.instance.currentUser!.uid,
      createdDate: DateTime.now(),
      content: content,
      link: link,
    );
    DatabaseReference reference = FirebaseDatabase.instance.ref('notes');

    reference.child(note.id).set(note.toJson());

    return note;
  }
}
