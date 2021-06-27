import 'package:drugapp/src/pages/Lobby/lobbyClient.dart';
import 'package:drugapp/src/pages/Lobby/lobbyVendor.dart';
// import 'package:drugapp/src/pages/Lobby/LobbyClient.dart';
import 'package:drugapp/src/pages/tycVendedor_page.dart';

class CompraDetailArguments {
  final dynamic jsonCompra;

  CompraDetailArguments(this.jsonCompra);
}

class ProductoDetallesArguments {
  final dynamic jsonProducto;

  ProductoDetallesArguments(this.jsonProducto);
}

class ProductosDetallesArguments {
  final dynamic jsonData;

  ProductosDetallesArguments(this.jsonData);
}

class CategoriaDetallesArguments {
  final dynamic jsonCategoria;

  CategoriaDetallesArguments(this.jsonCategoria);
}

class VentaDetallesArguments {
  final dynamic jsonVenta;

  VentaDetallesArguments(this.jsonVenta);
}

class EdiaterProductoDetallesArguments {
  final dynamic jsonProducto;

  EdiaterProductoDetallesArguments(this.jsonProducto);
}

var rutasDrug = {
  // C l i e n t e'
  '/login': (context) => LobbyClient(ruta: '/login'),
  '/registro': (context) => LobbyClient(ruta: '/registro'),
  '/home': (context) => LobbyClient(ruta: '/home'),
  '/miCuenta': (context) => LobbyClient(ruta: '/miCuenta'),
  '/fav': (context) => LobbyClient(ruta: '/productos'),
  '/carrito': (context) => LobbyClient(ruta: '/carrito'),
  '/categorias': (context) => LobbyClient(ruta: '/categorias'),
  '/tiendas': (context) => LobbyClient(ruta: '/tiendas'),
  '/miTienda': (context) => LobbyClient(ruta: '/miTienda'),
  '/productos': (context) => LobbyClient(ruta: '/productos'),
  '/masVendidos': (context) => LobbyClient(ruta: '/masVendidos'),
  '/ofertas': (context) => LobbyClient(ruta: '/ofertas'),
  // V e n d e d o r  W E B
  '/farmacia/login': (context) => LobbyVendor(ruta: '/farmacia/login'),
  '/farmacia/login/miTienda': (context) =>
      LobbyVendor(ruta: '/farmacia/miTienda/'),
  '/farmacia/registro': (context) => LobbyVendor(ruta: '/farmacia/registro'),
  '/farmacia/miCuenta': (context) => LobbyVendor(ruta: '/farmacia/miCuenta'),
  '/farmacia/miTienda/': (context) => LobbyVendor(ruta: '/farmacia/miTienda/'),

  '/farmacia/cargar-productos/': (context) =>
      LobbyVendor(ruta: '/farmacia/cargar-productos/'),
  '/farmacia/terminos-y-condiciones': (context) => TermCondVendedor()
};

// var rutasDrug = {
//   '/splash': (context) => SplashScreen(),
//   // C l i e n t e
//   '/login': (context) => LoginPage(),
//   '/registro': (context) => RegisterPage(),
//   '/home': (context) => HomeClient(),
//   '/miCuenta': (context) => MiCuentaClient(),
//   '/fav': (context) => ProductoViewPage(
//         title: 'Mis favoritos',
//       ),
//   '/carrito': (context) => CarritoPage(),
//   '/categorias': (context) => CategoriaPage(),
//   '/tiendas': (context) => TiendasPage(),
//   '/miTienda': (context) => MiTienda(),
//   '/masVendidos': (context) => ProductoViewPage(
//         title: 'Más vendidos',
//       ),
//   '/ofertas': (context) => ProductoViewPage(
//         title: 'Ofertas del día',
//       ),
//   // V e n d e d o r  W E B
//   '/farmacia/login': (context) => LoginVendedor(),
//   '/farmacia/login/miTienda': (context) => LoginVendedor(
//         miTienda: true,
//       ),
//   '/farmacia/registro': (context) => RegisterVendedor(),
//   '/farmacia/miCuenta': (context) => MiCuentaVendedor(),
//   '/farmacia/miTienda/': (context) => MiTiendaVendedor(),
//   '/farmacia/terminos-y-condiciones': (context) => TermCondVendedor(),
//   '/farmacia/cargar-productos/': (context) => CargarProductos(),
// };
