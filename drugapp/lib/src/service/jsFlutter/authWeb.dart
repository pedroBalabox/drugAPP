import 'package:drugapp/src/pages/Lobby/validate_page.dart';

import 'auth_class.dart';
import 'dart:js' as js;
import 'dart:html';

//other imports

class Auth0ManagerForWeb extends AuthManager {
  @override
  Future<String> funTest() async {
    var state = js.context.callMethod('myFunction');
    return state;
  }

  Future<String> homeFunction() async {
    var url = window.location.href;

    String returnSmt;

    if (url.contains('farmacia')) {
      await validateVendorToken().then((value) {
        if (!value) {
          returnSmt = '/farmacia/login/';
        } else {
          if (url.contains('/login') || url.contains('/registro')) {
            returnSmt = '/farmacia/miCuenta/';
          } else {
            returnSmt = window.location.pathname.toString();
          }
        }
      });
      return returnSmt;
    } else if (url.contains('terminos-y-condiciones') ||
        url.contains('aviso-de-privacidad')) {
      returnSmt = window.location.pathname.toString();
    } else {
      await validateClientToken().then((value) {
        if (!value) {
          if (window.location.pathname.toString().contains('Recuperar')) {
            returnSmt = window.location.pathname.toString();
          } else {
            returnSmt = '/login';
          }
        } else {
          returnSmt = 'load';
        }
      });
    }
    return returnSmt;
  }
}

// validateToken() async {
//   await validateClientToken().then((value) {
//     if (!value) {
//       if (window.location.pathname.toString().contains('Recuperar')) {
//         return  window.location.pathname.toString();
//       } else {
//        return '/login';
//       }
//     } else {
//       setState(() {
//         load = false;
//       });
//     }
//   });
// }

// validateFarmaciaToken() async {
//   var url = window.location.href;

// }

AuthManager getManager() => Auth0ManagerForWeb();
