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
    /* print("La ruta es: "+widget.ruta); */
    validateVendorToken().then((value) {
      if (value == 'null') {
        /* print("Entró como null"); */
        redirigirRuta(false);
      } else {
        validateVendor(value).then((value) {
          /* print("Entró bien: " + value.toString());
          print(widget.ruta); */
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
        print("Farmacia Login");
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
            /* Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MiCuentaVendedor()),
              ) */
            : Navigator.pushNamedAndRemoveUntil(
                context, '/farmacia/login', (route) => false);
        break;
      case '/farmacia/miTienda/':
        if (clientAuth) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MiTiendaVendedor()),
              (Route<dynamic> route) => false);
          /* Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MiTiendaVendedor()),
          ); */
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/farmacia/login', (route) => false);
        }
        break;
      case '/farmacia/cargar-productos/':
        clientAuth
            ? Navigator.of(context)
                .push(
                    MaterialPageRoute(builder: (context) => CargarProductos()))
                .then((value) => Navigator.pop(context))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/farmacia/login', (route) => false);
        break;
      default:
        print("Shit happens");

        if (clientAuth) {
          Navigator.of(context).pushNamed('/farmacia/miTienda/');
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/farmacia/login', (route) => false);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
