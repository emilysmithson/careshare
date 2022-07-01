import 'package:bloc/bloc.dart';
import 'package:careshare/note_manager/models/note.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {

  NoteCubit() : super(const NoteInitial());

  late Note note;

  Future fetchNote({
    required String noteId,
  }) async {
    try {
      print('.....fetching note for: $noteId');

      emit(const NoteLoading());

      final reference = FirebaseDatabase.instance.ref('notes/$noteId');
      final response = reference.onValue;
      response.listen((event) {
        emit(const NoteLoading());
        if (event.snapshot.value == null) {
          emit(NoteError("note not found"));

        } else {

          final data = event.snapshot.value;
          note = Note.fromJson(noteId, data);
          // print('-----loaded profile: ${myProfile.email}');
          emit(NoteLoaded(
            note: note
          ));

        }
      });
    } catch (error) {
      emit(NoteError(error.toString()));
    }
  }

}
