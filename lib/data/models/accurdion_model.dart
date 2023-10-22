// ignore_for_file: non_constant_identifier_names

class Section {
  int? id;
  String? label;
  String? name;
  String? image;
  String? start;
  String? end;
  List<ChapterSet>? chapterSet;

  Section(
      {this.id,
      this.label,
      this.name,
      this.image,
      this.start,
      this.end,
      this.chapterSet});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    name = json['name'];
    image = json['image'];
    start = json['start'];
    end = json['end'];
    if (json['chapter_set'] != null) {
      chapterSet = <ChapterSet>[];
      json['chapter_set'].forEach((v) {
        chapterSet!.add(ChapterSet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['name'] = name;
    data['image'] = image;
    data['start'] = start;
    data['end'] = end;
    if (chapterSet != null) {
      data['chapter_set'] = chapterSet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChapterSet {
  String? id;
  String? label;
  List<SubChapterSet>? subChapterSet;

  ChapterSet({this.id, this.label, this.subChapterSet});

  ChapterSet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    if (json['sub_chapter_set'] != null) {
      subChapterSet = <SubChapterSet>[];
      json['sub_chapter_set'].forEach((v) {
        subChapterSet!.add(SubChapterSet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    if (subChapterSet != null) {
      data['sub_chapter_set'] = subChapterSet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubChapterSet {
  String? id;
  String? label;

  SubChapterSet({this.id, this.label});

  SubChapterSet.fromJson(Map<String, dynamic> json) {
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

// class Section {
//   int? id;
//   String? label;
//   String? name;
//   String? image;
//   String? start;
//   String? end;
//   List<Chapter>? chapters;

//   Section({this.id, this.label, this.name, this.image, this.start, this.end});

//   Section.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     label = json['label'];
//     name = json['name'];
//     image = json['image'];
//     start = json['start'];
//     end = json['end'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['label'] = this.label;
//     data['name'] = this.name;
//     data['image'] = this.image;
//     data['start'] = this.start;
//     data['end'] = this.end;
//     return data;
//   }
// }

class Chapter {
  String? id;
  String? label;
  int? idParent1;
  List<SubChapter>? subchapters;

  Chapter({this.id, this.label, this.idParent1});

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    idParent1 = json['id_parent_1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['id_parent_1'] = idParent1;
    return data;
  }
}

class SubChapter {
  String? id;
  String? label;
  String? review;
  String? idParent2;
  List<Fee>? fees;

  SubChapter({this.id, this.label, this.review, this.idParent2});

  SubChapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    review = json['review'];
    idParent2 = json['id_parent_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['review'] = review;
    data['id_parent_2'] = idParent2;
    return data;
  }
}

class Fee {
  String? id;
  String? label;
  String? export;
  String? restrictionExport;
  String? idParent3;

  Fee(
      {this.id,
      this.label,
      this.export,
      this.restrictionExport,
      this.idParent3});

  Fee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    export = json['export'];
    restrictionExport = json['restriction_export'];
    idParent3 = json['id_parent_3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['export'] = export;
    data['restriction_export'] = restrictionExport;
    data['id_parent_3'] = idParent3;
    return data;
  }
}

class FeeSet {
  String? id;
  String? label;
  String? export;
  String? restrictionExport;
  String? review;
  String? reviewValue;
  String? idParent3;
  List<ImportFee>? importFees;
  List<StoneFarming>? stoneFarming;
  List<Finance>? finance;

  FeeSet(
      {this.id,
      this.label,
      this.export,
      this.restrictionExport,
      this.review,
      this.reviewValue,
      this.idParent3,
      this.importFees,
      this.stoneFarming,
      this.finance});

  FeeSet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    export = json['export'];
    restrictionExport = json['restriction_export'];
    review = json['review'];
    reviewValue = json['review_value'];
    idParent3 = json['id_parent_3'];
    if (json['import_fees'] != null) {
      importFees = <ImportFee>[];
      json['import_fees'].forEach((v) {
        importFees!.add(ImportFee.fromJson(v));
      });
    }
    if (json['stone_farming'] != null) {
      stoneFarming = <StoneFarming>[];
      json['stone_farming'].forEach((v) {
        stoneFarming!.add(StoneFarming.fromJson(v));
      });
    }
    if (json['finance'] != null) {
      finance = <Finance>[];
      json['finance'].forEach((v) {
        finance!.add(Finance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['export'] = export;
    data['restriction_export'] = restrictionExport;
    data['review'] = review;
    data['review_value'] = reviewValue;
    data['id_parent_3'] = idParent3;
    // if (this.importFees != null) {
    //   data['import_fees'] = this.importFees!.map((v) => v.toJson()).toList();
    // }
    if (stoneFarming != null) {
      data['stone_farming'] = stoneFarming!.map((v) => v.toJson()).toList();
    }
    // if (this.finance != null) {
    //   data['finance'] = this.finance!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class StoneFarming {
  String? id;
  String? stonImport;
  String? stonImportNotes;
  String? stonExport;
  String? stonExportNotes;
  String? idStone;

  StoneFarming(
      {this.id,
      this.stonImport,
      this.stonImportNotes,
      this.stonExport,
      this.stonExportNotes,
      this.idStone});

  StoneFarming.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stonImport = json['ston_import'];
    stonImportNotes = json['ston_import_notes'];
    stonExport = json['ston_export'];
    stonExportNotes = json['ston_export_notes'];
    idStone = json['id_stone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ston_import'] = stonImport;
    data['ston_import_notes'] = stonImportNotes;
    data['ston_export'] = stonExport;
    data['ston_export_notes'] = stonExportNotes;
    data['id_stone'] = idStone;
    return data;
  }
}

class ImportFee {
  String? id;
  String? id_importfee;
  String? restriction_import;
  String? document_import;

  ImportFee({
    this.id,
    this.id_importfee,
    this.restriction_import,
    this.document_import,
  });

  ImportFee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_importfee = json['id_importfee'];
    restriction_import = json['restriction_import'];
    document_import = json['document_import'];
  }
}

class Finance {
  String? id;
  String? id_finance;
  String? finance;

  Finance({
    this.id,
    this.id_finance,
    this.finance,
  });

  Finance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_finance = json['id_finance'];
    finance = json['finance'];
  }
}

class TradeDescription {
  List<CommercialDescriptions>? commercialDescriptions;
  List<ImageDescriptions>? imageDescriptions;

  TradeDescription({this.commercialDescriptions, this.imageDescriptions});

  TradeDescription.fromJson(Map<String, dynamic> json) {
    if (json['commercial_descriptions'] != null) {
      commercialDescriptions = <CommercialDescriptions>[];
      json['commercial_descriptions'].forEach((v) {
        commercialDescriptions!.add(CommercialDescriptions.fromJson(v));
      });
    }
    if (json['image_descriptions'] != null) {
      imageDescriptions = <ImageDescriptions>[];
      json['image_descriptions'].forEach((v) {
        imageDescriptions!.add(ImageDescriptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (commercialDescriptions != null) {
      data['commercial_descriptions'] =
          commercialDescriptions!.map((v) => v.toJson()).toList();
    }
    if (imageDescriptions != null) {
      data['image_descriptions'] =
          imageDescriptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommercialDescriptions {
  String? id;
  String? secondDescription;
  String? idDesc;

  CommercialDescriptions({this.id, this.secondDescription, this.idDesc});

  CommercialDescriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secondDescription = json['second_description'];
    idDesc = json['id_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['second_description'] = secondDescription;
    data['id_desc'] = idDesc;
    return data;
  }
}

class ImageDescriptions {
  String? id;
  String? image;
  String? idDesc;

  ImageDescriptions({this.id, this.image, this.idDesc});

  ImageDescriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    idDesc = json['id_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['id_desc'] = idDesc;
    return data;
  }
}

class SectionNote {
  String? id;
  String? noteA;
  String? noteB;
  String? noteC;
  String? noteD;
  String? noteE;
  String? noteNum;
  // int? idSection;

  SectionNote({
    this.id,
    this.noteA,
    this.noteB,
    this.noteC,
    this.noteD,
    this.noteE,
    this.noteNum,
  });

  SectionNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteA = json['note_a'];
    noteB = json['note_b'] ?? "";
    noteC = json['note_c'] ?? "";
    noteD = json['note_d'] ?? "";
    noteE = json['note_e'] ?? "";
    noteNum = json['note_num'];
    // idSection = json['id_section'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note_a'] = noteA;
    data['note_b'] = noteB;
    data['note_c'] = noteC;
    data['note_num'] = noteNum;
    // data['id_section'] = this.idSection;
    return data;
  }
}
