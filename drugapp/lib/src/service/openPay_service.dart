import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:js' as js;

const _sandboxUrl = 'https://sandbox-api.openpay.mx';
const _prodUrl = 'https://api.openpay.mx';

/// Openpay instance
class Openpay {
  /// enable sandox or production mode
  /// False by default
  final bool isSandboxMode;

  /// Your merchant id
  final String merchantId;

  /// Your public API Key
  final String apiKey;

  Openpay(this.merchantId, this.apiKey, {this.isSandboxMode = false});

  String get _merchantBaseUrl => '$baseUrl/v1/$merchantId';

  String get baseUrl => isSandboxMode ? _sandboxUrl : _prodUrl;

  /// Create a token from card data
  Future<TokenInfo> createToken(CardInfo card) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$apiKey:'));
    Response response =
        await post(Uri.parse('$_merchantBaseUrl/tokens'), headers: {
      'Content-type': 'application/json',
      'Authorization': basicAuth,
      'Accept': 'application/json',
    }, body: """{
      "card_number": "${card.cardNumber}",
      "holder_name": "${card.holderName}",
      "expiration_year": "${card.expirationYear}",
      "expiration_month": "${card.expirationMonth}",
      "cvv2": "${card.cvv2}"
    }""");

    if (response.statusCode == 201) {
      return TokenInfo._fromBackend(jsonDecode(response.body));
    } else {
      throw Exception('Error ${response.statusCode}, ${response.body}');
    }
  }

  Future<dynamic> createDevideId() async {
    js.context
        .callMethod('alertMessage', ['Flutter is calling upon JavaScript!']);
  }
}

/// Card data representation class
class CardInfo {
  final String cardNumber;
  final String holderName;
  final String expirationYear;
  final String expirationMonth;
  final String cvv2;
  final String brand;
  final String creationDate;

  CardInfo(this.cardNumber, this.holderName, this.expirationYear,
      this.expirationMonth, String cvv2)
      : brand = null,
        creationDate = null,
        this.cvv2 = cvv2;

  CardInfo._({
    this.cardNumber,
    this.holderName,
    this.expirationYear,
    this.expirationMonth,
    this.cvv2,
    this.brand,
    this.creationDate,
  });

  factory CardInfo._fromBackend(Map data) {
    return CardInfo._(
      cardNumber: data['card_number'],
      holderName: data['holder_name'],
      expirationYear: data['expiration_year'],
      expirationMonth: data['expiration_month'],
      cvv2: data['cvv2'], //never returned by backend :)
      brand: data['brand'],
      creationDate: data['creationDate'],
    );
  }

  @override
  String toString() {
    return 'CardInfo{cardNumber: ${cardNumber.contains('XX') ? cardNumber : 'hidden'}, holderName: $holderName, expirationYear: $expirationYear, expirationMonth: $expirationMonth, cvv2: ${cvv2 == null ? null : '***'}, brand: $brand, creationDate: $creationDate}';
  }
}

class required {}

/// Token data representation class
/// You need to use id as token
class TokenInfo {
  final String id;
  final CardInfo card;

  TokenInfo._(this.id, this.card);

  factory TokenInfo._fromBackend(Map data) {
    return TokenInfo._(data['id'], CardInfo._fromBackend(data['card']));
  }

  @override
  String toString() {
    return 'TokenInfo{id: $id, card: $card}';
  }
}

// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// // The entry point of the FlutterOpenpayService SDK
// class FlutterOpenpayService {
//   static const MethodChannel _channel = const MethodChannel('flutter_openpay');

//   /// Creates a token for a card which is ready
//   /// to process using Openpay API.
//   ///
//   /// Errors:
//   ///   • `ERROR_INTERNAL_SERVER_ERROR` - An error happened in the internal Openpay server.
//   ///   • `ERROR_BAD_REQUEST` - The request is not JSON valid format, the fields don’t have the correct format, or the request doesn’t have the required fields.
//   ///   • `ERROR_UNAUTHORIZED` - The request is not authenticated or is incorrect.
//   ///   • `ERROR_UNPROCESSABLE_ENTITY` - The operation couldn’t be processed because one or more parameters are incorrect.
//   ///   • `ERROR_SERVICE_UNAVAILABLE` - A required service is not available.
//   ///   • `ERROR_NOT_FOUND` - A required resource doesn’t exist.
//   ///   • `ERROR_REQUEST_ENTITY_TOO_LARGE` - The request body is too large.
//   ///   • `ERROR_PUBLIC_KEY_NOT_ALLOWED` - The public key is being used to make a request that requires the private key.
//   ///   • `ERROR_INVALID_CARD_NUMBER` - The identifier digit of this card number is invalid according to Luhn algorithm.
//   ///   • `ERROR_INVALID_EXP_DATE` - The card expiration date is prior to the current date.
//   ///   • `ERROR_CVV2_MISSING` - The card security code (CVV2) wasn’t provided.
//   ///   • `ERROR_CARD_NUMBER_ONLY_SANDBOX` - The card number is just for testing, it can only be used in Sandbox.
//   ///   • `ERROR_INVALID_CVV2` - The card security code (CVV2) is invalid.
//   ///   • `ERROR_CARD_PRODUCT_TYPE_NOT_SUPPORTED` - 	Card product type not supported.
//   ///   • `ERROR_CARD_DECLINED` - Card declined.
//   ///   • `ERROR_CARD_EXPIRED` - Card is expired.
//   ///   • `ERROR_CARD_INSUFFICIENT_FUNDS` - Card has not enough funds.
//   ///   • `ERROR_CARD_STOLEN` - Card has been flagged as stolen.
//   ///   • `ERROR_CARD_FRAUDULENT` - 	Card has been rejected by the antifraud system.
//   ///   • `ERROR_CARD_NOT_SUPPORTED_IN_ONLINE_TRANSACTIONS` - The card doesn’t support online transactions.
//   ///   • `ERROR_CARD_REPORTED_AS_LOST` - Card has been flagged as lost.
//   ///   • `ERROR_CARD_RESTRICTED_BY_BANK` - The card has been restricted by the bank.
//   ///   • `ERROR_CARD_RETAINED_BY_BANK` - The bank has requested to hold this card. Please contact the bank.
//   ///   • `ERROR_SERVICE_UNAVAILABLE` - The service is unavailable. Might be due to no internet connection.
//   static Future<String> tokenizeCard({
//     @required String merchantId,
//     @required String publicApiKey,
//     @required bool productionMode,
//     @required String cardholderName,
//     @required String cardNumber,
//     @required String cvv,
//     @required String expiryMonth,
//     @required String expiryYear,
//   }) {
//     return _channel.invokeMethod('tokenizeCard', <String, dynamic>{
//       'merchantId': merchantId,
//       'publicApiKey': publicApiKey,
//       'productionMode': productionMode,
//       'cardholderName': cardholderName,
//       'cardNumber': cardNumber,
//       'cvv': cvv,
//       'expiryMonth': expiryMonth,
//       'expiryYear': expiryYear,
//     });
//   }

//   /// Generates a device session id
//   /// to use in Openpay API calls.
//   ///
//   /// Errors:
//   ///   • `ERROR_UNABLE_TO_GET_SESSION_ID` - An error happened while generating the device session id.
//   static Future<String> getDeviceSessionId({
//     @required String merchantId,
//     @required String publicApiKey,
//     @required bool productionMode,
//   }) {
//     return _channel.invokeMethod('getDeviceSessionId', <String, dynamic>{
//       'merchantId': merchantId,
//       'publicApiKey': publicApiKey,
//       'productionMode': productionMode,
//     });
//   }
// }
