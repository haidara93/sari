class AttachmentType {
  int? id;
  String? name;
  String? image;

  AttachmentType({this.id, this.name, this.image});

  AttachmentType.fromJson(Map<String, dynamic> json) {
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

class Attachment {
  int? id;
  String? file;
  String? image;
  int? attachmentType;
  int? user;

  Attachment({this.id, this.file, this.image, this.attachmentType, this.user});

  Attachment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    image = json['image'];
    attachmentType = json['attachment_type'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = file;
    data['image'] = image;
    data['attachment_type'] = attachmentType;
    data['user'] = user;
    return data;
  }
}
