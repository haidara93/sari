part of 'additional_attachment_bloc.dart';

class AdditionalAttachmentEvent extends Equatable {
  const AdditionalAttachmentEvent();

  @override
  List<Object> get props => [];
}

class AddAdditionalAttachmentEvent extends AdditionalAttachmentEvent {
  final int type;
  final File image;
  final int offerId;
  final String offerState;
  final List<int> attachments;
  final List<AttachmentType> additionalattachments;
  // final File file;

  const AddAdditionalAttachmentEvent(this.type, this.image, this.offerId,
      this.offerState, this.attachments, this.additionalattachments);
}
