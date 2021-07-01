import 'package:drugapp/src/pages/Lobby/validate_page.dart';
import 'package:flutter_openpay/flutter_openpay.dart';

import 'auth_class.dart';

//other imports
class Auth0Manager extends AuthManager {
  @override
  @override
  Future<String> funTest() async {
    String deviceSessionId;
    try {
      deviceSessionId = await FlutterOpenpay.getDeviceSessionId(
        merchantId: 'mroipipydkwe3txxqfht',
        publicApiKey: 'pk_0450626f5da34f87b4a0279a4c34fa1c',
        productionMode: false,
      );
    } catch (e) {
      print(e.toString());
      deviceSessionId = "error";
    }
    return deviceSessionId;
  }

  Future<String> homeFunction() async {
    String returnSmt;

    await validateClientToken().then((value) async {
      if (!value) {
        await validateVendorToken().then((value) {
          if (!value) {
            returnSmt = '/login';
          } else {
            returnSmt = '/farmacia/miCuenta/';
          }
        });
      } else {
        returnSmt = 'load';
      }
    });
    return returnSmt;
  }
}

AuthManager getManager() => Auth0Manager();
