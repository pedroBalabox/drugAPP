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
}

AuthManager getManager() => Auth0Manager();
