import 'package:drugapp/src/pages/Lobby/lobbyClient.dart';
import 'package:drugapp/src/pages/Lobby/lobbyVendor.dart';
import 'package:drugapp/src/pages/changePass_page.dart';
import 'package:drugapp/src/pages/client/carrito_page.dart';
import 'package:drugapp/src/pages/client/categorie_page.dart';
import 'package:drugapp/src/pages/client/chargeResult.dart';
import 'package:drugapp/src/pages/client/detallesCompra_page.dart';
import 'package:drugapp/src/pages/client/home_page.dart';
import 'package:drugapp/src/pages/client/login_page.dart';
import 'package:drugapp/src/pages/client/miCuenta_page.dart';
import 'package:drugapp/src/pages/client/preguntasFrecuentes.dart';
import 'package:drugapp/src/pages/client/productGeneric_page.dart';
import 'package:drugapp/src/pages/client/productoDetalle_pade.dart';
import 'package:drugapp/src/pages/client/register_page.dart';
import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/pages/client/tiendas_page.dart';
import 'package:drugapp/src/pages/newPass_page.dart';
import 'package:drugapp/src/pages/recoverPass_page.dart';
import 'package:drugapp/src/pages/tycVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/cargarProductos_page.dart';
import 'package:drugapp/src/pages/vendedor/editarProducto_page.dart';
import 'package:drugapp/src/pages/vendedor/homeVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/loginVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/miTiendaVendedor_page.dart';
import 'package:drugapp/src/pages/vendedor/miTiendaVendor_page.dart';
import 'package:drugapp/src/pages/vendedor/registerVendedor_page.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static Handler _loginHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginPage());

  static Handler _registroHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RegisterPage());

  static Handler _homeHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomeClient());

  static Handler _miCuentaHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          MiCuentaClient());

  static Handler _miCuentaComprasHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          MiCuentaClient(
            index: 3,
          ));

  static Handler _faqHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          PreguntasFrec());

  static Handler _favHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(
            jsonData: ProductosDetallesArguments({
              "farmacia_id": null,
              "userQuery": null,
              "favoritos": true,
              "availability": null,
              "stock": "available",
              "priceFilter": null,
              "myLabels": [],
              "myCats": [],
              "title": "Productos favoritos"
            }),
          ));

  static Handler _allProductsHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(
            jsonData: ProductosDetallesArguments({
              "farmacia_id": null,
              "userQuery": null,
              "favoritos": null,
              "availability": null,
              "stock": "available",
              "priceFilter": null,
              "myLabels": [],
              "myCats": [],
              "title": "Productos"
            }),
          ));

  static Handler _comprasHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          DetallesCompra(idCompra: params["compra"][0]));

  static Handler _carritoHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          CarritoPage());

  static Handler _categoriasHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          CategoriaPage());

  static Handler _tiendasHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          TiendasPage());

  static Handler _miTiendaHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(
            myStore: true,
            jsonData: ProductosDetallesArguments({
              "farmacia_id": null,
              "userQuery": null,
              "favoritos": null,
              "availability": null,
              "stock": "available",
              "priceFilter": null,
              "myLabels": [],
              "myCats": [],
              "title": "Mi Farmacia"
            }),
          ));

  static Handler _miCategoriaHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(
            jsonData: ProductosDetallesArguments({
              "farmacia_id": null,
              "userQuery": null,
              "favoritos": null,
              "availability": null,
              "stock": "available",
              "priceFilter": null,
              "myLabels": [],
              "myCats": [params["cat"][0]],
              "title": params["nombre"][0]
            }),
          ));

  static Handler _productosTiendaHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(
            jsonData: ProductosDetallesArguments({
              "farmacia_id": params["tienda"][0],
              "userQuery": null,
              "favoritos": null,
              "availability": null,
              "stock": "available",
              "priceFilter": null,
              "myLabels": [],
              "myCats": [],
              "title": null
            }),
          ));

  static Handler _productosSearchHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView(
            jsonData: ProductosDetallesArguments({
              "farmacia_id": null,
              "userQuery": params['search'][0],
              "favoritos": null,
              "availability": null,
              "stock": "available",
              "priceFilter": null,
              "myLabels": [],
              "myCats": [],
              "title": null
            }),
          ));

  static Handler _productosHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductView());

  static Handler _chandePasswordHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ChangePass(
            cliente: false,
          ));

  static Handler _chandePasswordClientHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ChangePass(
            cliente: true,
          ));

  static Handler _detallesProductoHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductoDetalles(
            productID: params["producto"][0],
          ));

  static Handler _masVendidosHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductoViewPage());

  static Handler _ofertasHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductoViewPage());

  static Handler _farmacialoginHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginVendedor());

  static Handler _farmacia_loginHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginVendedor());

  static Handler _farmacia_loginHandler_asClient = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginVendedor(
            miTienda: true,
          ));

  static Handler _farmacia_login_miTiendaHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          MiTiendaVendedor());

  static Handler _farmacia_registroHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RegisterVendedor());

  static Handler _farmacia_miCuentaHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          MiCuentaVendedor());

  static Handler _farmacia_miTiendaHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          MiTiendaVendedor());

  static Handler _farmacia_cargar_productosHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          CargarProductos());

  static Handler _farmacia_editar_productosHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          EditarProducto(
            idProducto: params['producto'][0],
          ));

  static Handler _farmacia_terminos_y_condicionesHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          TermCondVendedor());

  static Handler _farmaciaLogin = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginVendedor());

  static Handler _clientLogin = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginPage());

  static Handler _farmaciaMobile_miTienda = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          MiTiendaPage(jsonData: {
            "farmacia_id": null,
            "userQuery": null,
            "favoritos": null,
            "availability": null,
            "stock": "available",
            "priceFilter": null,
            "myLabels": [],
            "myCats": [],
            "title": "Mi Farmacia"
          }));
  static Handler _resPasswordVendorHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RecoverPass(
            tipoUser: 'vendor',
          ));
  static Handler _resPasswordClientHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RecoverPass(
            tipoUser: 'client',
          ));
  static Handler _recoverPassHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          NewPass(
            correo: params['correo'][0],
            token: params['token'][0],
          ));

  static Handler _chargeResultHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ChargeResult(
            chargeId: params['chargeId'][0],
          ));

  static void setupRouter() {
    router.define('/',
        handler: _homeHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/login',
        handler: _loginHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/registro',
        handler: _registroHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/miCuenta',
        handler: _miCuentaHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/miCuenta/misCompras/',
        handler: _miCuentaComprasHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/favoritos',
        handler: _favHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/productos',
        handler: _allProductsHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/carrito',
        handler: _carritoHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/categorias',
        handler: _categoriasHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/tiendas',
        handler: _tiendasHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/miTienda',
        handler: _miTiendaHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/productos/:cat/:nombre',
        handler: _miCategoriaHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/productos-tienda/:tienda/',
        handler: _productosTiendaHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/productos-query/:search/',
        handler: _productosSearchHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/productos',
        handler: _productosHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/farmacia/cambiar-contraseña/',
        handler: _chandePasswordHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/cambiar-contraseña',
        handler: _chandePasswordClientHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    // router.define('/producto/:producto',
    //     handler: _detallesProductoHandler,
    //     transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
    //     transitionDuration: Duration(milliseconds: 300));
    router.define('/detalles/producto/:producto',
        handler: _detallesProductoHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/miCuenta/compra/:compra',
        handler: _comprasHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/cargo/:chargeId',
        handler: _chargeResultHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/masVendidos',
        handler: _masVendidosHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/ofertas',
        handler: _ofertasHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/preguntas-frecuentes',
        handler: _faqHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/login/',
        handler: _farmacialoginHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/cliente/farmacia/login',
        handler: _farmacia_loginHandler_asClient,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/miTienda/',
        handler: _farmacia_login_miTiendaHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/registro/',
        handler: _farmacia_registroHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/miCuenta/',
        handler: _farmacia_miCuentaHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/miTienda/',
        handler: _farmacia_miTiendaHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/cargar-productos/',
        handler: _farmacia_cargar_productosHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/editar-producto/:producto',
        handler: _farmacia_editar_productosHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/miTienda/mobile',
        handler: _farmaciaMobile_miTienda,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/vendor/restablecer-contrasena/',
        handler: _resPasswordVendorHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/client/restablecer-contrasena/',
        handler: _resPasswordClientHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/RecuperarClave/:correo/:token',
        handler: _recoverPassHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/terminos-y-condiciones/vendor/',
        handler: _farmacia_terminos_y_condicionesHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/terminos-y-condiciones/client/',
        handler: _farmacia_terminos_y_condicionesHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/aviso-de-privacidad/vendor/',
        handler: _farmacia_terminos_y_condicionesHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/aviso-de-privacidad/client/',
        handler: _farmacia_terminos_y_condicionesHandler,
        transitionType: kIsWeb ? TransitionType.fadeIn : TransitionType.native,
        transitionDuration: Duration(milliseconds: 300));
  }
}
