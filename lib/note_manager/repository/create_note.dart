import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/note_manager/models/delta_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../models/note.dart';

import 'package:firebase_auth/firebase_auth.dart';

class CreateNote {
  Future<Note> call(
      String caregroupId,
      String title,
      CareCategory category,
      String details,
      List<DeltaData> deltas,
      Document? content,
      String link,
      ) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      caregroupId: caregroupId,
      title: title,
      category: category,
      details: details,
      deltas: deltas,
      createdById: FirebaseAuth.instance.currentUser!.uid,
      createdDate: DateTime.now(),
      content: content,
      link: link,
    );
    DatabaseReference reference = FirebaseDatabase.instance.ref('notes');

    print(note.toJson().toString());
    reference.child(note.id).set(note.toJson());

    return note;
  }
}
