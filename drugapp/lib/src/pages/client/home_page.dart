import 'dart:convert';

import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/Lobby/validate_page.dart';
import 'package:drugapp/src/pages/client/carrito_page.dart';
import 'package:drugapp/src/pages/client/miCuenta_page.dart';
import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/pages/client/tiendas_page.dart';
import 'package:drugapp/src/service/jsFlutter/auth_class.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/card_widget.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'categorie_page.dart';

class HomeClient extends StatefulWidget {
  HomeClient({Key key}) : super(key: key);

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  var cat = [];
  RestFun rest = RestFun();

  var banner = [];
  bool load = true;

  @override
  void initState() {
    AuthManager.instance.homeFunction().then((value) {
      if (value != 'load') {
        try {
          Navigator.pushNamed(context, value).then((value) => setState(() {}));
        } catch (e) {
          Navigator.pushNamed(context, '/login')
              .then((value) => setState(() {}));
        }
      } else {
        setState(() {
          load = false;
        });
      }
    });

    // var url = window.location.href;

    // if (url.contains('farmacia')) {
    //   validateFarmaciaToken();
    // } else if (url.contains('terminos-y-condiciones') ||
    //     url.contains('aviso-de-privacidad')) {
    //   try {
    // Navigator.pushNamed(context, window.location.pathname.toString())
    //     .then((value) => setState(() {}));
    //   } catch (e) {
    //     validateToken();
    //   }
    // } else {
    //   validateToken();
    // }

    super.initState();
  }

  // validateToken() async {
  //   await validateClientToken(context).then((value) {
  //     if (!value) {
  //       if (window.location.pathname.toString().contains('Recuperar')) {
  //         Navigator.pushNamedAndRemoveUntil(
  //             context, window.location.pathname.toString(), (route) => false);
  //       } else {
  //         Navigator.pushNamed(context, '/login')
  //             .then((value) => setState(() {}));
  //       }
  //     } else {
  // setState(() {
  //   load = false;
  // });
  //     }
  //   });
  // }

  // validateFarmaciaToken() async {
  //   var url = window.location.href;

  //   await validateVendorToken(context).then((value) {
  //     if (url.contains('farmacia')) {
  //       validateVendorToken(context).then((value) {
  //         if (!value) {
  //           Navigator.pushNamed(context, '/farmacia/login/')
  //               .then((value) => setState(() {}));
  //         } else {
  //           if (url.contains('/login') || url.contains('/registro')) {
  //             Navigator.pushNamedAndRemoveUntil(
  //                     context, '/farmacia/miCuenta/', (route) => false)
  //                 .then((value) => setState(() {}));
  //           } else {
  //             Navigator.pushNamedAndRemoveUntil(
  //                 context,
  //                 window.location.pathname.toString(),
  //                 (route) => false).then((value) => setState(() {}));
  //           }
  //         }
  //       });
  //     } else {}
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return load
        ? Scaffold(body: bodyLoad(context))
        : MediaQuery.of(context).size.width > 1000
            ? BodyHome()
            : BodyHomeMobile(
                tabIndex: 0,
              );
  }
}

class BodyHomeMobile extends StatefulWidget {
  final dynamic tabIndex;

  BodyHomeMobile({Key key, this.tabIndex}) : super(key: key);

  @override
  _BodyHomeMobileState createState() => _BodyHomeMobileState();
}

