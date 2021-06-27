import 'package:drugapp/src/pages/Lobby/lobbyClient.dart';
import 'package:drugapp/src/pages/Lobby/lobbyVendor.dart';
import 'package:drugapp/src/pages/changePass_page.dart';
import 'package:drugapp/src/pages/client/carrito_page.dart';
import 'package:drugapp/src/pages/client/categorie_page.dart';
import 'package:drugapp/src/pages/client/detallesCompra_page.dart';
import 'package:drugapp/src/pages/client/home_page.dart';
import 'package:drugapp/src/pages/client/login_page.dart';
import 'package:drugapp/src/pages/client/miCuenta_page.dart';
import 'package:drugapp/src/pages/client/productGeneric_page.dart';
import 'package:drugapp/src/pages/client/productoDetalle_pade.dart';
import 'package:drugapp/src/pages/client/register_page.dart';
import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/pages/client/tiendas_page.dart';
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

  static void setupRouter() {
    router.define('/',
        handler: _homeHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/login',
        handler: _loginHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/registro',
        handler: _registroHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/miCuenta',
        handler: _miCuentaHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/favoritos',
        handler: _favHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/productos',
        handler: _allProductsHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/carrito',
        handler: _carritoHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/categorias',
        handler: _categoriasHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/tiendas',
        handler: _tiendasHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/miTienda',
        handler: _miTiendaHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/productos/:cat/:nombre',
        handler: _miCategoriaHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/:tienda/productos',
        handler: _productosTiendaHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/productos',
        handler: _productosHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/farmacia/cambiar-contraseña/',
        handler: _chandePasswordHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/cambiar-contraseña',
        handler: _chandePasswordClientHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));

    // router.define('/producto/:producto',
    //     handler: _detallesProductoHandler,
    //     transitionType: TransitionType.fadeIn,
    //     transitionDuration: Duration(milliseconds: 300));
    router.define('/detalles/producto/:producto',
        handler: _detallesProductoHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/miCuenta/compra/:compra',
        handler: _comprasHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));

    router.define('/masVendidos',
        handler: _masVendidosHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/ofertas',
        handler: _ofertasHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/login/',
        handler: _farmacialoginHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/cliente/farmacia/login',
        handler: _farmacia_loginHandler_asClient,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/miTienda/',
        handler: _farmacia_login_miTiendaHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/registro/',
        handler: _farmacia_registroHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/miCuenta/',
        handler: _farmacia_miCuentaHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/miTienda/',
        handler: _farmacia_miTiendaHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/cargar-productos/',
        handler: _farmacia_cargar_productosHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/editar-producto/:producto',
        handler: _farmacia_editar_productosHandler,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
    router.define('/farmacia/miTienda/mobile',
        handler: _farmaciaMobile_miTienda,
        transitionType: TransitionType.fadeIn,
        transitionDuration: Duration(milliseconds: 300));
  }
}
