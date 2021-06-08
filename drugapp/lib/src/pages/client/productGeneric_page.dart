import 'dart:convert';

import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/client/productoDetalle_pade.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/buttom_widget.dart';
import 'package:flutter/material.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';

class Categorie {
  final String name;

  Categorie({
    this.name,
  });
}

class ProductoViewPage extends StatefulWidget {
  final dynamic arrayData;
  final bool farmacia;

  ProductoViewPage({Key key, this.arrayData = null, this.farmacia = false})
      : super(key: key);

  @override
  _ProductoViewPageState createState() => _ProductoViewPageState();
}

class _ProductoViewPageState extends State<ProductoViewPage> {
  CatalogBloc _catalogBloc = CatalogBloc();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProductoModel productoModel = ProductoModel();

  RestFun rest = RestFun();

  var prod;

  var farmacia;

  String errorStr;
  bool load = true;
  bool error = false;

  List searchList = [];
  bool _isSearching = false;

  static List<Categorie> _cat = [
    Categorie(name: "Antibióticos"),
    Categorie(name: "Dermatología"),
    Categorie(name: "Pediatría"),
    Categorie(name: "Vacunas"),
    Categorie(name: "Cirugía estética"),
    Categorie(name: "Ginecología"),
    Categorie(name: "Material de curación"),
    Categorie(name: "Ropa médica"),
    Categorie(name: "Baja de peso"),
    Categorie(name: "Hospitalización"),
  ];

  List productos = [];

