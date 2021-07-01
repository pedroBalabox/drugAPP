

import 'auth0_manager_stub.dart'
    if (dart.library.io) 'auth0manager.dart'
    if (dart.library.js) 'authWeb.dart';

abstract class AuthManager {
  static AuthManager _instance;

  static AuthManager get instance {
    _instance ??= getManager();
    return _instance;
  }

  Future<String> funTest();

  Future<String> homeFunction();
}