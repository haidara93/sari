import 'dart:convert';

import 'package:custome_mobile/constants/enums.dart';
import 'package:custome_mobile/data/models/accurdion_model.dart';
import 'package:custome_mobile/helpers/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccordionRepository {
  late SharedPreferences prefs;
  List<Section?> sections = [];
  List<Chapter> chapters = [];
  List<SubChapter> subchapters = [];
  List<FeeSet> fees = [];
  List<SectionNote> notes = [];

  Future<List<Section?>> getSections() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(ACCURDION_SECTION_ENDPOINT, apiToken: jwt);
    sections = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        sections.add(Section.fromJson(element));
      }
    }
    return sections;
  }

  Future<List<Chapter>> getChapters(String sectionId) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get("$ACCURDION_CHAPTERS_ENDPOINT$sectionId/",
        apiToken: jwt);
    chapters = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result["chapters"]) {
        chapters.add(Chapter.fromJson(element));
      }
    }
    return chapters;
  }

  Future<List<SubChapter>> getSubChapters(String chapterId) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get("$ACCURDION_SUBCHAPTERS_ENDPOINT$chapterId/",
        apiToken: jwt);
    subchapters = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result["sub_chapters"]) {
        subchapters.add(SubChapter.fromJson(element));
      }
    }
    return subchapters;
  }

  Future<List<FeeSet>> getFees(String subchapterId) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var rs = await HttpHelper.get("$ACCURDION_FEES_ENDPOINT$subchapterId/",
        apiToken: jwt);
    fees = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);
      var result = jsonDecode(myDataString);
      for (var element in result["fees"]) {
        fees.add(FeeSet.fromJson(element));
      }
    }
    return fees;
  }

  Future<TradeDescription?> getFeeTradeDescription(String feeId) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(
        "$ACCURDION_FEES_TRADE_DESCRIPTION_ENDPOINT$feeId/",
        apiToken: jwt);
    // ignore: prefer_typing_uninitialized_variables
    late var feedescription;
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      feedescription = TradeDescription.fromJson(result);
    }
    return feedescription;
  }

  Future<List<SectionNote>> getNotes(String id, NoteType type) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    // ignore: prefer_typing_uninitialized_variables
    var rs;

    switch (type) {
      case NoteType.Section:
        {
          rs = await HttpHelper.get("$SECTION_NOTES_ENDPOINT$id/",
              apiToken: jwt);
          break;
        }
      case NoteType.Chapter:
        {
          rs = await HttpHelper.get("$CHAPTER_NOTES_ENDPOINT$id/",
              apiToken: jwt);
          break;
        }
      case NoteType.SubChapter:
        {
          rs = await HttpHelper.get("$SUBCHAPTER_NOTES_ENDPOINT$id/",
              apiToken: jwt);
          break;
        }
      case NoteType.Fee:
        {
          rs = await HttpHelper.get("$FEE_NOTES_ENDPOINT$id/", apiToken: jwt);
          break;
        }
      default:
    }
    notes = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        notes.add(SectionNote.fromJson(element));
      }
    }
    return notes;
  }

  Future<List<Section?>> searchForItem(String query) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    List<ChapterSearch> chapterSearch = [];
    List<SubChapterSearch> subchapterSearch = [];
    List<FeeSearch> feeSearch = [];
    var rs = await HttpHelper.get(SEARCH_QUERY_ENDPOINT + query, apiToken: jwt);
    sections = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      if (result['Chapter'] != null) {
        for (var element in result['Chapter']) {
          chapterSearch.add(ChapterSearch.fromJson(element['data'][0]));
        }
      }
      if (result['Sub_Chapter'] != null) {
        for (var element in result['Sub_Chapter']) {
          subchapterSearch.add(SubChapterSearch.fromJson(element['data'][0]));
        }
      }
      if (result['Fee'] != null) {
        for (var element in result['Fee']) {
          feeSearch.add(FeeSearch.fromJson(element['data'][0]));
        }
      }

      for (var element in chapterSearch) {
        if ((sections.singleWhere((it) => it!.id == element.idParent1!.id,
                orElse: () => null)) !=
            null) {
          var feesection = sections.singleWhere(
              (it) => it!.id == element.idParent1!.id,
              orElse: () => null);
          if (feesection!.chapterSet == null) {
            feesection.chapterSet = [];
          }
          feesection.chapterSet!.add(ChapterSet(
              id: element.id, label: element.label, subChapterSet: []));
        } else {
          sections.add(Section(
            id: element.idParent1!.id!,
            label: element.idParent1!.label,
            start: element.idParent1!.start,
            end: element.idParent1!.end,
            image: element.idParent1!.image,
            chapterSet: [
              ChapterSet(
                id: element.id,
                label: element.label,
                subChapterSet: [],
              )
            ],
          ));
        }
      }

      for (var subch in subchapterSearch) {
        if ((sections.singleWhere(
                (it) => it!.id == subch.idParent2!.idParent1!.id,
                orElse: () => null)) !=
            null) {
          var feesection = sections.singleWhere(
              (it) => it!.id == subch.idParent2!.idParent1!.id,
              orElse: () => null);
          var chapterSetlist = feesection!.chapterSet!;
          for (var ch in chapterSetlist) {
            if ((feesection.chapterSet!.singleWhere(
                    (it) => it!.id == subch.idParent2!.id,
                    orElse: () => null)) !=
                null) {
              var feechapter = feesection.chapterSet!.singleWhere(
                  (it) => it!.id == subch.idParent2!.id,
                  orElse: () => null);
              feechapter!.subChapterSet ??= [];
              feechapter.subChapterSet!.add(SubChapterSet(
                id: subch.id,
                label: subch.label,
              ));
            } else {
              var newChapter = ChapterSet(
                id: subch.idParent2!.id,
                label: subch.idParent2!.label,
                subChapterSet: [
                  SubChapterSet(id: subch.id, label: subch.label, feeSet: [])
                ],
              );
              feesection!.chapterSet = [...feesection.chapterSet!, newChapter];
            }
          }
        } else {
          sections.add(
            Section(
              id: subch.idParent2!.idParent1!.id!,
              label: subch.idParent2!.idParent1!.label,
              start: subch.idParent2!.idParent1!.start,
              end: subch.idParent2!.idParent1!.end,
              image: subch.idParent2!.idParent1!.image,
              chapterSet: [
                ChapterSet(
                  id: subch.idParent2!.id,
                  label: subch.idParent2!.label,
                  subChapterSet: [
                    SubChapterSet(
                      id: subch.id,
                      label: subch.label,
                    )
                  ],
                )
              ],
            ),
          );
        }
      }

      bool chexist = false;
      bool subchexist = false;
      bool feeexist = false;

      for (var fee in feeSearch) {
        if ((sections.singleWhere(
                (it) => it!.id == fee.idParent3!.idParent2!.idParent1!.id,
                orElse: () => null)) !=
            null) {
          var feesection = sections.singleWhere(
              (it) => it!.id == fee.idParent3!.idParent2!.idParent1!.id,
              orElse: () => null);
          var chapterSetlist = feesection!.chapterSet!;
          for (var ch in chapterSetlist) {
            if ((feesection.chapterSet!.singleWhere(
                    (it) => it!.id == fee.idParent3!.idParent2!.id,
                    orElse: () => null)) !=
                null) {
              var feechapter = feesection.chapterSet!.singleWhere(
                  (it) => it!.id == fee.idParent3!.idParent2!.id,
                  orElse: () => null);
              var subChapterSetlist = feechapter!.subChapterSet!;
              for (var subch in subChapterSetlist.toList()) {
                if ((feechapter.subChapterSet!.singleWhere(
                        (it) => it!.id == fee.idParent3!.id,
                        orElse: () => null)) !=
                    null) {
                  var feesubchapter = feechapter.subChapterSet!.singleWhere(
                      (it) => it!.id == fee.idParent3!.id,
                      orElse: () => null);
                  feesubchapter!.feeSet ??= [];
                  feesubchapter.feeSet!.add(
                    FeeSet(
                      id: fee.id,
                      label: fee.label,
                      export: fee.export,
                      finance: fee.finance,
                      importFees: fee.importFees,
                      restrictionExport: fee.restrictionExport,
                      review: fee.review,
                      stoneFarming: fee.stoneFarming,
                      reviewValue: fee.reviewValue,
                    ),
                  );
                } else {
                  var newSubChapter = SubChapterSet(
                    id: fee.idParent3!.id,
                    label: fee.idParent3!.label,
                    feeSet: [
                      FeeSet(
                        id: fee.id,
                        label: fee.label,
                        export: fee.export,
                        finance: fee.finance,
                        importFees: fee.importFees,
                        restrictionExport: fee.restrictionExport,
                        review: fee.review,
                        stoneFarming: fee.stoneFarming,
                        reviewValue: fee.reviewValue,
                      ),
                    ],
                  );
                  feechapter!.subChapterSet = [
                    ...feechapter.subChapterSet!,
                    newSubChapter
                  ];
                }
              }
            } else {
              var newChapter = ChapterSet(
                id: fee.idParent3!.idParent2!.id,
                label: fee.idParent3!.idParent2!.label,
                subChapterSet: [
                  SubChapterSet(
                    id: fee.idParent3!.id,
                    label: fee.idParent3!.label,
                    feeSet: [
                      FeeSet(
                        id: fee.id,
                        label: fee.label,
                        export: fee.export,
                        finance: fee.finance,
                        importFees: fee.importFees,
                        restrictionExport: fee.restrictionExport,
                        review: fee.review,
                        stoneFarming: fee.stoneFarming,
                        reviewValue: fee.reviewValue,
                      ),
                    ],
                  )
                ],
              );

              feesection!.chapterSet = [...feesection.chapterSet!, newChapter];
            }
          }
        } else {
          sections.add(Section(
            id: fee.idParent3!.idParent2!.idParent1!.id!,
            label: fee.idParent3!.idParent2!.idParent1!.label,
            start: fee.idParent3!.idParent2!.idParent1!.start,
            end: fee.idParent3!.idParent2!.idParent1!.end,
            image: fee.idParent3!.idParent2!.idParent1!.image,
            chapterSet: [
              ChapterSet(
                id: fee.idParent3!.idParent2!.id,
                label: fee.idParent3!.idParent2!.label,
                subChapterSet: [
                  SubChapterSet(
                    id: fee.idParent3!.id,
                    label: fee.idParent3!.label,
                    feeSet: [
                      FeeSet(
                        id: fee.id,
                        label: fee.label,
                        export: fee.export,
                        finance: fee.finance,
                        importFees: fee.importFees,
                        restrictionExport: fee.restrictionExport,
                        review: fee.review,
                        stoneFarming: fee.stoneFarming,
                        reviewValue: fee.reviewValue,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ));
        }
      }
    }

    return sections;
  }
}
