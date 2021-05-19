import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/foundation.dart' show kIsWeb;

String urlApi = "https://sandbox.app.drugsiteonline.com/";

class RestFun {
  Client client = Client();
  BuildContext context;

  Future<dynamic> restService(
      dynamic arrayData, String ruta, String token, String method) async {
    if (!kIsWeb) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //Connected
        }
      } on SocketException catch (_) {
        // Not connected
        if (!Get.isSnackbarOpen)
          Get.snackbar(
            'Ha ocurrido un error', // title
            'Parece que no tienes conexión a internet', // message
            colorText: Colors.white,
            backgroundColor: Colors.red[600],
            barBlur: 20,
            isDismissible: true,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 5),
            animationDuration: Duration(milliseconds: 300),
          );
      }
    }

    var response;
    String requestStatus = "local_false";
    String requestResponse = "Hubo un error local para procesar la petición";
    String messageToUser;

    switch (method) {
      case 'post':
        response = await client.post(Uri.parse('$ruta'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Cookie': 'token=$token',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(arrayData));
        break;
      case 'put':
        response = await client.put(Uri.parse('$ruta'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(arrayData));
        break;
      case 'delete':
        response = await client.delete(
          Uri.parse('$ruta'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        break;
      case 'get':
        response = await client.get(
          Uri.parse('$ruta'),
          headers: {
            'Content-Type': 'application/json',
            // 'Accept': '*/*',
            // 'Cookie': 'token=$token',
            'Authorization': 'Bearer $token',
          },
        );
        break;
      default:
        response = await client.get(
          Uri.parse('$urlApi$ruta'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        break;
    }
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse.length == 4) {
        if (jsonResponse['status'] == "true") {
          requestStatus = "server_true";
          requestResponse = jsonEncode(jsonResponse);
          messageToUser = jsonResponse['message'].toString();
          print("Todo bien:" + jsonResponse.toString());
        } else {
          requestStatus = "server_false";
          requestResponse = jsonEncode(jsonResponse);
          messageToUser = jsonResponse['message'].toString();
          print("Hay un problema: " + jsonResponse['message'].toString());
        }
      } else {
        if (jsonResponse[0]['status'] == "true") {
          requestStatus = "server_true";
          requestResponse = jsonEncode(jsonResponse);
          messageToUser = jsonResponse[0]['message'].toString();
          print("Todo bien:" + jsonResponse.toString());
        } else {
          requestStatus = "server_false";
          requestResponse = jsonEncode(jsonResponse);
          messageToUser = jsonResponse[0]['message'].toString();
          print("Hay un problema: " + jsonResponse[0]['message'].toString());
        }
      }
    } else {
      requestStatus = "server_false";
      requestResponse = jsonEncode(jsonResponse);
      print("Hubo un problema para realizar la petición");
      print(response.body);
    }

    return {
      "status": requestStatus,
      "response": requestResponse,
      "message": messageToUser.toString()
    };
  }
}
