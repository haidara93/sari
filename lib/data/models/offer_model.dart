// ignore_for_file: non_constant_identifier_names

import 'package:custome_mobile/data/models/attachments_models.dart';

class Offer {
  int? id;
  String? orderStatus;
  String? offerType;
  int? trader;
  int? costumeBroker;
  Costumeagency? costumeagency;
  Costumestate? costumestate;
  Product? product;
  Origin? origin;
  int? packageType;
  int? packagesNum;
  int? tabalehNum;
  int? raw_material;
  int? industrial;
  double? weight;
  double? price;
  double? taxes;
  DateTime? expectedArrivalDate;
  List<Attachment>? attachments;
  String? notes;
  DateTime? createdDate;
  List<Costs>? costs;
  List<AttachmentType>? additional_attachments;
  TrackOffer? track_offer;

  Offer({
    this.id,
    this.orderStatus,
    this.offerType,
    this.trader,
    this.costumeBroker,
    this.costumeagency,
    this.costumestate,
    this.product,
    this.origin,
    this.packageType,
    this.packagesNum,
    this.tabalehNum,
    this.raw_material,
    this.industrial,
    this.weight,
    this.price,
    this.taxes,
    this.expectedArrivalDate,
    this.attachments,
    this.notes,
    this.createdDate,
    this.costs,
    this.additional_attachments,
    this.track_offer,
  });

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderStatus = json['order_status'];
    offerType = json['offer_type'];
    trader = json['trader'];
    costumeBroker = json['costume_broker'] ?? 0;
    costumeagency = json['costumeagency'] != null
        ? Costumeagency.fromJson(json['costumeagency'])
        : null;
    costumestate = json['costumestate'] != null
        ? Costumestate.fromJson(json['costumestate'])
        : null;
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    track_offer = json['track_offer'] != null
        ? TrackOffer.fromJson(json['track_offer'])
        : null;
    origin = json['origin'] != null ? Origin.fromJson(json['origin']) : null;
    packageType = json['package_type'];
    packagesNum = json['packages_num'];
    tabalehNum = json['tabaleh_num'] ?? 0;
    raw_material = json['raw_material'] ?? 0;
    industrial = json['industrial'] ?? 0;
    weight = json['weight'];
    price = json['price'];
    taxes = json['taxes'];
    expectedArrivalDate = DateTime.parse(json['expected_arrival_date']);
    if (json['attachments'] != null) {
      attachments = <Attachment>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachment.fromJson(v));
      });
    } else {
      json['attachments'] = [];
    }

    notes = json['notes'];
    createdDate = DateTime.parse(json['created_date']);
    if (json['costs'] != null) {
      costs = <Costs>[];
      json['costs'].forEach((v) {
        costs!.add(Costs.fromJson(v));
      });
    } else {
      json['costs'] = [];
    }

    if (json['aditional_attachments'] != null) {
      additional_attachments = <AttachmentType>[];
      json['aditional_attachments'].forEach((v) {
        additional_attachments!.add(AttachmentType.fromJson(v));
      });
    } else {
      json['aditional_attachments'] = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_status'] = orderStatus;
    data['offer_type'] = offerType;
    data['trader'] = trader;
    data['costume_broker'] = costumeBroker;
    if (costumeagency != null) {
      data['costumeagency'] = costumeagency!.toJson();
    }
    if (costumestate != null) {
      data['costumestate'] = costumestate!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (origin != null) {
      data['origin'] = origin!.toJson();
    }
    data['package_type'] = packageType;
    data['packages_num'] = packagesNum;
    data['tabaleh_num'] = tabalehNum;
    data['weight'] = weight;
    data['price'] = price;
    data['taxes'] = taxes;
    data['expected_arrival_date'] = expectedArrivalDate;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    data['notes'] = notes;
    data['created_date'] = createdDate;
    if (costs != null) {
      data['costs'] = costs!.map((v) => v.toJson()).toList();
    }
    if (additional_attachments != null) {
      data['aditional_attachments'] =
          additional_attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Costumeagency {
  int? id;
  String? name;
  int? statecustome;

  Costumeagency({this.id, this.name, this.statecustome});

  Costumeagency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    statecustome = json['statecustome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['statecustome'] = statecustome;
    return data;
  }
}

class Costumestate {
  int? id;
  String? name;

  Costumestate({this.id, this.name});

  Costumestate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Product {
  String? id;
  String? label;

  Product({this.id, this.label});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    return data;
  }
}

class Origin {
  int? id;
  String? label;

  Origin({this.id, this.label});

  Origin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    return data;
  }
}

class Costs {
  int? id;
  String? description;
  double? amount;

  Costs({this.id, this.description, this.amount});

  Costs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['amount'] = amount;
    return data;
  }
}

class OfferResult {
  int? id;
  String? orderStatus;
  String? offerType;
  int? trader;
  int? costumeBroker;
  int? costumeagency;
  int? costumestate;
  String? product;
  int? origin;
  int? packageType;
  int? packagesNum;
  int? tabalehNum;
  int? rawMaterial;
  int? industrial;
  int? weight;
  int? price;
  int? taxes;
  String? expectedArrivalDate;
  List<int>? attachments;
  String? notes;
  String? createdDate;

  OfferResult(
      {this.id,
      this.orderStatus,
      this.offerType,
      this.trader,
      this.costumeBroker,
      this.costumeagency,
      this.costumestate,
      this.product,
      this.origin,
      this.packageType,
      this.packagesNum,
      this.tabalehNum,
      this.rawMaterial,
      this.industrial,
      this.weight,
      this.price,
      this.taxes,
      this.expectedArrivalDate,
      this.attachments,
      this.notes,
      this.createdDate});

  OfferResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderStatus = json['order_status'];
    offerType = json['offer_type'];
    trader = json['trader'];
    costumeBroker = json['costume_broker'];
    costumeagency = json['costumeagency'];
    costumestate = json['costumestate'];
    product = json['product'];
    origin = json['origin'];
    packageType = json['package_type'];
    packagesNum = json['packages_num'];
    tabalehNum = json['tabaleh_num'];
    rawMaterial = json['raw_material'];
    industrial = json['industrial'];
    weight = json['weight'];
    price = json['price'];
    taxes = json['taxes'];
    expectedArrivalDate = json['expected_arrival_date'];
    if (json['attachments'] != null) {
      attachments = <int>[];
      json['attachments'].forEach((v) {
        attachments!.add(v);
      });
    }
    notes = json['notes'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_status'] = orderStatus;
    data['offer_type'] = offerType;
    data['trader'] = trader;
    data['costume_broker'] = costumeBroker;
    data['costumeagency'] = costumeagency;
    data['costumestate'] = costumestate;
    data['product'] = product;
    data['origin'] = origin;
    data['package_type'] = packageType;
    data['packages_num'] = packagesNum;
    data['tabaleh_num'] = tabalehNum;
    data['raw_material'] = rawMaterial;
    data['industrial'] = industrial;
    data['weight'] = weight;
    data['price'] = price;
    data['taxes'] = taxes;
    data['expected_arrival_date'] = expectedArrivalDate;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v).toList();
    }
    data['notes'] = notes;
    data['created_date'] = createdDate;
    return data;
  }
}

