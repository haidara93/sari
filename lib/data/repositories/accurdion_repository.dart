import 'dart:convert';

import 'package:custome_mobile/constants/enums.dart';
import 'package:custome_mobile/data/models/accurdion_model.dart';
import 'package:custome_mobile/helpers/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccordionRepository {
  late SharedPreferences prefs;
  List<Section> sections = [];
  List<Chapter> chapters = [];
  List<SubChapter> subchapters = [];
  List<FeeSet> fees = [];
  List<SectionNote> notes = [];

  Future<List<Section>> getSections() async {
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

  Future<List<Chapter>> getChapters(int sectionId) async {
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
}
