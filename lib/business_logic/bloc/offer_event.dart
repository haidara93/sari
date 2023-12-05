part of 'offer_bloc.dart';

class OfferEvent extends Equatable {
  const OfferEvent();

  @override
  List<Object> get props => [];
}

class OfferInit extends OfferEvent {}

class OfferLoadEvent extends OfferEvent {}

class OfferStatusUpdateEvent extends OfferEvent {
  final int offerId;
  final String state;

  const OfferStatusUpdateEvent(this.offerId, this.state);
}

// class AddAdditionalAttachmentEvent extends OfferEvent {
//   final List<int> additionalList;
//   final List<int> attachments;
//   final int offerId;

//   AddAdditionalAttachmentEvent(
//       this.attachments, this.additionalList, this.offerId);
// }

class AddOfferEvent extends OfferEvent {
  final String offerType;
  final int packageNum;
  final int tabalehNum;
  final int weight;
  final int price;
  final int taxes;
  final int costumeAgency;
  final int costumeState;
  final int origin;
  final int packageType;
  final int rawMaterial;
  final int industrial;
  final String expectedDate;
  final String notes;
  final String product;
  final List<int> attachments;

  const AddOfferEvent(
      this.offerType,
      this.packageNum,
      this.tabalehNum,
      this.weight,
      this.price,
      this.taxes,
      this.costumeAgency,
      this.costumeState,
      this.origin,
      this.packageType,
      this.expectedDate,
      this.notes,
      this.product,
      this.attachments,
      this.rawMaterial,
      this.industrial);
}
