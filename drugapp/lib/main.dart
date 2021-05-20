import 'dart:io';
import 'package:drugapp/src/pages/Lobby/lobbyClient.dart';
import 'package:drugapp/src/pages/Lobby/lobbyVendor.dart';
import 'package:drugapp/src/pages/client/categoriaProductos_page.dart';
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

  runApp(MyApp());
  if (!kIsWeb) {
    checkInternet();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Drug App',
        theme: appTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/farmacia/miTienda',
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (_) => LobbyClient(ruta: '/home'));
        },
        /* home: LobbyVendor(
          ruta: '/',
        ), */
        // initialRoute: initR,
        routes: rutasDrug,
        onGenerateRoute: (RouteSettings settings) {
          // print('++' + settings.name);
          // if (settings.name == '/farmacia'){
          //   print('ok');
          //   return MaterialPageRoute(
          //     builder: (context) => LoginPage(),
          //   );
          // }
          // If you push the PassArguments route
          if (settings.name == DetallesCompra.routeName) {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final CompraDetailArguments args =
                settings.arguments as CompraDetailArguments;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return DetallesCompra(
                  jsonCompra: args,
                );
              },
            );
          }
          if (settings.name == ProductoDetalles.routeName) {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final ProductoDetallesArguments args =
                settings.arguments as ProductoDetallesArguments;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return ProductoDetalles(
                  jsonProdcuto: args,
                );
              },
            );
          }
          if (settings.name == TiendaProductos.routeName) {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final TiendaDetallesArguments args =
                settings.arguments as TiendaDetallesArguments;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return TiendaProductos(
                  jsonTienda: args,
                );
              },
            );
          }
          if (settings.name == CategoriaProductos.routeName) {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final CategoriaDetallesArguments args =
                settings.arguments as CategoriaDetallesArguments;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return CategoriaProductos(
                  jsonCategoria: args,
                );
              },
            );
          }
          if (settings.name == MiVenta.routeName) {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final VentaDetallesArguments args =
                settings.arguments as VentaDetallesArguments;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return MiVenta(
                  miVenta: args,
                );
              },
            );
          }
          if (settings.name == EditarProducto.routeName) {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final EdiaterProductoDetallesArguments args =
                settings.arguments as EdiaterProductoDetallesArguments;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return EditarProducto(
                  jsonProducto: args,
                );
              },
            );
          }
        });
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
