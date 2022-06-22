import 'package:bloc/bloc.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/note_manager/models/note.dart';
import 'package:careshare/note_manager/repository/create_note.dart';
import 'package:careshare/note_manager/repository/edit_note_field_repository.dart';
import 'package:careshare/note_manager/repository/remove_note.dart';
import 'package:careshare/note_manager/repository/update_a_note.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:flutter_quill/flutter_quill.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final CreateNote createNoteRepository;
  final EditNoteFieldRepository editNoteFieldRepository;
  final RemoveNote removeNoteRepository;
  final UpdateANote updateANoteRepository;

  NoteCubit({
    required this.createNoteRepository,
    required this.removeNoteRepository,
    required this.updateANoteRepository,
    required this.editNoteFieldRepository,
  }) : super(const NoteInitial());

  final List<Note> noteList = [];

  Future fetchNotes({required String caregroupId}) async {
    try {
      // print('.....fetching notes for: $aregroupId');

      emit(const NotesLoading());

      final reference = FirebaseDatabase.instance.ref('notes').orderByChild('caregroup').equalTo(caregroupId);
      final response = reference.onValue;
      response.listen((event) {
        emit(const NotesLoading());
        if (event.snapshot.value == null) {
          emit(
            NotesLoaded(
              noteList: noteList,
            ),
          );
        } else {
          Map<dynamic, dynamic> returnedList = event.snapshot.value as Map<dynamic, dynamic>;

          noteList.clear();
          returnedList.forEach(
            (key, value) {
              noteList.add(Note.fromJson(key, value));
            },
          );
          noteList.sort(
            (a, b) => b.createdDate.compareTo(a.createdDate),
          );

          emit(
            NotesLoaded(
              noteList: noteList,
            ),
          );
        }
      });
    } catch (error) {
      emit(NoteError(error.toString()));
    }
  }

  Future<Note?> draftNote(
      String caregroupId, String title, CareCategory category, String details, Document? content, String link) async {
    Note? note;
    try {
      note = await createNoteRepository(caregroupId, title, category, details, content, link);

      return note;
    } catch (e) {
      emit(NoteError(e.toString()));
    }
    if (note == null) {
      emit(
        const NoteError('Something went wrong, note is null'),
      );
    }
    return null;
  }

  Future<Note?> createNote(String caregroupId, String title, CareCategory category, String details,
      Document content, String link) async {
    Note? note;
    try {
      note = await createNoteRepository(caregroupId, title, category, details, content, link);

      return note;
    } catch (e) {
      emit(NoteError(e.toString()));
    }
    if (note == null) {
      emit(
        const NoteError('Something went wrong, note is null'),
      );
    }
    return null;
  }

  editNote({required Note note, required NoteField noteField, required dynamic newValue}) {
    emit(const NotesLoading());

    editNoteFieldRepository(note: note, noteField: noteField, newValue: newValue);
  }

  updateNote(Note note) {
    emit(const NoteUpdating());
    updateANoteRepository(note);
    noteList.removeWhere((element) => element.id == note.id);
    noteList.add(note);

    emit(
      NotesLoaded(
        noteList: noteList,
      ),
    );
  }

  removeNote(String id) {
    emit(const NotesLoading());
    removeNoteRepository(id);
    noteList.removeWhere((element) => element.id == id);

    emit(
      NotesLoaded(
        noteList: noteList,
      ),
    );
  }

  showNoteDetails(Note note) {
    emit(
      NotesLoaded(
        noteList: noteList,
      ),
    );
  }

  showNotesOverview() {
    emit(
      NotesLoaded(
        noteList: noteList,
      ),
    );
  }

  Note? fetchNoteFromID(String id) {
    return noteList.firstWhereOrNull((element) => element.id == id);
  }
}
