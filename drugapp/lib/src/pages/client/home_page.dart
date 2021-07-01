import 'dart:convert';

import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/Lobby/validate_page.dart';
import 'package:drugapp/src/service/jsFlutter/auth_class.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/card_widget.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
    cat = jsonDecode(dummyCat);

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
    return load ? Scaffold(body: bodyLoad(context)) : BodyHome(cat: cat);
  }
}

final List<String> imgList = [
  'cover1.png',
  'cover2.png',
];

class BodyHome extends StatefulWidget {
  final dynamic cat;
  BodyHome({Key key, this.cat}) : super(key: key);

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

  var cat = [];

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
      } else {
        setState(() {
          loadBanner = false;
          errorBanner = true;
          errorBannerStr = value['message'];
        });
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

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBar(
        screenWidht: MediaQuery.of(context).size.width,
        drawerMenu: true,
        body: bodyHome(),
        title: null);
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
                        : banner.length == 0 ?  getAsset('bannerPH.png', constraints.maxWidth) :Swiper(
                            itemCount: banner.length,
                            itemBuilder: (BuildContext context, int index) =>
                                // Image.asset("images/${imgList[index]}", fit: BoxFit.cover),
                                InkWell(
                              // onTap: () => launchURL(banner[index]['link_externo']),
                              child: getNetworkImage(constraints.maxWidth > 1000
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
                      'Agregado recientemente',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 27),
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
                                childAspectRatio: (250 / 350),
                                primary: false,
                                // Create a grid with 2 columns. If you change the scrollDirection to
                                // horizontal, this produces 2 rows.
                                crossAxisCount: MediaQuery.of(context)
                                            .size
                                            .width <
                                        1150
                                    ? MediaQuery.of(context).size.width < 700
                                        ? 2
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
                  Container(
                    padding: EdgeInsets.all(medPadding / 2),
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffefefef),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Drug Farmacéutica. ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Todos los derechos reservados 2021.',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                  )
                ]);
              }));
    });
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
                      maxLines: 3,
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
                                          } else {
                                            productoModel.cantidad =
                                                snapshot[index].cantidad;
                                            _catalogBloc.sendEvent.add(
                                                RemoveCatalogItemEvent(
                                                    productoModel));
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
                          )
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
