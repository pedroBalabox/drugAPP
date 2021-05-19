import 'package:drugapp/src/pages/Lobby/validate_page.dart';
import 'package:drugapp/src/pages/vendedor/cargarProductos_page.dart';
import 'package:drugapp/src/pages/vendedor/homeVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/loginVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/miTiendaVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/registerVendedor_page.dart';
import 'package:flutter/material.dart';

class LobbyVendor extends StatefulWidget {
  final String ruta;
  LobbyVendor({Key key, @required this.ruta}) : super(key: key);

  @override
  _LobbyVendorState createState() => _LobbyVendorState();
}

class _LobbyVendorState extends State<LobbyVendor> {
  @override
  void initState() {
    super.initState();
    print('----' + widget.ruta);
    validateVendorToken(context).then((value) {
      if (value == 'null') {
        redirigirRuta(false);
      } else {
        validateVendor(context, value).then((value) {
          redirigirRuta(value);
        });
      }
    });
  }

  redirigirRuta(bool clientAuth) {
    switch (widget.ruta) {
       case '/farmacia/login/miTienda':
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => LoginVendedor(
                      miTienda: true,
                    )),
            (Route<dynamic> route) => false);
        break;
      case '/farmacia/login':
        clientAuth
            ? Navigator.pushNamedAndRemoveUntil(
                context, '/farmacia/miCuenta', (route) => false)
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginVendedor()),
                (Route<dynamic> route) => false);
        break;
      case '/farmacia/registro':
        clientAuth
            ? Navigator.pushNamedAndRemoveUntil(
                context, '/farmacia/miCuenta', (route) => false)
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => RegisterVendedor()),
                (Route<dynamic> route) => false);
        break;
      case '/farmacia/miCuenta':
        print('ok' + clientAuth.toString());
        clientAuth
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MiCuentaVendedor()),
                (Route<dynamic> route) => false)
            : Navigator.pushNamedAndRemoveUntil(
                context, '/farmacia/login', (route) => false);
        break;
      case '/farmacia/miTienda':
        clientAuth
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MiTiendaVendedor()),
                (Route<dynamic> route) => false)
            : Navigator.pushNamedAndRemoveUntil(
                context, '/farmacia/login', (route) => false);
        break;
      case '/farmacia/cargar-productos':
        clientAuth
            ? Navigator.of(context)
                .push(
                    MaterialPageRoute(builder: (context) => CargarProductos()))
                .then((value) => Navigator.pop(context))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/farmacia/login', (route) => false);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