class TrackOffer {
  int? id;
  bool? attachmentRecivment;
  bool? unloadDistenation;
  bool? deliveryPermit;
  bool? customeDeclration;
  bool? previewGoods;
  bool? payFeesTaxes;
  bool? issuingExitPermit;
  bool? loadDistenation;

  TrackOffer(
      {this.id,
      this.attachmentRecivment,
      this.unloadDistenation,
      this.deliveryPermit,
      this.customeDeclration,
      this.previewGoods,
      this.payFeesTaxes,
      this.issuingExitPermit,
      this.loadDistenation});

  TrackOffer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attachmentRecivment = json['attachment_recivment'];
    unloadDistenation = json['unload_distenation'];
    deliveryPermit = json['delivery_permit'];
    customeDeclration = json['custome_declration'];
    previewGoods = json['preview_goods'];
    payFeesTaxes = json['pay_fees_taxes'];
    issuingExitPermit = json['Issuing_exit_permit'];
    loadDistenation = json['load_distenation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['attachment_recivment'] = this.attachmentRecivment;
    data['unload_distenation'] = this.unloadDistenation;
    data['delivery_permit'] = this.deliveryPermit;
    data['custome_declration'] = this.customeDeclration;
    data['preview_goods'] = this.previewGoods;
    data['pay_fees_taxes'] = this.payFeesTaxes;
    data['Issuing_exit_permit'] = this.issuingExitPermit;
    data['load_distenation'] = this.loadDistenation;
    return data;
  }
}
