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
  int? statecustome;

  CustomeAgency({this.id, this.name, this.statecustome});

  CustomeAgency.fromJson(Map<String, dynamic> json) {
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

  PackageType({this.id, this.name, this.image});

  PackageType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
