import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/client/categorie_page.dart';
import 'package:drugapp/src/pages/client/miCuenta_page.dart';
import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/pages/client/tiendas_page.dart';
import 'package:drugapp/src/pages/vendedor/tabProductos_page.dart';
import 'package:drugapp/src/service/jsFlutter/auth_class.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/buttom_widget.dart';
import 'package:drugapp/src/widget/card_widget.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ProductoDetalles extends StatefulWidget {
  static const routeName = '/detallesProdcuto';

  final dynamic productID;

  ProductoDetalles({Key key, this.productID}) : super(key: key);

  @override
  _ProductoDetallesState createState() => _ProductoDetallesState();
}

class _ProductoDetallesState extends State<ProductoDetalles> {
  var prod = [];
  CatalogBloc _catalogBloc = CatalogBloc();
  RestFun restFun = RestFun();
  var tiendas = [];
  ProductoModel productModel = ProductoModel();
  UserModel userModel = UserModel();

  String errorStr;
  bool load = true;
  bool error = false;
  bool fav = false;

  var prods;

  bool favProduct = false;

  bool loadProd = true;

  bool errorProd = false;
  String errorStrProd;

  double calificacion;

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    sharedPrefs.init().then((value) {
      getProductos();
      getProdcut();
    });
    sharedPrefs.init().then((value) {
      setState(() {
        userModel = UserModel.fromJson(jsonDecode(sharedPrefs.clientData));
      });
    });
  }

  getProdcut() async {
    var arrayData = {"id_de_producto": widget.productID.toString()};
    await restFun
        .restService(arrayData, '$apiUrl/obtener/producto',
            sharedPrefs.clientToken, 'post')
        .then((value) {
      print(value);
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp);
        setState(() {
          prod = dataResp;
          print('*****' + prod[1].length.toString());
          if (prod[1].length == 0) {
            load = false;
            error = true;
            errorStr = 'No se encontro el producto';
          } else {
            productModel = ProductoModel.fromJson(dataResp[1][0]);
            fav = productModel.favorito;
            load = false;
            if (productModel.rating != null) {
              calificacion = double.parse(
                  double.parse(productModel.rating).toStringAsFixed(1));
            }
          }
        });
        // labelEtiquetatoList();
        // labelCattoList();
      } else {
        setState(() {
          load = false;
          error = true;
          errorStr = value['message'];
        });
      }
    });
  }

  getProductos() async {
    var arrayData = {
      "stock": "available",
    };

    await restFun
        .restService(arrayData, '$apiUrl/listar/producto',
            sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        print('okkk');
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp)[1]['results'];
        setState(() {
          prods = dataResp;
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
  void dispose() {
    _catalogBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ResponsiveAppBar(
          screenWidht: MediaQuery.of(context).size.width,
          body: StreamBuilder<List<ProductoModel>>(
              initialData: [],
              stream: _catalogBloc.catalogStream,
              builder: (context, snapshot) {
                // var index;
                // bool inCart = false;
                // for (int i = 0; i <= snapshot.data.length - 1; i++) {
                //   if (snapshot.data[i].idDeProducto ==
                //       productModel.idDeProducto) {
                //     index = i;
                //     inCart = true;
                //   }
                // }
                return load
                    ? bodyLoad(context)
                    : error
                        ? errorWidget(errorStr, context)
                        : bodyProdcuto(snapshot.data);
              }),
          title: load
              ? ''
              : productModel.nombre == null
                  ? 'Producto no encontrado'
                  : "${productModel.nombre.toString()}");
    });
  }

  bodyProdcuto(snapshot) {
    var size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width > 700 ? size.width / 5 : medPadding * .5,
            vertical: size.width > 700 ? medPadding * 1.5 : medPadding * 0.5),
        color: bgGrey,
        width: size.width,
        child: listProdcut(snapshot),
      ),
      showFavorites(snapshot),
      // footer(context),
    ]);
  }

  listProdcut(snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          BotonSimple(
            contenido:
                Text('Ver carrito', style: TextStyle(color: Colors.white)),
            estilo: estiloBotonPrimary,
            action: () => Navigator.pushNamed(context, '/carrito')
                .then((value) => setState(() {})),
          ),
        ]),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, product(snapshot))),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, descProducto())),
        SizedBox(
          height: smallPadding,
        ),
        productModel.categorias.length > 0
            ? SizedBox(
                height: smallPadding,
              )
            : Container(),
        productModel.etiquetas.length > 0
            ? Container(child: misDetalles(context, labels()))
            : Container(),
      ],
    );
  }

  misDetalles(context, Widget contenido) {
    var size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(smallPadding * 2),
        width: size.width,
        // height: size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 5.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                3.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: contenido);
  }

  product(snapshot) {
    var index;
    bool inCart = false;
    for (int i = 0; i <= snapshot.length - 1; i++) {
      if (snapshot[i].idDeProducto == productModel.idDeProducto) {
        index = i;
        inCart = true;
      }
    }
    return MediaQuery.of(context).size.width < 700
        ? Container(
            // height: MediaQuery.of(context).size.height/2,
            child: Column(
              children: [
                productTitle(),
                SizedBox(
                  height: smallPadding,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.7,
                  child: productSwiper(),
                ),
                SizedBox(
                  height: smallPadding,
                ),
                int.parse(productModel.stock) <= 0
                    ? Text(
                        'No disponilbe',
                        style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            Flexible(flex: 3, child: Container()),
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
                                          productModel.cantidad =
                                              snapshot[index].cantidad - 1;
                                          _catalogBloc.sendEvent.add(
                                              EditCatalogItemEvent(
                                                  productModel));
                                        } else {
                                          productModel.cantidad =
                                              snapshot[index].cantidad;
                                          _catalogBloc.sendEvent.add(
                                              RemoveCatalogItemEvent(
                                                  productModel));
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
                                height: 35,
                                width: 35,
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
                                          ? productModel.cantidad =
                                              snapshot[index].cantidad + 1
                                          : productModel.cantidad = 1;
                                      _catalogBloc.sendEvent.add(
                                          EditCatalogItemEvent(productModel));
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
                            Flexible(flex: 3, child: Container()),
                          ]),
                InkWell(
                    onTap: () {
                      setState(() {
                        inCart
                            ? productModel.cantidad =
                                snapshot[index].cantidad + 1
                            : productModel.cantidad = 1;
                        _catalogBloc.sendEvent
                            .add(EditCatalogItemEvent(productModel));
                      });
                    },
                    child: Text('Agregar al carrito',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline))),
                SizedBox(
                  height: smallPadding,
                ),
                // InkWell(
                //   onTap: () => _displayDialog().then((value) => getProdcut()),
                //   child: Text(
                //     'Evaluar producto',
                //     style: TextStyle(
                //         color: Colors.blue,
                //         decoration: TextDecoration.underline),
                //   ),
                // ),
                // SizedBox(
                //   height: smallPadding,
                // ),
                productPrice(),
              ],
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  flex: 3,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: productSwiper(),
                        ),
                        // InkWell(
                        //   onTap: () =>
                        //       _displayDialog().then((value) => getProdcut()),
                        //   child: Text(
                        //     'Evaluar producto',
                        //     style: TextStyle(
                        //         color: Colors.blue,
                        //         decoration: TextDecoration.underline),
                        //   ),
                        // )
                        // SizedBox(
                        //   height: smallPadding,
                        // ),
                      ],
                    ),
                  )),
              Flexible(flex: 1, child: Container()),
              Flexible(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productTitle(),
                      productPrice(),
                      int.parse(productModel.stock) <= 0
                          ? Text(
                              'No disponilbe',
                              style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                  Flexible(flex: 3, child: Container()),
                                  Flexible(
                                    flex: 2,
                                    child: Material(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(40),
                                      child: new InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (inCart) {
                                              if (snapshot[index].cantidad >
                                                  1) {
                                                productModel.cantidad =
                                                    snapshot[index].cantidad -
                                                        1;
                                                _catalogBloc.sendEvent.add(
                                                    EditCatalogItemEvent(
                                                        productModel));
                                              } else {
                                                productModel.cantidad =
                                                    snapshot[index].cantidad;
                                                _catalogBloc.sendEvent.add(
                                                    RemoveCatalogItemEvent(
                                                        productModel));
                                              }
                                            }
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(40),
                                        child: new Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
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
                                      height: 35,
                                      width: 35,
                                      // padding: EdgeInsets.symmetric(
                                      //     vertical: 0.3, horizontal: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: bgGrey),
                                      alignment: Alignment.center,
                                      child: Text(
                                          inCart
                                              ? snapshot[index]
                                                  .cantidad
                                                  .toString()
                                              : '0',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                                ? productModel.cantidad =
                                                    snapshot[index].cantidad + 1
                                                : productModel.cantidad = 1;
                                            _catalogBloc.sendEvent.add(
                                                EditCatalogItemEvent(
                                                    productModel));
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(40),
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
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
                                  Flexible(flex: 3, child: Container()),
                                ])
                    ],
                  )),
            ],
          );
  }

  productPrice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        productModel.precioConDescuento == null
            ? Container()
            : Text(
                '\$${productModel.precio}',
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.black45),
              ),

        // Text(
        //   productModel.precioConDescuento == null
        //       ? '\$${productModel.precio}'
        //       : '\$${productModel.precioConDescuento}',
        //   style: TextStyle(
        //       fontSize: 30, fontWeight: FontWeight.w500, color: Colors.blue),
        // ),
        // Text(
        //   'IVA incluido',
        // style: TextStyle(
        //     fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black),
        // ),
        RichText(
          text: TextSpan(
            text: productModel.precioConDescuento == null
                ? '\$${productModel.precio} '
                : '\$${productModel.precioConDescuento} ',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w500, color: Colors.blue),
            children: <TextSpan>[
              TextSpan(
                text: 'IVA incluido',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        productModel.precioMayoreo == null
            ? Container()
            : RichText(
                text: TextSpan(
                  text: 'Precio mayoreo ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\$${productModel.precioMayoreo}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                      text: ' a partir de ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '${productModel.cantidadMayoreo} productos',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
        SizedBox(
            height: productModel.requiereReceta == 'SI' ? smallPadding / 2 : 0),
        productModel.requiereReceta == 'SI'
            ? Row(children: [
                Icon(Icons.medical_services_outlined, color: Colors.red[600]),
                SizedBox(width: smallPadding / 2),
                Flexible(
                  child: Text(
                    'Este producto requiere receta médica',
                    style: TextStyle(color: Colors.red[600]),
                  ),
                )
              ])
            : Container(),
        SizedBox(height: smallPadding / 2),
        Row(
          children: [
            Icon(
              Icons.local_shipping_outlined,
              color: productModel.envio_24_hrs == 'NO'
                  ? Theme.of(context).primaryColor
                  : Colors.green[400],
            ),
            SizedBox(width: smallPadding / 2),
            Flexible(
              child: Text(
                productModel.envio_24_hrs == 'NO'
                    ? 'Recibe de 2 a 4 días hábiles a partir de tu compra'
                    : 'Paga antes de las 15 hrs. y recibe en 24 hrs',
                style: TextStyle(
                    color: productModel.envio_24_hrs == 'NO'
                        ? Theme.of(context).primaryColor
                        : Colors.green[400]),
              ),
            )
          ],
        ),
        SizedBox(height: smallPadding / 2),
        Row(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: smallPadding / 2),
            Flexible(
              child: Text(
                'Envio gratis a partir de compras de \$2,500.00',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: smallPadding),
          child: labelCat(),
        ),
      ],
    );
  }

  productTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: '${productModel.nombre}  ',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
            children: <TextSpan>[
              TextSpan(
                  text: '${productModel.nombre_farmacia}',
                  // recognizer: _pressFarmacia(),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(
                              context,
                              '/productos-tienda' +
                                  '/' +
                                  productModel.farmaciaId.toString() +
                                  '/')
                          .then((value) => setState(() {}));
                    },
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        SizedBox(height: smallPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () => _displayDialog().then((value) => getProdcut()),
                child: Container(
                    width: 60,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.star, color: Colors.amber, size: 15),
                        Tooltip(
                          message: 'Califica este producto',
                          child: InkWell(
                            onTap: () =>
                                _displayDialog().then((value) => getProdcut()),
                            child: RatingBarIndicator(
                              unratedColor: Colors.white.withOpacity(0.5),
                              // rating: calificacion,
                              rating: productModel.rating == null
                                  ? 0.0
                                  : double.parse(productModel.rating) *
                                      100 /
                                      5 /
                                      100,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 1,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                          ),
                        ),
                        Text(
                            productModel.rating == null
                                ? "0"
                                : calificacion.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500))
                      ],
                    )),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => addFav(widget.productID.toString(), fav, true),
                  child: Container(
                    height: 37,
                    width: 37,
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
                      fav ? Icons.favorite_rounded : Icons.favorite_outline,
                      color: Colors.pink[300],
                      size: 25,
                    ),
                  ),
                ),
                SizedBox(width: smallPadding * 1.5),
                InkWell(
                  onTap: () => _displayShareDialog(productModel),
                  child: Container(
                    height: 37,
                    width: 37,
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
                      Icons.share_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  addFav(productID, fav, product) async {
    var arrayData = {"id_de_producto": productID};

    String url = fav ? '$apiUrl/desmarcar/favorito' : '$apiUrl/marcar/favorito';

    await restFun
        .restService(arrayData, url, sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        setState(() {
          fav = !fav;
        });
        getProdcut();
        getProductos();
      } else {}
    });
  }

  labelCat() {
    return Wrap(
      children: productModel.categorias
          .map((item) => Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(smallPadding / 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor.withOpacity(0.7)),
              child: Text(
                item['nombre'],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              )))
          .toList()
          .cast<Widget>(),
    );
  }

  labels() {
    return Wrap(
      children: productModel.etiquetas
          .map((item) => Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(smallPadding / 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor.withOpacity(0.7)),
              child: Text(
                item['nombre'],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              )))
          .toList()
          .cast<Widget>(),
    );
  }

  productSwiper() {
    return productModel.galeria.length == 0
        ? Image.asset('images/logoDrug.png')
        : Swiper(
            itemCount: productModel.galeria.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: getNetworkImage(productModel.galeria[index]['url'],),
            ),
            autoplay: false,
            autoplayDelay: 5000,
            scrollDirection: Axis.horizontal,
            pagination: new SwiperPagination(
                builder: new DotSwiperPaginationBuilder(
                    color: Colors.white.withOpacity(0.5),
                    activeColor: Theme.of(context).primaryColor),
                margin:
                    new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                alignment: Alignment.bottomCenter),
          );
  }

  descProducto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción del producto',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Text(
          productModel.descripcion.toString(),
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w300, fontSize: 17),
        ),
      ],
    );
  }

