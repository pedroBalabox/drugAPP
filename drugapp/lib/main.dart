import 'dart:io';
import 'package:drugapp/Routes.dart';
import 'package:drugapp/src/pages/Lobby/lobbyClient.dart';
import 'package:drugapp/src/pages/client/categoriaProductos_page.dart';
import 'package:drugapp/src/pages/client/productGeneric_page.dart';
import 'package:drugapp/src/pages/vendedor/editarProducto_page.dart';
import 'package:drugapp/src/pages/vendedor/miVenta_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:drugapp/src/pages/client/detallesCompra_page.dart';
import 'package:drugapp/src/pages/client/productoDetalle_pade.dart';
import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  //runApp(MyApp());
  if (!kIsWeb) {
    runApp(MyApp());
    checkInternet();
  } else {
    runApp(MyApp());
  }
}

/* class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Drug App',
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => LobbyClient(ruta: '/home'));
      },
      /* home: LobbyVendor(
          ruta: '/',
        ), */
      // initialRoute: initR,
      routes: rutasDrug,
    );
  }
} */

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Flurorouter.setupRouter();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      title: 'Drug Site',
      initialRoute: '/',
      onGenerateRoute: Flurorouter.router.generator,
    );
  }
}

checkInternet() async {
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
