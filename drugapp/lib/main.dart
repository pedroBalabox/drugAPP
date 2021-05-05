// import 'dart:html';
import 'dart:convert';
import 'dart:io';
import 'package:drugapp/src/bloc/user_bloc.dart/bloc_user.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/event_user.dart';
import 'package:drugapp/src/pages/vendedor/editarProducto_page.dart';
import 'package:drugapp/src/pages/vendedor/miVenta_page.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:drugapp/src/pages/client/carrito_page.dart';
import 'package:drugapp/src/pages/client/categoriaProductos_page.dart';
import 'package:drugapp/src/pages/client/categorie_page.dart';
import 'package:drugapp/src/pages/client/detallesCompra_page.dart';
import 'package:drugapp/src/pages/client/home_page.dart';
import 'package:drugapp/src/pages/client/login_page.dart';
import 'package:drugapp/src/pages/client/miCuenta_page.dart';
import 'package:drugapp/src/pages/client/miTienda_page.dart';
import 'package:drugapp/src/pages/client/productGeneric_page.dart';
import 'package:drugapp/src/pages/client/productoDetalle_pade.dart';
import 'package:drugapp/src/pages/client/register_page.dart';
import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/pages/client/tiendas_page.dart';
import 'package:drugapp/src/pages/tycVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/cargarProductos_page.dart';
import 'package:drugapp/src/pages/vendedor/homeVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/loginVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/miTiendaVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/registerVendedor_page.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'model/user_model.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // var ruta;
  // await sharedPrefs.init();
  // var url = Uri.base.toString();
  // if (url.contains('farmacia')){
  //     if (sharedPrefs.clientToken != ''){
  //     ruta = 'farmacia/miCuenta';
  //   } else{
  //     ruta = 'farmacia/login';
  //   }
  // }else{
  //   if (sharedPrefs.clientToken != ''){
  //     ruta = '/home';
  //   } else{
  //     ruta = '/login';
  //   }
  // }
  // print('---' + sharedPrefs.clientToken.toString());
  // bool isLoggedIn = sharedPrefs.clientToken == '' ? false : true;

  // String initialRoute = isLoggedIn ? '/home' : '/login';

  setPathUrlStrategy();

  runApp(MyApp(
    initR: '',
  ));
  if (!kIsWeb) {
    checkInternet();
  }
}

class MyApp extends StatelessWidget {
  final String initR;
  MyApp({Key key, this.initR}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Drug App',
        theme: appTheme(),
        debugShowCheckedModeBanner: false,
        // initialRoute: '/farmacia/login',
        home: SplashScreen(),
        // initialRoute: initR,
        routes: {
          '/splash': (context) => SplashScreen(),
          // C l i e n t e
          '/login': (context) => LoginPage(),
          '/registro': (context) => RegisterPage(),
          '/home': (context) => HomeClient(),
          '/miCuenta': (context) => MiCuentaClient(),
          '/fav': (context) => ProductoViewPage(
                title: 'Mis favoritos',
              ),
          '/carrito': (context) => CarritoPage(),
          '/categorias': (context) => CategoriaPage(),
          '/tiendas': (context) => TiendasPage(),
          '/miTienda': (context) => MiTienda(),
          '/masVendidos': (context) => ProductoViewPage(
                title: 'Más vendidos',
              ),
          '/ofertas': (context) => ProductoViewPage(
                title: 'Ofertas del día',
              ),
          // V e n d e d o r  W E B
          '/farmacia/login': (context) => LoginVendedor(),
          '/farmacia/registro': (context) => RegisterVendedor(),
          '/farmacia/miCuenta': (context) => MiCuentaVendedor(),
          '/farmacia/miTienda': (context) => MiTiendaVendedor(),
          '/farmacia/terminos-y-condiciones': (context) => TermCondVendedor(),
          '/farmacia/cargar-productos': (context) => CargarProductos(),
        },
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

Future<List> checkUserAndNavigate(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var clientToken = prefs.getString("user_token");
  var partnerToken = prefs.getString("partner_token");

  return [clientToken, partnerToken];
}
//   if (user_id != null && user_id != "") {
//     setupFCM(user_id);
//   }
//   return prefs.getString("user_type");
// }

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserModel userModel = UserModel();
  UserBloc _userBloc = UserBloc();

  @override
  void initState() {
    super.initState();

    checkUserAndNavigate(context).then((res) {
      sharedPrefs.init();
      var url = Uri.base.toString();

      print('----' + url);
      if (url.contains('/farmacia')) {
        
        if (url.contains('/farmacia/terminos-y-condiciones')) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/farmacia/terminos-y-condiciones', (route) => false);
        } else if (res[1] != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/farmacia/miCuenta', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/farmacia/login', (route) => false);
        }
      } else {
        if (res[0] != null) {
          RestFun rest = RestFun();
          rest
              .restService('', '${urlApi}perfil/usuario', res[0], 'get')
              .then((value) {
            if (value['status'] == 'server_true') {
              var jsonUser = jsonDecode(value['response']);
              userModel = UserModel.fromJson(jsonUser[1]);
              saveUserModel(userModel).then((value) {
                _userBloc.sendEvent.add(AddUserItemEvent(userModel));
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              });
            }else{
                Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
            }
          });
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}
