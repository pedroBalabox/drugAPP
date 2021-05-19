import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  String get clientData => _sharedPrefs.getString(userData) ?? "";

  set clientData(String value) {
    _sharedPrefs.setString(userData, value);
  }

  String get partnerUserData => _sharedPrefs.getString(partnerData) ?? "";

  set partnerUserData(String value) {
    _sharedPrefs.setString(partnerData, value);
  }

  String get fcmToken => _sharedPrefs.getString('fcm_token') ?? "";

  set fcmToken(String value) {
    _sharedPrefs.setString('fcm_token', value);
  }

  String get clientToken => _sharedPrefs.getString(userToken) ?? "";

  set clientToken(String value) {
    _sharedPrefs.setString(userToken, value);
  }

  String get partnerUserToken => _sharedPrefs.getString(partnerToken) ?? "";

  set partnerUserToken(String value) {
    _sharedPrefs.setString(partnerToken, value);
  }
}

final sharedPrefs = SharedPrefs();
// constants/strings.dart
const String userData = "user_data";

const String partnerData = "partner_data";

const String userToken = "user_token";

const String partnerToken = "partner_token";

saveUserModel(userModel) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String user = jsonEncode(userModel);
  pref.setString(userData, user);
}

savePartnerModel(partnerModel) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String user = jsonEncode(partnerModel);
  pref.setString(partnerData, user);
}

saveUserToken(token) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(userToken, token.toString());
}

savePartnerToken(token) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(partnerToken, token.toString());
}

savefcmToken(token, callback) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('fcm_token', token.toString());
  callback();
}

logoutUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(userData);
  pref.remove(userToken);
}
logoutVendor() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(partnerData);
  pref.remove(partnerToken);
}