class _BodyHomeMobileState extends State<BodyHomeMobile>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  CatalogBloc _catalogBloc = CatalogBloc();

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    _tabController = new TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
    _tabController.index = widget.tabIndex == null ? 0 : widget.tabIndex;
  }

  @override
  void dispose() {
    _catalogBloc.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBar(
        screenWidht: MediaQuery.of(context).size.width,
        drawerMenu: true,
        bottomNavigationBar: Container(
          child: SafeArea(
            child: Container(
              color: bgGrey,
              child: TabBar(
                indicatorWeight: 4,
                labelStyle: TextStyle(fontSize: 12),
                controller: _tabController,
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                      text: 'Inicio',
                      icon: Icon(
                        Icons.home_outlined,
                        color: _tabController.index == 0
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        size: 30,
                      )),
                  Tab(
                      text: 'Favoritos',
                      icon: Icon(
                        Icons.favorite_outline,
                        size: 30,
                        color: _tabController.index == 1
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      )),
                  Tab(
                      text: 'Categorias',
                      icon: Icon(
                        Icons.category_outlined,
                        size: 27,
                        color: _tabController.index == 2
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      )),
                  Tab(
                      text: 'Compras',
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        color: _tabController.index == 3
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      )),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            BodyHome(
              showAppBar: false,
            ),
            ProductView(
              showAppBar: false,
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
            ),
            CategoriaPage(
              showAppBar: false,
            ),
            TabCompras(),
          ],
        ),
        title: null);
  }
}

class BodyHome extends StatefulWidget {
  final bool showAppBar;

  BodyHome({Key key, this.showAppBar = true}) : super(key: key);

  @override
  _BodyHomeState createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  CatalogBloc _catalogBloc = CatalogBloc();

  ProductoModel productoModel = ProductoModel();

  RestFun rest = RestFun();

  bool loadBanner = true;
  bool errorBanner = false;
  String errorBannerStr;

  var banner = [];
  var prod;

  bool favProduct = false;

  bool loadProd = true;

  bool errorProd = false;
  String errorStrProd;

  bool loadCat = true;

  bool errorCat = false;
  String errorStrCat;

  var cat;

