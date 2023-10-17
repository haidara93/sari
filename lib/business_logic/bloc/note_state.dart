part of 'note_bloc.dart';

class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoadingProgress extends NoteState {}

class NoteLoadedSuccess extends NoteState {
  final List<SectionNote> notes;

  NoteLoadedSuccess(this.notes);
}

class NoteLoadedFailed extends NoteState {
  final String error;

  NoteLoadedFailed(this.error);
}
