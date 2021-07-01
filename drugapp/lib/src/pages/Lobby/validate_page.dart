import 'dart:convert';

import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/model/vendor_model.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/bloc_user.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/event_user.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> validateClient(context, token) async {
  UserModel userModel = UserModel();
  UserBloc _userBloc = UserBloc();
  RestFun rest = RestFun();

  rest.restService('', '${urlApi}perfil/usuario', token, 'get').then((value) {
    if (value['status'] == 'server_true') {
      var jsonUser = jsonDecode(value['response']);
      userModel = UserModel.fromJson(jsonUser[1]);
      saveUserModel(userModel).then((value) {
        _userBloc.sendEvent.add(AddUserItemEvent(userModel));
      });
    }
  });
  return userModel.user_id == null ? false : true;
}

Future<bool> validateClientToken() async {
  RestFun rest = RestFun();
  UserModel userModel = UserModel();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var clientToken = prefs.getString("user_token");
  bool tokenValid;

  if (clientToken == null) {
    tokenValid = false;
    return tokenValid;
    // return clientToken.toString();
  } else {
  await  rest
        .restService('', '${urlApi}perfil/usuario', clientToken, 'get')
        .then((value) {
      print(value);
      if (value['status'] == 'server_true') {
        var jsonUser = jsonDecode(value['response']);
        userModel = UserModel.fromJson(jsonUser[1]);
        saveUserModel(userModel);
        tokenValid = true;
        // return clientToken.toString();
      } else {
        tokenValid = false;
      }
      // return null.toString();
    });
    return userModel.user_id == null ? false : true;
  }
  // return tokenValid;
}

Future<bool> validateVendorToken() async {
  RestFun rest = RestFun();
  UserModel userModel = UserModel();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var clientToken = prefs.getString("partner_token");
  bool tokenValid;

  if (clientToken == null) {
    tokenValid = false;
    return tokenValid;
    // return clientToken.toString();
  } else {
  await  rest
        .restService('', '${urlApi}perfil/usuario', clientToken, 'get')
        .then((value) {
      print(value);
      if (value['status'] == 'server_true') {
        var jsonUser = jsonDecode(value['response']);
        userModel = UserModel.fromJson(jsonUser[1]);
        saveUserModel(userModel);
        tokenValid = true;
        // return clientToken.toString();
      } else {
        tokenValid = false;
      }
      // return null.toString();
    });
    return userModel.user_id == null ? false : true;
  }
  // return tokenValid;
}

Future<bool> validateVendor(token) async {
  VendorModel vendorModel = VendorModel();
  RestFun rest = RestFun();

  rest.restService('', '${urlApi}perfil/usuario', token, 'get').then((value) {
    if (value['status'] == 'server_true') {
      var jsonUser = jsonDecode(value['response']);
      vendorModel = VendorModel.fromJson(jsonUser[1]);
      savePartnerModel(vendorModel);
    }
  });
  return vendorModel == null ? false : true;
}

// Future<String> validateVendorToken(context) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();

  // var vendorToken = prefs.getString("partner_token");

  // if (vendorToken != null) {
  //   return vendorToken.toString();
  // } else {
  //   return vendorToken.toString();
  // }
// }
