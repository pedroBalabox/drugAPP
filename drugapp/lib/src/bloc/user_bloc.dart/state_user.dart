import 'dart:convert';

import 'package:drugapp/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState {
  UserModel _user;

  UserState._();
  static UserState _instance = UserState._();
  factory UserState() => _instance;

  UserModel get catalog => _user;

  void addToUser(UserModel itemModel) {
    _user = (itemModel);
    addUserPreferences(jsonEncode(itemModel));
  }

  void removeFromUser(UserModel itemModel) {
    _user = null;
  }

  void editToUser(UserModel itemModel) {
    _user = itemModel;
  }
}

Future<bool> addUserPreferences(userMod) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.setString("user_data", userMod);
}