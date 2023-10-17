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
  });

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderStatus = json['order_status'];
    offerType = json['offer_type'];
    trader = json['trader'];
    costumeBroker = json['costume_broker'] ?? 1;
    costumeagency = json['costumeagency'] != null
        ? Costumeagency.fromJson(json['costumeagency'])
        : null;
    costumestate = json['costumestate'] != null
        ? Costumestate.fromJson(json['costumestate'])
        : null;
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
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
