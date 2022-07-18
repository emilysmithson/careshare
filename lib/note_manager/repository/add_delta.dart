import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/note_manager/models/delta_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../models/note.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AddDelta {
  Future<DeltaData> call(
      String noteId,
      DeltaData deltaData
      ) async {

    DatabaseReference reference = FirebaseDatabase.instance.ref("notes/$noteId/deltas");

    reference.child(DateTime.now().millisecondsSinceEpoch.toString()).set(deltaData.toJson());

    return deltaData;
  }
}
