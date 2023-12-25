class UserProfile {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? image;
  int? trader;

  UserProfile(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.image,
      this.trader});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    image = json['image'] ?? "";
    trader = json['trader'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    data['trader'] = this.trader;
    return data;
  }
}
