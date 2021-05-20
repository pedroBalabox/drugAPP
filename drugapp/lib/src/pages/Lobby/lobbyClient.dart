import 'package:drugapp/src/pages/Lobby/validate_page.dart';
import 'package:drugapp/src/pages/client/carrito_page.dart';
import 'package:drugapp/src/pages/client/categorie_page.dart';
import 'package:drugapp/src/pages/client/fav_page.dart';
import 'package:drugapp/src/pages/client/home_page.dart';
import 'package:drugapp/src/pages/client/login_page.dart';
import 'package:drugapp/src/pages/client/miCuenta_page.dart';
import 'package:drugapp/src/pages/client/miTienda_page.dart';
import 'package:drugapp/src/pages/client/productGeneric_page.dart';
import 'package:drugapp/src/pages/client/register_page.dart';
import 'package:drugapp/src/pages/client/tiendas_page.dart';
import 'package:drugapp/src/pages/vendedor/loginVendedor_page.dart';
import 'package:flutter/material.dart';
import 'package:drugapp/src/pages/vendedor/cargarProductos_page.dart';
import 'package:drugapp/src/pages/vendedor/homeVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/miTiendaVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/registerVendedor_page.dart';


class LobbyClient extends StatefulWidget {
  final String ruta;
  LobbyClient({Key key, @required this.ruta}) : super(key: key);

  @override
  _LobbyClientState createState() => _LobbyClientState();
}

class _LobbyClientState extends State<LobbyClient> {
  @override
  void initState() {
    super.initState();
    if (widget.ruta.contains('farmacia')) {
      validateVendorToken(context).then((value) {
        if (value == 'null') {
          redirigirRuta(false);
        } else {
          validateVendor(context, value).then((value) {
            redirigirRuta(value);
          });
        }
      });
    } else {
      validateClientToken(context).then((value) {
        if (value == 'null') {
          redirigirRuta(false);
        } else {
          validateClient(context, value).then((value) {
            redirigirRuta(value);
          });
        }
      });
    }
  }

  redirigirRuta(bool clientAuth) {
    switch (widget.ruta) {
      case '/':
        clientAuth
            ? Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false)
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/login':
        clientAuth
            ? Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false)
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false);
        break;
      case '/registro':
        clientAuth
            ? Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false)
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => RegisterPage()),
                (Route<dynamic> route) => false);
        break;
      case '/home':
        clientAuth
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeClient()),
                (Route<dynamic> route) => false)
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/miCuenta':
        clientAuth
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MiCuentaClient()),
                (Route<dynamic> route) => false)
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/fav':
        clientAuth
            ? Navigator.of(context)
                .pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => FavClient()),
                    (Route<dynamic> route) => false)
                .then((value) => setState(() {}))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/carrito':
        clientAuth
            ? Navigator.of(context)
                .push(
                  MaterialPageRoute(builder: (context) => CarritoPage()),
                )
                .then((value) => setState(() {
                      Navigator.pop(context);
                    }))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/categorias':
        clientAuth
            ? Navigator.of(context)
                .push(
                  MaterialPageRoute(builder: (context) => CategoriaPage()),
                )
                .then((value) => setState(() {
                      Navigator.pop(context);
                    }))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/tiendas':
        clientAuth
            ? Navigator.of(context)
                .push(
                  MaterialPageRoute(builder: (context) => TiendasPage()),
                )
                .then((value) => setState(() {
                      Navigator.pop(context);
                    }))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/miTienda':
        clientAuth
            ? Navigator.of(context)
                .push(
                  MaterialPageRoute(builder: (context) => MiTienda()),
                )
                .then((value) => setState(() {
                      Navigator.pop(context);
                    }))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/categorias':
        clientAuth
            ? Navigator.of(context)
                .push(
                  MaterialPageRoute(builder: (context) => CategoriaPage()),
                )
                .then((value) => setState(() {
                      Navigator.pop(context);
                    }))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/masVendidos':
        clientAuth
            ? Navigator.of(context)
                .push(
                  MaterialPageRoute(
                      builder: (context) => ProductoViewPage(
                            title: 'Más Vendidos',
                          )),
                )
                .then((value) => setState(() {
                      Navigator.pop(context);
                    }))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
      case '/ofertas':
        clientAuth
            ? Navigator.of(context)
                .push(
                  MaterialPageRoute(
                      builder: (context) => ProductoViewPage(
                            title: 'Ofertas',
                          )),
                )
                .then((value) => setState(() {
                      Navigator.pop(context);
                    }))
            : Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
        break;
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