/* Start Show favorites */
  showFavorites(snapshot) {
    return Container(
      color: bgGrey,
      padding:
          EdgeInsets.symmetric(vertical: smallPadding, horizontal: medPadding),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'También te puede interesar',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            SizedBox(
              height: smallPadding,
            ),
            loadProd
                ? bodyLoad(context)
                : errorProd
                    ? Text(errorStrProd, style: estiloErrorStr)
                    : Container(
                        // padding: EdgeInsets.symmetric(horizontal: medPadding / 2),
                        child: GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: (250 / 350),
                        primary: false,
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: MediaQuery.of(context).size.width < 1150
                            ? MediaQuery.of(context).size.width < 600
                                ? MediaQuery.of(context).size.width < 500
                                    ? 2
                                    : 3
                                : 3
                            : 6,
                        // Generate 100 widgets that display their index in the List.
                        children: List.generate(
                            MediaQuery.of(context).size.width > 1000
                                ? prods.length > 6
                                    ? 6
                                    : prod.length
                                : prods.length > 3
                                    ? 3
                                    : prods.length, (index) {
                          return productFav(true, prods[index], snapshot);
                        }),
                      )),
          ]),
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
                        :  getNetworkImage(productoModel.galeria[0]['url'],),
                    Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => addFav(productoModel.idDeProducto,
                              productoModel.favorito, false),
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
                                decoration: TextDecoration.underline))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

