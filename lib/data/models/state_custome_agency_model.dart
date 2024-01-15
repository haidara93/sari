class Cost {
  int? id;
  String? description;
  double? amount;
  int? offerId;

  Cost({this.id, this.description, this.amount, this.offerId});

  Cost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    amount = json['amount'];
    offerId = json['offer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['amount'] = amount;
    data['offer'] = offerId;
    return data;
  }
}

class CustomeAgency {
  int? id;
  String? name;
  StateCustome? statecustome;
  String? shippingType;
  CustomeAgency({this.id, this.name, this.statecustome, this.shippingType});

  CustomeAgency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shippingType = json['shipping_type'];
    statecustome = json['statecustome'] != null
        ? new StateCustome.fromJson(json['statecustome'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['shipping_type'] = shippingType;
    if (this.statecustome != null) {
      data['statecustome'] = this.statecustome!.toJson();
    }
    return data;
  }
}

class StateCustome {
  int? id;
  String? name;

  StateCustome({this.id, this.name});

  StateCustome.fromJson(Map<String, dynamic> json) {
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

class PackageType {
  int? id;
  String? name;
  String? image;
  String? activeImage;

  PackageType({this.id, this.name, this.image, this.activeImage});

  PackageType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    activeImage = json['active_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['active_image'] = activeImage;
    return data;
  }
}