  List marcasList = [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset('images/pisa.png'),
        Image.asset('images/pfizer.png'),
        Image.asset('images/novo.png'),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset('images/novartis.png'),
        Image.asset('images/msd.png'),
        Image.asset('images/merck.png'),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset('images/lilly.png'),
        Image.asset('images/fresenius.png'),
        Image.asset('images/baxter.png'),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset('images/astra.png'),
        Image.asset('images/abb.png'),
        Image.asset('images/3m.png'),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset('images/sophia.png'),
        Image.asset('images/roche.png'),
        // Image.asset('images/ 3m.png'),
      ],
    )
  ];

  @override
  void initState() {
    super.initState();

    _catalogBloc = CatalogBloc();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    sharedPrefs.init().then((value) => getBanner());
  }

  @override
  void dispose() {
    _catalogBloc.dispose();
    super.dispose();
  }

  getBanner() async {
    String myDate = "${DateTime.now().year}-${DateTime.now().month}-01";
    var arrayData = {"fecha_de_exposicion": myDate};
    await rest
        .restService(arrayData, '${urlApi}obtener/banners',
            sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp);
        setState(() {
          banner = dataResp[1];
          banner.sort((banner0, banner1) =>
              int.parse(banner0['posicion']) >= int.parse(banner1['posicion'])
                  ? 1
                  : 0);
          print(banner);
          loadBanner = false;
        });
        getProductos();
        getCat();
      } else {
        setState(() {
          loadBanner = false;
          errorBanner = true;
          errorBannerStr = value['message'];
        });
        getProductos();
        getCat();
      }
    });
  }

  getProductos() async {
    var arrayData = {
      "stock": "available",
    };

    await rest
        .restService(arrayData, '$apiUrl/listar/producto',
            sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        print('okkk');
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp)[1]['results'];
        setState(() {
          prod = dataResp;
          // orden = dataResp.values.toList();
          loadProd = false;
        });
      } else {
        setState(() {
          loadProd = false;
          errorProd = true;
          errorStrProd = value['message'];
        });
      }
    });
  }

  getCat() async {
    await rest
        .restService(
            null, '${urlApi}obtener/categorias', sharedPrefs.clientToken, 'get')
        .then((value) {
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp);
        setState(() {
          cat = dataResp[1]['categories'];
          loadCat = false;
        });
      } else {
        setState(() {
          loadCat = false;
          errorCat = true;
          errorStrCat = value['message'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.showAppBar
        ? ResponsiveAppBar(
            extendedBar: true,
            screenWidht: MediaQuery.of(context).size.width,
            drawerMenu: true,
            body: bodyHome(),
            title: null)
        : bodyHome();
  }

  bodyHome() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: StreamBuilder<List<ProductoModel>>(
              initialData: [],
              stream: _catalogBloc.catalogStream,
              builder: (context, snapshot) {
                return ListView(children: [
                  CarouselWithIndicatorDemo(),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: smallPadding,
                        horizontal: MediaQuery.of(context).size.width > 100
                            ? smallPadding
                            : medPadding),
                    color: bgGrey,
                    height: MediaQuery.of(context).size.width * 0.35,
                    width: MediaQuery.of(context).size.width,
                    child: loadBanner
                        ? bodyLoad(context)
                        : banner.length == 0
                            ? getAsset('bannerPH.png', constraints.maxWidth)
                            : Swiper(
                                itemCount: banner.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    // Image.asset("images/${imgList[index]}", fit: BoxFit.cover),
                                    InkWell(
                                  // onTap: () => launchURL(banner[index]['link_externo']),
                                  child: getNetworkImage(constraints.maxWidth >
                                          1000
                                      ? banner[index]['imagen_escritorio']
                                      : banner[index]['imagen_movil'] == null
                                          ? banner[index]['imagen_escritorio']
                                          : banner[index]['imagen_movil']),
                                ),
                                autoplay: true,
                                autoplayDelay: 5000,
                                scrollDirection: Axis.horizontal,
                                pagination: new SwiperPagination(
                                    builder: new DotSwiperPaginationBuilder(
                                        color: Colors.white.withOpacity(0.5),
                                        activeColor:
                                            Theme.of(context).primaryColor),
                                    margin: new EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    alignment: Alignment.bottomCenter),
                              ),
                  ),
                  // SizedBox(
                  //   height: smallPadding / 1.5,
                  // ),
                  // constraints.maxWidth < 1000
                  //     ? Container(
                  //         alignment: Alignment.center,
                  //         height: MediaQuery.of(context).size.height * 0.15,
                  //         child: ListView.builder(
                  //           itemCount: widget.cat.length,
                  //           shrinkWrap: true,
                  //           scrollDirection: Axis.horizontal,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             return HomeCategory(cat: widget.cat[index]);
                  //           },
                  //         ),
                  //       )
                  //     : Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           HomeCategory(cat: widget.cat[0]),
                  //           HomeCategory(cat: widget.cat[1]),
                  //           HomeCategory(cat: widget.cat[2]),
                  //           HomeCategory(cat: widget.cat[3]),
                  //           HomeCategory(cat: widget.cat[4]),
                  //         ],
                  //       ),
                  // SizedBox(height: smallPadding),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    child: constraints.maxWidth > 1000
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: HomeInfoCard(
                                title: 'Tiendas',
                                image: 'drug1.jpg',
                                nav: () =>
                                    Navigator.pushNamed(context, '/tiendas')
                                        .then((value) => setState(() {}))
                                        .then((value) => getProductos()),
                              )),
                              Flexible(
                                  child: HomeInfoCard(
                                title: 'Productos',
                                image: 'drug2.jpg',
                                nav: () =>
                                    Navigator.pushNamed(context, '/productos')
                                        .then((value) => setState(() {}))
                                        .then((value) => getProductos()),
                              )),
                              Flexible(
                                  child: HomeInfoCard(
                                title: 'Categorias',
                                image: 'drug3.jpg',
                                nav: () =>
                                    Navigator.pushNamed(context, '/categorias')
                                        .then((value) => setState(() {}))
                                        .then((value) => getProductos()),
                              )),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HomeInfoCard(
                                title: 'Tiendas',
                                image: 'drug1.jpg',
                                nav: () =>
                                    Navigator.pushNamed(context, '/tiendas')
                                        .then((value) => setState(() {}))
                                        .then((value) => getProductos()),
                              ),
                              HomeInfoCard(
                                title: 'Productos',
                                image: 'drug2.jpg',
                                nav: () =>
                                    Navigator.pushNamed(context, '/productos')
                                        .then((value) => setState(() {}))
                                        .then((value) => getProductos()),
                              ),
                              HomeInfoCard(
                                title: 'Categorias',
                                image: 'drug3.jpg',
                                nav: () =>
                                    Navigator.pushNamed(context, '/categorias')
                                        .then((value) => setState(() {}))
                                        .then((value) => getProductos()),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: medPadding,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: medPadding / 2 + smallPadding,
                    ),
                    child: Text(
                      'AGREGADOS RECIENTEMENTE',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                  loadProd
                      ? bodyLoad(context)
                      : errorProd
                          ? Text(errorStrProd, style: estiloErrorStr)
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: medPadding / 2),
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                childAspectRatio: (250 / 350),
                                primary: false,
                                // Create a grid with 2 columns. If you change the scrollDirection to
                                // horizontal, this produces 2 rows.
                                crossAxisCount: MediaQuery.of(context)
                                            .size
                                            .width <
                                        1150
                                    ? MediaQuery.of(context).size.width < 600
                                        ? MediaQuery.of(context).size.width <
                                                500
                                            ? 2
                                            : 3
                                        : 4
                                    : 6,
                                // Generate 100 widgets that display their index in the List.
                                children: List.generate(
                                    constraints.maxWidth > 1000
                                        ? prod.length > 12
                                            ? 12
                                            : prod.length
                                        : prod.length > 4
                                            ? 4
                                            : prod.length, (index) {
                                  return productFav(
                                      true, prod[index], snapshot.data);
                                }),
                              )),
                  SizedBox(
                    height: medPadding,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: medPadding / 2 + smallPadding,
                    ),
                    child: Text(
                      'CATEGORÍAS DE SALUD',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                  // loadCat
                  //     ? bodyLoad(context)
                  //     : errorCat
                  //         ? Text(errorStrCat, style: estiloErrorStr)
                  //         : Container(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: medPadding / 2),
                  //             child: GridView.count(
                  //               shrinkWrap: true,
                  //               childAspectRatio: (250 / 350),
                  //               primary: false,
                  //               // Create a grid with 2 columns. If you change the scrollDirection to
                  //               // horizontal, this produces 2 rows.
                  //               crossAxisCount: MediaQuery.of(context)
                  //                           .size
                  //                           .width <
                  //                       1150
                  //                   ? MediaQuery.of(context).size.width < 600
                  //                       ? MediaQuery.of(context).size.width <
                  //                               500
                  //                           ? 2
                  //                           : 3
                  //                       : 4
                  //                   : 5,
                  //               // Generate 100 widgets that display their index in the List.
                  //               children: List.generate(
                  //                   constraints.maxWidth > 1000
                  //                       ? cat.length > 5
                  //                           ? 5
                  //                           : cat.length
                  //                       : cat.length > 4
                  //                           ? 4
                  //                           : cat.length, (index) {
                  //                 return categorieCard(cat[index]);
                  //               }),
                  //             )),
                  // : Container(
                  //     height: 350,
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: medPadding / 2),
                  //     child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       // physics: NeverScrollableScrollPhysics(),
                  //       shrinkWrap: true,
                  //       itemCount: cat.length,
                  //       itemBuilder: (BuildContext context, int index) {
                  //         return categorieCard(cat[index]);
                  //       },
                  //     ),
                  //   ),
                  SizedBox(
                    height: medPadding,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: medPadding / 2 + smallPadding,
                    ),
                    child: Text(
                      'MÉTODOS DE PAGO',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: medPadding,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: medPadding / 2 + smallPadding,
                    ),
                    child: Text(
                      'NUESTROS ENVIOS',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: medPadding,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: medPadding / 2 + smallPadding,
                    ),
                    child: Text(
                      'TODAS TUS MARCAS DE CONFIANZA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 27),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: medPadding / 2 + smallPadding,
                    ),
                    child: Text(
                      'Trabajamos con los laboratorios y las marcas más importnantes a nivel mundial.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: medPadding / 2 + smallPadding,
                    ),
                    child: Text(
                      'Más de 300 empresas con los más altos estándares de calidad mundial, avalados por la COFEPRIS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 20),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(
                  //       vertical: smallPadding,
                  //       horizontal: MediaQuery.of(context).size.width > 1000
                  //           ? medPadding * 3
                  //           : smallPadding),
                  //   // color: bgGrey,
                  //   height: MediaQuery.of(context).size.width * 0.25,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Swiper(
                  //     autoplay: true,
                  //     autoplayDelay: 5000,
                  //     itemCount: marcasList.length,
                  //     itemBuilder: (BuildContext context, int index) =>
                  //         marcasList[index],
                  //     // Image.asset("images/logoDrug.png", fit: BoxFit.cover),
                  //     scrollDirection: Axis.horizontal,
                  //     pagination: new SwiperControl(padding: EdgeInsets.all(0)),
                  //   ),
                  // ),
                  SizedBox(height: medPadding),
                  Container(
                    padding: EdgeInsets.all(medPadding),
                    width: MediaQuery.of(context).size.width,
                    color: bgGrey,
                    child: constraints.maxWidth > 1000
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: cardInfoDrug(
                                      context,
                                      Icons.medical_services_outlined,
                                      'Todas tus marcas de confianza ',
                                      'Trabajamos con los laboratorios y las marcas más importantes a nivel mundial.')),
                              Flexible(
                                  child: cardInfoDrug(
                                      context,
                                      Icons.local_shipping_outlined,
                                      'Envios a todo México',
                                      'Recibe tu pedido de 2 a 3 días hábiles.')),
                              Flexible(
                                  child: cardInfoDrug(
                                      context,
                                      Icons.payment_outlined,
                                      'Paga con tu tarjeta de crédito o débito',
                                      'No te preocupes por tu información, tus transacciones están seguras con nosotros.')),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              cardInfoDrug(
                                  context,
                                  Icons.medical_services_outlined,
                                  'Todas tus marcas de confianza ',
                                  'Trabajamos con los laboratorios y las marcas más importantes a nivel mundial.'),
                              cardInfoDrug(
                                  context,
                                  Icons.local_shipping_outlined,
                                  'Envios a todo México',
                                  'Recibe tu pedido de 2 a 3 días hábiles.'),
                              cardInfoDrug(
                                  context,
                                  Icons.payment_outlined,
                                  'Paga con tu tarjeta de crédito o débito',
                                  'No te preocupes por tu información, tus transacciones están seguras con nosotros.'),
                            ],
                          ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(medPadding / 2),
                  //   width: MediaQuery.of(context).size.width,
                  //   color: Color(0xffefefef),
                  //   child: RichText(
                  //     textAlign: TextAlign.center,
                  //     text: TextSpan(
                  //       text: 'Drug Farmacéutica. ',
                  //       style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w700,
                  //           color: Colors.grey),
                  //       children: <TextSpan>[
                  //         TextSpan(
                  //             text: 'Todos los derechos reservados 2021.',
                  //             style: TextStyle(
                  //                 color: Colors.grey,
                  //                 fontWeight: FontWeight.w400))
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  footterWidget(context)
                ]);
              }));
    });
  }

  categorieCard(cat) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context,
              '/productos/' + cat['categoria_id'] + '/' + cat['nombre'])
          .then((value) => setState(() {})),
      child: Container(
        width: 250,
        height: 350,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 4, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                3.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        // image: DecorationImage(
        //     image: getNetworkImage(cat['imagen']), fit: BoxFit.cover)
        //     ),
        margin: EdgeInsets.symmetric(
            horizontal: smallPadding / 2, vertical: smallPadding * 0.5),
        // child: Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Container(
        //       padding: EdgeInsets.all(smallPadding / 2),
        //       width: double.infinity,
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).primaryColor.withOpacity(0.7),
        //       ),
        //       child: Text(
        //         cat['nombre'],
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //         style: TextStyle(
        //             color: Colors.white,
        //             fontWeight: FontWeight.w500,
        //             fontSize: 17),
        //       )),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            getNetworkImage(
              cat['imagen'],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    cat['nombre'],
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  productFav(fav, prod, snapshot) {
    bool inCart = false;
    int index;

    if (snapshot.length > 0) {
      for (int i = 0; i <= snapshot.length - 1; i++) {
        if (snapshot[i].idDeProducto == prod['id_de_producto']) {
          inCart = true;
          index = i;
        }
      }
    }

    var size = MediaQuery.of(context).size;
    // final double itemHeight = 280;
    // final double itemWidth = 200;
    ProductoModel productoModel = ProductoModel();
    productoModel = ProductoModel.fromJson(prod);
    if (productoModel.favorito == false) {
      favProduct = false;
    } else {
      favProduct = true;
    }
    return Container(
      margin: EdgeInsets.all(smallPadding * 0.7),
      padding: EdgeInsets.all(smallPadding * 0.4),
      // height: itemHeight,
      // width: itemWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 4, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              0.0, // Move to right 10  horizontally
              3.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context,
                '/detalles/producto/' + productoModel.idDeProducto.toString())
            .then((value) => setState(() {}))
            .then((value) => getProductos()),
        child: Column(
          children: [
            Flexible(
                flex: 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    productoModel.galeria.length == 0
                        ? Image(
                            fit: BoxFit.contain,
                            image: AssetImage("images/logoDrug.png"),
                          )
                        : Image(
                            fit: BoxFit.contain,
                            image:
                                NetworkImage(productoModel.galeria[0]['url']),
                          ),
                    Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => addFav(productoModel.idDeProducto,
                              productoModel.favorito),
                          child: Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    blurRadius: 4, // soften the shadow
                                    spreadRadius: 1.0, //extend the shadow
                                    offset: Offset(
                                      0.0, // Move to right 10  horizontally
                                      3.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              favProduct
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline,
                              color: Colors.pink[300],
                              size: 17,
                            ),
                          ),
                        )),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          width: 45,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.star, color: Colors.amber, size: 15),
                              RatingBarIndicator(
                                unratedColor: Colors.white.withOpacity(0.5),
                                rating: productoModel.rating == null
                                    ? 0
                                    : double.parse(productoModel.rating) *
                                        100 /
                                        5 /
                                        100,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 1,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                              Text(
                                  productoModel.rating == null
                                      ? "0"
                                      : double.parse(productoModel.rating)
                                          .toStringAsFixed(1),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))
                            ],
                          )),
                    ),
                  ],
                )),
            Flexible(
              flex: 3,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      productoModel.nombre,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      productoModel.nombre_farmacia,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${productoModel.precio}',
                          style: TextStyle(
                              color: Colors.black45,
                              decoration:
                                  productoModel.precioConDescuento == null
                                      ? null
                                      : TextDecoration.lineThrough),
                        ),
                        productoModel.precioConDescuento == null
                            ? Container()
                            : Text(
                                '\$${productoModel.precioConDescuento}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700),
                              ),
                      ],
                    ),
                    int.parse(productoModel.stock) <= 0
                        ? Text(
                            'No disponilbe',
                            style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                flex: 2,
                                child: Material(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(40),
                                  child: new InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (inCart) {
                                          if (snapshot[index].cantidad > 1) {
                                            productoModel.cantidad =
                                                snapshot[index].cantidad - 1;
                                            _catalogBloc.sendEvent.add(
                                                EditCatalogItemEvent(
                                                    productoModel));
                                            setState(() {});
                                          } else {
                                            productoModel.cantidad =
                                                snapshot[index].cantidad;
                                            _catalogBloc.sendEvent.add(
                                                RemoveCatalogItemEvent(
                                                    productoModel));
                                            setState(() {});
                                          }
                                        }
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(40),
                                    child: new Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  // padding: EdgeInsets.symmetric(
                                  //     vertical: 0.3, horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: bgGrey),
                                  alignment: Alignment.center,
                                  child: Text(
                                      inCart
                                          ? snapshot[index].cantidad.toString()
                                          : '0',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Material(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(40),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        inCart
                                            ? productoModel.cantidad =
                                                snapshot[index].cantidad + 1
                                            : productoModel.cantidad = 1;
                                        _catalogBloc.sendEvent.add(
                                            EditCatalogItemEvent(
                                                productoModel));
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(40),
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(flex: 1, child: Container()),
                            ],
                          ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            inCart
                                ? productoModel.cantidad =
                                    snapshot[index].cantidad + 1
                                : productoModel.cantidad = 1;
                            _catalogBloc.sendEvent
                                .add(EditCatalogItemEvent(productoModel));
                          });
                        },
                        child: Text('Agregar al carrito',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline)))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addFav(idProd, fav) async {
    var arrayData = {"id_de_producto": idProd};

    String url = fav ? '$apiUrl/desmarcar/favorito' : '$apiUrl/marcar/favorito';

    await rest
        .restService(arrayData, url, sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        setState(() {
          fav = !fav;
        });
        getProductos();
      } else {}
    });
  }
}

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    // final List<Widget> imageSliders = imgList
    //     .map((item) => Container(
    //           height: MediaQuery.of(context).size.width > 1000
    //               ? MediaQuery.of(context).size.height * 0.6
    //               : MediaQuery.of(context).size.height * 0.4,
    //           child: Image.network(item, fit: BoxFit.cover),
    //         ))
    //     .toList();

    return Column(children: []);
  }
}

