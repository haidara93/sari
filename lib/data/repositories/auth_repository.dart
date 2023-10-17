import 'dart:convert';

import 'package:custome_mobile/helpers/http_helper.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  late SharedPreferences prefs;

  Future<dynamic> login(
      {required String username, required String password}) async {
    try {
      Response response = await HttpHelper.post(
          LOGIN_ENDPOINT, {"username": username, "password": password});
      final Map<String, dynamic> data = Map<String, dynamic>();
      data["status"] = response.statusCode;

      var jsonObject = jsonDecode(response.body);
      print(response.statusCode);
      if (response.statusCode == 401) {
        data["details"] = jsonObject["details"];
      } else {
        presisteToken(jsonObject);
        data["token"] = jsonObject["access"];
      }
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> get jwtOrEmpty async {
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    if (jwt == null) return "";
    return jwt;
  }

  Future<bool> isAuthenticated() async {
    var prefs = await SharedPreferences.getInstance();

    var token = await jwtOrEmpty;

    if (token != "") {
      var str = token;
      var jwt = str.split(".");

      if (jwt.length != 3) {
        return false;
      } else {
        var payload =
            json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
        if (DateTime.fromMillisecondsSinceEpoch(
                (payload["exp"].toInt()) * 100000)
            .isAfter(DateTime.now())) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Future<void> presisteToken(dynamic data) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("token", data["access"]);
    prefs.setString("refresh", data["refresh"]);
  }

  Future<void> deleteToken() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.clear();
  }
}
