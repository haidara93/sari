import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:flutter/material.dart';

class BrokerOfferProvider extends ChangeNotifier {
  int? _id;
  int? get id => _id;

  String? _orderStatus;
  String? get orderStatus => _orderStatus;

  String? _offerType;
  String? get offerType => _offerType;

  int? _trader;
  int? get trader => _trader;

  int? _costumeBroker;
  int? get costumeBroker => _costumeBroker;

  Costumeagency? _costumeagency;
  Costumeagency? get costumeagency => _costumeagency;

  Costumestate? _costumestate;
  Costumestate? get costumestate => _costumestate;

  Product? _product;
  Product? get product => _product;

  Origin? _origin;
  Origin? get origin => _origin;

  int? _packageType;
  int? get packageType => _packageType;

  int? _packagesNum;
  int? get packagesNum => _packagesNum;

  int? _tabalehNum;
  int? get tabalehNum => _tabalehNum;

  int? _raw_material;
  int? get raw_material => _raw_material;

  int? _industrial;
  int? get industrial => _industrial;

  double? _weight;
  double? get weight => _weight;

  double? _price;
  double? get price => _price;

  double? _taxes;
  double? get taxes => _taxes;

  DateTime? _expectedArrivalDate;
  DateTime? get expectedArrivalDate => _expectedArrivalDate;

  List<Attachment>? _attachments;
  List<Attachment>? get attachments => _attachments;

  String? _notes;
  String? get notes => _notes;

  DateTime? _createdDate;
  DateTime? get createdDate => _createdDate;

  List<Costs>? _costs;
  List<Costs>? get costs => _costs;

  List<AttachmentType>? _additional_attachments;
  List<AttachmentType>? get additional_attachments => _additional_attachments;

  TrackOffer? _track_offer;
  TrackOffer? get track_offer => _track_offer;

  initOffer(Offer value) {
    _id = value.id;
    _orderStatus = value.orderStatus;
    _offerType = value.offerType;
    _trader = value.trader;
    _costumeBroker = value.costumeBroker;
    _costumeagency = value.costumeagency;
    _costumestate = value.costumestate;
    _product = value.product;
    _origin = value.origin;
    _packageType = value.packageType;
    _packagesNum = value.packagesNum;
    _tabalehNum = value.tabalehNum;
    _raw_material = value.raw_material;
    _industrial = value.industrial;
    _weight = value.weight;
    _price = value.price;
    _taxes = value.taxes;
    _expectedArrivalDate = value.expectedArrivalDate;
    _attachments = value.attachments;
    _notes = value.notes;
    _createdDate = value.createdDate;
    _costs = value.costs;
    _additional_attachments = value.additional_attachments;
    _track_offer = value.track_offer;
    notifyListeners();
  }

  updateTracking(TrackOffer value) {
    _track_offer = value;
    notifyListeners();
  }
}
