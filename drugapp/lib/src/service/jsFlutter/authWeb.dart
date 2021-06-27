import 'auth_class.dart';
import 'dart:js' as js;
//other imports

class Auth0ManagerForWeb extends AuthManager {
  @override
  Future<String> funTest() async {
    var state = js.context.callMethod('myFunction');
    return state;
  }
}

AuthManager getManager() => Auth0ManagerForWeb();
