part of 'notes_cubit.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesInitial extends NotesState {
  const NotesInitial();
}

class NotesLoading extends NotesState {
  const NotesLoading();
}

class NotesUpdating extends NotesState {
  const NotesUpdating();
}

class NotesLoaded extends NotesState {
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

class NotesError extends NotesState {
  final String message;
  const NotesError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotesError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
