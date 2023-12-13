import 'dart:convert';
import 'dart:io';

import 'package:custome_mobile/helpers/http_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  late SharedPreferences prefs;

  Future<dynamic> login(
      {required String username, required String password}) async {
    try {
      String? firebaseToken = "";
      FirebaseMessaging.instance.requestPermission();
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      firebaseToken = await messaging.getToken();
      // if (Platform.isIOS) {
      //   firebaseToken = await messaging.getAPNSToken();
      // } else if (Platform.isAndroid) {
      // }

      // firebaseToken = await messaging.getToken();
      print(firebaseToken);
      Response response = await HttpHelper.post(LOGIN_ENDPOINT, {
        "username": username,
        "password": password,
        "fcm_token": firebaseToken
      });
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = response.statusCode;
      var jsonObject = jsonDecode(response.body);
      print(response.statusCode);

      if (response.statusCode == 401 || response.statusCode == 400) {
        data["details"] = jsonObject["detail"];
      } else {
        presisteToken(jsonObject);
        data["token"] = jsonObject["access"];
      }
      return data;
    } catch (e) {
      print(e.toString());
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
