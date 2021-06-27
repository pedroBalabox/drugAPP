import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
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

  double calificacion;

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    sharedPrefs.init().then((value) => getProdcut());
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
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp);
        setState(() {
          prod = dataResp;
          productModel = ProductoModel.fromJson(dataResp[1][0]);
          fav = productModel.favorito;
          load = false;
          if (productModel.rating != null) {
            calificacion = double.parse(
                double.parse(productModel.rating).toStringAsFixed(1));
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

  @override
  void dispose() {
    _catalogBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: load ? '' : "${productModel.nombre}");
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
      footer(context),
    ]);
  }

  listProdcut(snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(child: misDetalles(context, product(snapshot))),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, descProducto())),
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
                  ))
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
                      text: ' a parir de ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' ${productModel.cantidadMayoreo} productos',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),

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
                        ProductView.routeName,
                        arguments: ProductoDetallesArguments({
                          "farmacia_id": productModel.farmaciaId,
                          "priceFilter": null,
                          "inStock": true,
                          "favorite": false
                        }),
                      ).then((value) => setState(() {}));
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
                  onTap: () => addFav(),
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

  addFav() async {
    var arrayData = {"id_de_producto": widget.productID.toString()};

    String url = fav ? '$apiUrl/desmarcar/favorito' : '$apiUrl/marcar/favorito';

    await restFun
        .restService(arrayData, url, sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        setState(() {
          fav = !fav;
        });
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
              child: Image.network(productModel.galeria[index]['url'],
                  fit: BoxFit.contain),
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
                            // Expanded(
                            //     child: !loadReview
                            //         ? ButtonLoad()
                            //         : ButtonPrimary(
                            //             mainText: jsonPartner[1]
                            //                             ['informacion_publica']
                            //                         ['mi_puntuacion'] ==
                            //                     null
                            //                 ? 'Confirmar'
                            //                 : 'Editar',
                            //             pressed: () {
                            //               if (_formKey.currentState
                            //                   .validate()) {
                            //                 _formKey.currentState.save();
                            //                 setState(() {
                            //                   reviewModel.vendedor_id =
                            //                       widget.partnerId;
                            //                 });
                            //                 jsonPartner[1]['informacion_publica']
                            //                             ['mi_puntuacion'] ==
                            //                         null
                            //                     ? postReviewService()
                            //                     : editReviewService(jsonPartner[
                            //                                     1][
                            //                                 'informacion_publica']
                            //                             ['mi_puntuacion']
                            //                         ['puntuacion_id']);
                            //                 print(reviewModel);
                            //               }
                            //             })),
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
                                    '¡Ve ${producto.nombre} en Drug! www.app.drugsiteonline.com/farmacia/${producto.nombre}/productos',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              BotonSimple(
                                  action: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "¡Ve ${producto.nombre} en Drug! www.app.drugsiteonline.com/farmacia/${producto.nombre}/productos"));
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
