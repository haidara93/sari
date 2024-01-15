import 'package:custome_mobile/data/models/state_custome_agency_model.dart';

class UserProfile {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? image;
  int? trader;
  int? costumebroker;

  UserProfile({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.image,
    this.trader,
    this.costumebroker,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    image = json['image'] ?? "";
    trader = json['trader'] ?? 0;
    costumebroker = json['costumebroker'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    data['trader'] = this.trader;
    data['costumebroker'] = this.costumebroker;
    return data;
  }
}

class CostumBroker {
  int? id;
  UserProfile? user;
  List<CustomeAgency>? agencies;
  int? rating;

  CostumBroker({this.id, this.user, this.agencies, this.rating});

  CostumBroker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new UserProfile.fromJson(json['user']) : null;
    if (json['agencies'] != null) {
      agencies = <CustomeAgency>[];
      json['agencies'].forEach((v) {
        agencies!.add(new CustomeAgency.fromJson(v));
      });
    }
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.agencies != null) {
      data['agencies'] = this.agencies!.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    return data;
  }
}
