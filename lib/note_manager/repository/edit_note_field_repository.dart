import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/note_manager/models/note.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';


class EditNoteFieldRepository {
  Note call({required Note note, required NoteField noteField, required dynamic newValue}) {
    Note newNote = note;
    late String field;
    // ignore: prefer_typing_uninitialized_variables
    late var value;
    switch (noteField) {
      case NoteField.title:
        newNote.title = newValue;
        field = 'title';
        value = newValue;
        break;
      case NoteField.category:
        newNote.category = newValue;
        field = 'category';
        value = (newValue as CareCategory).toJson();
        break;

      case NoteField.content:
        newNote.content = newValue;
        field = 'content';
        value = newValue.toDelta().toJson();
        break;
      case NoteField.link:
        newNote.link = newValue;
        field = 'link';
        value = newValue;
        break;
      case NoteField.caregroupId:
        newNote.caregroupId = newValue;
        field = 'caregroup';
        value = newValue;
        break;
      case NoteField.details:
        newNote.details = newValue;
        field = 'details';
        value = newValue;
        break;
      case NoteField.createdById:
        newNote.createdById = newValue;
        field = 'created_by';
        value = newValue;
        break;
      case NoteField.createdDate:
        newNote.createdDate = newValue;
        field = 'created_date';
        value = newValue.toString();
        break;

    }

    DatabaseReference reference = FirebaseDatabase.instance.ref("notes/${note.id}/$field");
    try {
      reference.set(value);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return newNote;
  }
}
