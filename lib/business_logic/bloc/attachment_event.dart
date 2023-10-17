part of 'attachment_bloc.dart';

class AttachmentEvent extends Equatable {
  const AttachmentEvent();

  @override
  List<Object> get props => [];
}

class AddAttachmentEvent extends AttachmentEvent {
  final int type;
  final File image;
  // final File file;

  const AddAttachmentEvent(this.type, this.image);
}