/* End show favorites */

  _displayDialog() {
    bool errorMessage = false;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    var calificacion = 0.0;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: smallPadding, vertical: smallPadding * 3),
              scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 50.0, horizontal: 15),
              content: Container(
                width: MediaQuery.of(context).size.width / 3,
                // height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Evaluar producto",
                          style: TextStyle(
                              fontSize: 24.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                // Navigator.pushNamed(context, '/myProfile');
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                // margin: EdgeInsets.only(top: 0, bottom: 10),
                                decoration: new BoxDecoration(
                                  // color: Colors.grey.withOpacity(0.4),
                                  // borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: productModel.galeria.length == 0
                                        ? AssetImage('images/logoDrug.png')
                                        : NetworkImage(
                                            productModel.galeria[0]['url']),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "¿Con cuántas estrellas calificas a el producto ${productModel.nombre}?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RatingBar.builder(
                          unratedColor: Colors.grey.withOpacity(0.7),
                          glow: false,
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              calificacion = rating;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Solo podrás calificar el producto si los has comprado.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            // Expanded(
                            //     child: InkWell(
                            //   onTap: () => Navigator.pop(context),
                            //   child: Text(
                            //     'Cancelar',
                            //     textAlign: TextAlign.center,
                            //   ),
                            // )),
                            // SizedBox(
                            //   width: 15,
                            // ),
                            Expanded(
                              child: BotonRest(
                                  errorStyle: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  habilitado:
                                      calificacion == 0.0 ? false : true,
                                  primerAction: () {},
                                  url: '$apiUrl/calificar/producto',
                                  method: 'post',
                                  arrayData: {
                                    "id_de_producto": productModel.idDeProducto,
                                    "rating": calificacion
                                  },
                                  token: sharedPrefs.clientToken,
                                  action: (value) => Navigator.pop(context),
                                  showSuccess: true,
                                  contenido: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: smallPadding * 2),
                                    child: Text('Aceptar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  estilo: estiloBotonPrimary),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future _displayShareDialog(producto) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
                scrollable: true,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: smallPadding, vertical: smallPadding * 3),
                content: Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.height / 12,
                                child: productModel.galeria.length == 0
                                    ? Image.asset('images/logoDrug.png')
                                    : getNetworkImage(
                                        productModel.galeria[0]['url'],
                                      )),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                "Copia este link y comparte ${producto.nombre}.",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: bgGrey,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              Container(
                                child: Flexible(
                                  child: Text(
                                    '¡Ve ${producto.nombre} en Drug! https://app.drugsiteonline.com/detalles/producto/${producto.idDeProducto}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              BotonSimple(
                                  action: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "¡Ve ${producto.nombre} en Drug! https://app.drugsiteonline.com/detalles/producto/${producto.idDeProducto}"));
                                  },
                                  contenido: Text(
                                    'Copiar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  estilo: estiloBotonPrimary)
                            ],
                          ),
                        )
                      ],
                    )));
          });
        });
  }
}

/* Widget favoritos */