Widget footterWidget(context) {
  return Expanded(
    child: Container(
      // padding: EdgeInsets.all(medPadding),
      color: Colors.grey[400],
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        Container(
          padding: EdgeInsets.all(medPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              sobreDrug(),
              ayudaSoporte(),
              alianza(),
              atencion(),
              druginfo()
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: medPadding),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '¡Síguenos!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text('Descarga la app',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                ])),
        Container(
          padding: EdgeInsets.all(smallPadding),
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Text(
            'DRUG INTERNATIONAL CORP. TODOS LOS DERECHOS RESERVADOS 2021',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w100,
              fontSize: 13,
            ),
          ),
        )
      ]),
    ),
  );
}

Widget sobreDrug() {
  return miInfoFootter(
      'Sobre Drug',
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('Conócenos'), Text('Info Salud'), Text('Drug News')],
      ));
}

Widget ayudaSoporte() {
  return miInfoFootter(
      'Ayuda & Soporte',
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pedidos'),
          Text('Localizar un Producto'),
          Text('Devoluciones'),
          Text('Información general')
        ],
      ));
}

Widget alianza() {
  return miInfoFootter(
      'Alianzas',
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vender en Drug'),
          Text('Laboratorios y Marcas'),
          Text('Colaboraciones'),
          Text('Promociones')
        ],
      ));
}

Widget atencion() {
  return miInfoFootter(
      'Atenciṕon global',
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Centros de Envíos Drug'),
          Text('Proguntas Frecuentes'),
          Text('Términos y Condiciones'),
          Text('Aviso de Provacidad')
        ],
      ));
}

druginfo() {
  return miInfoFootter(
      null,
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Empresa, Productos y Alianzas Reguladas'),
          Text('Por la COFEPRIS en México'),
          Text('CONTACTO'.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('info@drugsiteonline.com'),
          Text('+52 55333993829')
        ],
      ));
}

Widget miInfoFootter(String title, Widget info) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title == null
          ? Container()
          : Text(title.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold)),
      info
    ],
  );
}
