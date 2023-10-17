part of 'note_bloc.dart';

class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class NoteLoadEvent extends NoteEvent {
  final String id;
  final NoteType type;

  NoteLoadEvent(this.id, this.type);
}
