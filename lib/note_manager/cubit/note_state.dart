part of 'note_cubit.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {
  const NoteInitial();
}

class NotesLoading extends NoteState {
  const NotesLoading();
}

class NoteUpdating extends NoteState {
  const NoteUpdating();
}

class NotesLoaded extends NoteState {
  final List<Note> noteList;

  const NotesLoaded({
    required this.noteList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotesLoaded && listEquals(other.noteList, noteList);
  }

  @override
  int get hashCode => noteList.hashCode;
}

class NoteError extends NoteState {
  final String message;
  const NoteError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
