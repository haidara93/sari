import 'dart:convert';
import 'dart:io';

import 'package:custome_mobile/data/models/attachments_models.dart';
import 'package:custome_mobile/data/models/offer_model.dart';
import 'package:custome_mobile/data/models/package_model.dart';
import 'package:custome_mobile/data/models/state_custome_agency_model.dart';
import 'package:custome_mobile/helpers/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StateAgencyRepository {
  List<Offer> offers = [];
  List<StateCustome> states = [];
  List<CustomeAgency> agencies = [];
  List<PackageType> packageTypes = [];
  List<AttachmentType> attachmentTypes = [];
  late SharedPreferences prefs;

  Future<List<StateCustome>> getstates() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(STATE_CUSTOMES_ENDPOINT, apiToken: jwt);
    states = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        states.add(StateCustome.fromJson(element));
      }
    }
    return states;
  }

  Future<List<CustomeAgency>> getagencies(int id) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get('$STATE_CUSTOMES_ENDPOINT$id/agencies/',
        apiToken: jwt);
    agencies = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        agencies.add(CustomeAgency.fromJson(element));
      }
    }
    return agencies;
  }

  Future<List<PackageType>> getPackageTypes() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(PACKAGE_TYPES_ENDPOINT, apiToken: jwt);
    packageTypes = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        packageTypes.add(PackageType.fromJson(element));
      }
    }
    return packageTypes;
  }

  Future<List<AttachmentType>> getAttachmentTypes() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(ATTACHMENT_TYPES_ENDPOINT, apiToken: jwt);
    attachmentTypes = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        attachmentTypes.add(AttachmentType.fromJson(element));
      }
    }
    return attachmentTypes;
  }

  Future<Attachment?> postAttachment(File image, int attachmentTypeId) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var jwt = token!.split(".");
    var payload =
        json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));

    var request =
        http.MultipartRequest('POST', Uri.parse(ATTACHMENTS_ENDPOINT));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "JWT $token",
      HttpHeaders.contentTypeHeader: "multipart/form-data"
    });
    // for (var img in _imageFileList!) {
    //   var result = await FlutterImageCompress.compressAndGetFile(
    //     img.path,
    //     img.path + "temp.jpg",
    //     quality: 85,
    //   );
    //   var multipartFile = await http.MultipartFile.fromPath(
    //     'real_estate_images[]',
    //     result!.path,
    //     filename: img.path.split('/').last,
    //   );
    //   newList.add(multipartFile);
    // }
    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      image.path,
      filename: image.path.split('/').last,
    );
    request.files.add(multipartFile);

    request.fields['attachment_type'] = attachmentTypeId.toString();
    request.fields['user'] = payload["user_id"].toString();
    var response = await request.send();
    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      return Attachment.fromJson(res);
    } else {
      final respStr = await response.stream.bytesToString();
      return null;
    }
  }

  Future<CalculatorResult> getCalculatorResult(CalculateObject cal) async {
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var url =
        'https://across-mena.com/Fee_calculator/calculate/?insurance=${cal.insurance}&fee=${cal.fee}&raw_material=${cal.rawMaterial}&industrial=${cal.industrial}&origin=${cal.origin}&total_tax=${cal.totalTax}&partial_tax=${cal.partialTax}&spending_fee=${cal.spendingFee}&local_fee=${cal.localFee}&support_fee=${cal.supportFee}&protection_fee=${cal.protectionFee}&natural_fee=${cal.naturalFee}&tax_fee=${cal.taxFee}&weight=${cal.weight}&price=${cal.price}&cnsulate=${cal.cnsulate}&dolar=${cal.dolar}&arabic_stamp=${cal.arabic_stamp}&import_fee=${cal.import_fee}';
    var response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'JWT $jwt'
    });
    var myDataString = utf8.decode(response.bodyBytes);
    print(myDataString);
    var json = jsonDecode(myDataString);
    var result = CalculatorResult.fromJson(json);
    print(
        '${result.customsFee}\n${result.finalTaxes}\n${result.finalTotal}\n${result.reconstructionFee}\n${result.finalFee}');
    return result;
  }

  Future<Offer?> postOffer(
    String? offerType,
    int? packagesNum,
    int? tabalehNum,
    int? weight,
    int? price,
    int? taxes,
    String? expectedArrivalDate,
    String? notes,
    int? costumeagency,
    int? costumestate,
    String? product,
    int? origin,
    int? packageType,
    List<int>? attachments,
    int? rawMaterial,
    int? industrial,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var jwt = token!.split(".");
    var payload =
        json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
    var response = await HttpHelper.post(OFFERS_ENDPOINT, apiToken: token, {
      "offer_type": offerType,
      "trader": payload["user_id"].toInt(),
      "costumeagency": costumeagency,
      "costumestate": costumestate,
      "product": product,
      "origin": origin,
      "package_type": packageType,
      "packages_num": packagesNum,
      "tabaleh_num": tabalehNum,
      "raw_material": rawMaterial,
      "industrial": industrial,
      "weight": weight,
      "price": price,
      "taxes": taxes,
      "expected_arrival_date": expectedArrivalDate,
      "attachments": attachments,
      "notes": notes
    });

    // print(jsonEncode({
    //   "offer_type": offerType,
    //   "trader": payload["user_id"].toInt(),
    //   "costumeagency": costumeagency,
    //   "costumestate": costumestate,
    //   "product": product,
    //   "origin": origin,
    //   "package_type": packageType,
    //   "packages_num": packagesNum,
    //   "tabaleh_num": tabalehNum,
    //   "raw_material": rawMaterial,
    //   "industrial": industrial,
    //   "weight": weight,
    //   "price": price,
    //   "taxes": taxes,
    //   "expected_arrival_date": expectedArrivalDate,
    //   "attachments": attachments,
    //   "notes": notes
    // }));
    var jsonObject = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return Offer.fromJson(jsonObject);
    } else {
      return null;
    }
  }

  Future<List<Offer>> getBrokerOffers() async {
    offers = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var response = await HttpHelper.get(
      OFFERS_ENDPOINT,
      apiToken: jwt,
    );
    var myDataString = utf8.decode(response.bodyBytes);
    var json = jsonDecode(myDataString);
    if (response.statusCode == 200) {
      for (var element in json) {
        offers.add(Offer.fromJson(element));
      }

      return offers;
    } else {
      return offers;
    }
  }

  Future<List<Offer>> getTraderLogOffers(String state) async {
    offers = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var response = await HttpHelper.get(
      "$OFFERS_ENDPOINT?order_status=$state",
      apiToken: jwt,
    );
    var myDataString = utf8.decode(response.bodyBytes);
    var json = jsonDecode(myDataString);
    if (response.statusCode == 200) {
      for (var element in json) {
        offers.add(Offer.fromJson(element));
      }

      return offers;
    } else {
      return offers;
    }
  }

  Future<bool> updateOfferState(String state, int offerId) async {
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var response = await HttpHelper.patch(
      "$OFFERS_ENDPOINT$offerId/",
      {"order_status": state},
      apiToken: jwt,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateOfferAditionalAttachments(
      List<int> attachments, List<int> additional, int offerId) async {
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var response = await HttpHelper.patch(
      "$OFFERS_ENDPOINT$offerId/",
      {"attachments": attachments, "aditional_attachments": additional},
      apiToken: jwt,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createCosts(List<Cost> costs) async {
    const url = '${DOMAIN}api/create_costs/';
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    final List<Map<String, dynamic>> costDataList = costs.map((cost) {
      return {
        'description': cost.description,
        'amount': cost.amount.toString(),
        'offer': cost.offerId.toString()
        // Add any other fields from the Cost object as needed
      };
    }).toList();

    final jsonData = jsonEncode(costDataList);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'JWT $jwt'
        },
        body: jsonData,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
