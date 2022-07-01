part of 'note_cubit.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {
  const NoteInitial();
}

class NoteLoading extends NoteState {
  const NoteLoading();
}

class NoteUpdating extends NoteState {
  const NoteUpdating();
}

class NoteLoaded extends NoteState {
  final Note note;

  const NoteLoaded({
    required this.note,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteLoaded && (identical(other.note, note));
  }

  @override
  int get hashCode => note.hashCode;
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
