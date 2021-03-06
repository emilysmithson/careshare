import 'package:bloc/bloc.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/note_manager/models/delta_data.dart';
import 'package:careshare/note_manager/models/note.dart';
import 'package:careshare/note_manager/repository/add_delta.dart';
import 'package:careshare/note_manager/repository/create_note.dart';
import 'package:careshare/note_manager/repository/edit_note_field_repository.dart';
import 'package:careshare/note_manager/repository/remove_note.dart';
import 'package:careshare/note_manager/repository/update_a_note.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:flutter_quill/flutter_quill.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final CreateNote createNoteRepository;
  final EditNoteFieldRepository editNoteFieldRepository;
  final RemoveNote removeNoteRepository;
  final UpdateANote updateANoteRepository;

  NotesCubit({
    required this.createNoteRepository,
    required this.removeNoteRepository,
    required this.updateANoteRepository,
    required this.editNoteFieldRepository,
  }) : super(const NotesInitial());

  final List<Note> noteList = [];

  Future fetchNotes({
    required String caregroupId,
    required String categoryId,
  }) async {
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
              Note _note = Note.fromJson(key, value);
              if (_note.category.id == categoryId) {
                noteList.add(_note);
              }
            },
          );
          noteList.sort(
            (a, b) => b.createdDate.compareTo(a.createdDate),
          );

          print("emitting updated note list");
          emit(
            NotesLoaded(
              noteList: noteList,
            ),
          );
        }
      });
    } catch (error) {
      emit(NotesError(error.toString()));
    }
  }

  Future fetchNotesForCaregroup({
    required String caregroupId,
  }) async {
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

          print("emitting updated note list");
          emit(
            NotesLoaded(
              noteList: noteList,
            ),
          );
        }
      });
    } catch (error) {
      emit(NotesError(error.toString()));
    }
  }

  Future<Note?> draftNote(String caregroupId, String title, CareCategory category, String details,
      List<DeltaData> deltas, Document? content, String link) async {
    Note? note;
    try {
      note = await createNoteRepository(caregroupId, title, category, details, deltas, content, link);

      return note;
    } catch (e) {
      emit(NotesError(e.toString()));
    }
    if (note == null) {
      emit(
        const NotesError('Something went wrong, note is null'),
      );
    }
    return null;
  }

  Future<Note?> createNote(
      String caregroupId, String title, CareCategory category, String details, List<DeltaData> deltas, Document content, String link) async {
    Note? note;
    try {
      note = await createNoteRepository(caregroupId, title, category, details, deltas, content, link);

      return note;
    } catch (e) {
      emit(NotesError(e.toString()));
    }
    if (note == null) {
      emit(
        const NotesError('Something went wrong, note is null'),
      );
    }
    return null;
  }

  editNote({required Note note, required NoteField noteField, required dynamic newValue}) {
    emit(const NotesLoading());

    editNoteFieldRepository(note: note, noteField: noteField, newValue: newValue);
  }

  updateNote(Note note) {
    emit(const NotesUpdating());
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