  var docBase64;
  var docName;

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    var jsonMenu = jsonDecode(itemsMenu.toString());
    sharedPrefs.init().then((value) => getProducts());
  }

  getProducts() async {
    await rest
        .restService(widget.arrayData, '$apiUrl/listar/producto',
            sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp)[1]['results'];
        setState(() {
          prod = dataResp;
          // orden = dataResp.values.toList();
          load = false;
        });
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
        body: bodyCuenta(),
        title: "Productos");
  }

  bodyCuenta() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<List<ProductoModel>>(
        initialData: [],
        stream: _catalogBloc.catalogStream,
        builder: (context, snapshot) {
          return listProducts(snapshot.data);
        });
  }

  listProducts(snapshot) {
    return load
        ? bodyLoad(context)
        : error
            ? errorWidget(errorStr, context)
            : ListView(
                children: [
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(smallPadding),
                    children: [
                      Container(
                          child: GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: (250 / 350),
                        primary: false,
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: MediaQuery.of(context).size.width < 1150
                            ? MediaQuery.of(context).size.width < 700
                                ? 2
                                : 4
                            : 5,
                        // Generate 100 widgets that display their index in the List.
                        children: List.generate(
                            _isSearching ? searchList.length : prod.length,
                            (index) {
                          return productFav(
                              true,
                              _isSearching ? searchList[index] : prod[index],
                              snapshot);
                        }),
                      ))
                    ],
                  ),
                  footer(context)
                ],
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
    // if (productoModel.favorito == false) {
    //   favProduct = false;
    // } else {
    //   favProduct = true;
    // }
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
                          image: NetworkImage(productoModel.galeria[0]['url']),
                        ),
                  Align(
                    alignment: Alignment.topRight,
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
                      // child: Icon(
                      //   favProduct
                      //       ? Icons.favorite_rounded
                      //       : Icons.favorite_outline,
                      //   color: Colors.pink[300],
                      //   size: 17,
                      // ),
                    ),
                  ),
                ],
              )),
          Flexible(
            flex: 3,
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                ProductoDetalles.routeName,
                arguments: ProductoDetallesArguments(
                  productoModel.idDeProducto,
                ),
              ).then((value) => setState(() {})),
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
                    Row(
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
                                          EditCatalogItemEvent(productoModel));
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
                                  _catalogBloc.sendEvent
                                      .add(EditCatalogItemEvent(productoModel));
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
                    // StreamBuilder<List<ProductoModel>>(
                    //     initialData: [],
                    //     stream: _catalogBloc.catalogStream,
                    //     builder: (context, snapshot) {
                    //       var index;
                    //       bool inCart = false;
                    //       for (int i = 0; i <= snapshot.data.length - 1; i++) {
                    //         if (snapshot.data[i].idDeProducto ==
                    //             productoModel.idDeProducto) {
                    //           index = i;
                    //           inCart = true;
                    //         }
                    //       }
                    //       return Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: <Widget>[
                    //           Flexible(flex: 1, child: Container()),
                    //           Flexible(
                    //             flex: 2,
                    //             child: Material(
                    //               color: Colors.blueGrey,
                    //               borderRadius: BorderRadius.circular(40),
                    //               child: new InkWell(
                    //                 onTap: () {
                    //                   setState(() {
                    //                     if (inCart) {
                    //                       if (snapshot.data[index].cantidad >
                    //                           1) {
                    //                         productoModel.cantidad =
                    //                             snapshot.data[index].cantidad -
                    //                                 1;
                    //                         _catalogBloc.sendEvent.add(
                    //                             EditCatalogItemEvent(
                    //                                 productoModel));
                    //                       } else {
                    //                         productoModel.cantidad =
                    //                             snapshot.data[index].cantidad;
                    //                         _catalogBloc.sendEvent.add(
                    //                             RemoveCatalogItemEvent(
                    //                                 productoModel));
                    //                       }
                    //                     }
                    //                   });
                    //                 },
                    //                 borderRadius: BorderRadius.circular(40),
                    //                 child: new Container(
                    //                   width: 22,
                    //                   height: 22,
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(40),
                    //                   ),
                    //                   child: Icon(
                    //                     Icons.remove,
                    //                     color: Colors.white,
                    //                     size: 10,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           Flexible(
                    //             flex: 3,
                    //             child: Container(
                    //               height: 30,
                    //               width: 30,
                    //               // padding: EdgeInsets.symmetric(
                    //               //     vertical: 0.3, horizontal: 15),
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(40),
                    //                   color: bgGrey),
                    //               alignment: Alignment.center,
                    //               child: Text(
                    //                   inCart
                    //                       ? snapshot.data[index].cantidad
                    //                           .toString()
                    //                       : '0',
                    //                   style: TextStyle(
                    //                       fontSize: 12,
                    //                       color: Theme.of(context).primaryColor,
                    //                       fontWeight: FontWeight.w700)),
                    //             ),
                    //           ),
                    //           Flexible(
                    //             flex: 2,
                    //             child: Material(
                    //               color: Colors.blueGrey,
                    //               borderRadius: BorderRadius.circular(40),
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   setState(() {
                    //                     inCart
                    //                         ? productoModel.cantidad =
                    //                             snapshot.data[index].cantidad +
                    //                                 1
                    //                         : productoModel.cantidad = 1;
                    //                     _catalogBloc.sendEvent.add(
                    //                         EditCatalogItemEvent(
                    //                             productoModel));
                    //                   });
                    //                 },
                    //                 borderRadius: BorderRadius.circular(40),
                    //                 child: Container(
                    //                   width: 22,
                    //                   height: 22,
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(40),
                    //                   ),
                    //                   child: Icon(
                    //                     Icons.add,
                    //                     color: Colors.white,
                    //                     size: 10,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           Flexible(flex: 1, child: Container()),
                    //         ],
                    //       );
                    //     }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  detallesCarrito(data) {
    productos = [];
    for (int i = 0; i < data.length; i++) {
      // productos.add(ProductosOrden(
      //     id_de_producto: data[i].idDeProducto,
      //     cantidad: data[i].cantidad));
      productos.add({
        "id_de_producto": data[i].idDeProducto,
        "cantidad": data[i].cantidad
      });
    }
    bool receta = false;

    for (int i = 0; i < data.length; i++) {
      // productos.add(ProductosOrden(
      //     id_de_producto: data[i].idDeProducto,
      //     cantidad: data[i].cantidad));
      if (data[i].requiereReceta == 'SI') {
        receta = true;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Mis productos',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(misProductos(data))),
      ],
    );
  }

  misDetalles(Widget contenido) {
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

  misProductos(data) {
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return productList(data[index]);
      },
    );
  }

  productList(ProductoModel prodjson) {
    // ProductoModel productModel = ProductoModel.fromJson(jsonDecode(prodjson));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
              onTap: () {
                setState(() {
                  _catalogBloc.sendEvent.add(RemoveCatalogItemEvent(prodjson));
                });
              },
              child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 13,
                  ))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: prodjson.galeria.length == 0
                  ? getAsset('logoDrug.png', 60)
                  : Image.network(prodjson.galeria[0]['url']),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: smallPadding),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CgrossAxisAlignment.start,
                  children: [
                    Text(prodjson.nombre.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    // SizedBox(height: smallPadding / 2),
                    // SizedBox(height: smallPadding / 2),
                    Text('${prodjson.marca.toString()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 12)),
                    SizedBox(height: smallPadding / 2),
                    Text(
                      prodjson.precioMayoreo == null
                          ? prodjson.precioConDescuento == null
                              ? '\$${prodjson.precio} '
                              : '\$${prodjson.precioConDescuento}'
                          : prodjson.cantidad >=
                                  int.parse(prodjson.cantidadMayoreo)
                              ? '\$${prodjson.precioMayoreo}'
                              : prodjson.precioConDescuento == null
                                  ? '\$${prodjson.precio} '
                                  : '\$${prodjson.precioConDescuento}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Flexible(flex: 1, child: Container()),
                        Flexible(
                          flex: 2,
                          child: Material(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(40),
                            child: new InkWell(
                              onTap: () {
                                setState(() {
                                  if (prodjson.cantidad > 1) {
                                    prodjson.cantidad = prodjson.cantidad - 1;
                                    _catalogBloc.sendEvent
                                        .add(EditCatalogItemEvent(prodjson));
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
                            child: Text(prodjson.cantidad.toString(),
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
                                  prodjson.cantidad++;
                                  _catalogBloc.sendEvent
                                      .add(EditCatalogItemEvent(prodjson));
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
                        // Flexible(flex: 1, child: Container()),
                      ],
                    ),
                  ],
                )),
          ],
        ),
        Divider(
          color: bgGrey,
          thickness: 2,
        ),
      ],
    );
  }

  entrega() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.location_on_outlined,
                color: Theme.of(context).primaryColor),
            SizedBox(
              width: smallPadding,
            ),
            Flexible(
              child: Text(
                'Pedro de Alvarado, Nº exterior: 701, Nº interior: Referencia: Estética Entre: Julia y Nueva Alemania Lomas de Cortes, Cuernavaca (62240), Morelos',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(
          height: smallPadding,
        ),
        Row(
          children: [
            Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
            SizedBox(
              width: smallPadding,
            ),
            Flexible(
              child: Text(
                'Andrea Sandoval Gomez Farias',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(
          height: smallPadding * 2,
        ),
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Flexible(
              flex: 2,
              child: SimpleButtom(
                mainText: 'Editar',
                gcolor: gradientBlueLight,
              ),
            )
          ],
        )
      ],
    );
  }
}
