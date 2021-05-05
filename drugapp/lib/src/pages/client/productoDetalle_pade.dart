import 'dart:convert';

import 'package:drugapp/model/producto_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ProductoDetalles extends StatefulWidget {
  static const routeName = '/detallesProdcuto';

  final dynamic jsonProdcuto;

  ProductoDetalles({Key key, this.jsonProdcuto}) : super(key: key);

  @override
  _ProductoDetallesState createState() => _ProductoDetallesState();
}

class _ProductoDetallesState extends State<ProductoDetalles> {
  var prod = [];
  CatalogBloc _catalogBloc = CatalogBloc();
  var tiendas = [];
  ProductModel productModel = ProductModel();

  @override
  void initState() {
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    prod = jsonDecode(dummyProd);
    productModel = ProductModel.fromJson(widget.jsonProdcuto.jsonProducto);
    tiendas = jsonDecode(dummyTienda);
    super.initState();
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
        body: bodyProdcuto(),
        title: "${widget.jsonProdcuto.jsonProducto['name']}");
  }

  // GestureRecognizer _pressFarmacia(){
  // Navigator.pushNamed(
  //     context,
  //     TiendaProductos.routeName,
  //     arguments: TiendaDetallesArguments(widget.jsonProdcuto.jsonProducto['tienda']),
  //   ).then((value) => setState(() {}));
  // }

  bodyProdcuto() {
    var size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width > 700 ? size.width / 5 : medPadding * .5,
            vertical: size.width > 700 ? medPadding * 1.5 : medPadding * 0.5),
        color: bgGrey,
        width: size.width,
        child: listProdcut(),
      ),
      footer(context),
    ]);
  }

  listProdcut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(child: misDetalles(context, product())),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, descProducto())),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, labels())),
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

  product() {
    return MediaQuery.of(context).size.width < 700
        ? Container(
            // height: MediaQuery.of(context).size.height/2,
            child: Column(
              children: [
                productTitle(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.7,
                  child: productSwiper(),
                ),
                StreamBuilder<List<ProductModel>>(
                    initialData: [],
                    stream: _catalogBloc.catalogStream,
                    builder: (context, snapshot) {
                      var index;
                      bool inCart = false;
                      for (int i = 0; i <= snapshot.data.length - 1; i++) {
                        if (snapshot.data[i].name ==
                            widget.jsonProdcuto.jsonProducto['name']) {
                          index = i;
                          inCart = true;
                        }
                      }
                      return Row(
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
                                      if (snapshot.data[index].cantidad > 1) {
                                        productModel.cantidad =
                                            snapshot.data[index].cantidad - 1;
                                        _catalogBloc.sendEvent.add(
                                            EditCatalogItemEvent(productModel));
                                      } else {
                                        productModel.cantidad =
                                            snapshot.data[index].cantidad;
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
                                      ? snapshot.data[index].cantidad.toString()
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
                                            snapshot.data[index].cantidad + 1
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
                        ],
                      );
                    }),
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
                        StreamBuilder<List<ProductModel>>(
                            initialData: [],
                            stream: _catalogBloc.catalogStream,
                            builder: (context, snapshot) {
                              var index;
                              bool inCart = false;
                              for (int i = 0;
                                  i <= snapshot.data.length - 1;
                                  i++) {
                                if (snapshot.data[i].name ==
                                    widget.jsonProdcuto.jsonProducto['name']) {
                                  index = i;
                                  inCart = true;
                                }
                              }
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              if (snapshot
                                                      .data[index].cantidad >
                                                  1) {
                                                productModel.cantidad = snapshot
                                                        .data[index].cantidad -
                                                    1;
                                                _catalogBloc.sendEvent.add(
                                                    EditCatalogItemEvent(
                                                        productModel));
                                              } else {
                                                productModel.cantidad = snapshot
                                                    .data[index].cantidad;
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
                                              ? snapshot.data[index].cantidad
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
                                                    snapshot.data[index]
                                                            .cantidad +
                                                        1
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
                                ],
                              );
                            }),
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
        Text(
          '\$350.00',
          style: TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: Colors.black45),
        ),
        Text(
          '\$ 225.95',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.blue),
        ),
        Text(
          'IVA incluido',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black),
        ),
        RichText(
          text: TextSpan(
            text: 'Precio mayoreo ',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                  text: '\$350.00',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  )),
              TextSpan(
                text: ' a parir de 15 prodcutos',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: smallPadding),
          child: labelCat(),
        ),
        Row(
          children: [
            Icon(
              Icons.medical_services_outlined,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: smallPadding / 2),
            Flexible(
              child: Text(
                'Este producto requiere receta médica',
                style: TextStyle(color: Theme.of(context).primaryColor),
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
        )
      ],
    );
  }

  productTitle() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: '${widget.jsonProdcuto.jsonProducto['name']}  ',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
            children: <TextSpan>[
              TextSpan(
                  text: '${widget.jsonProdcuto.jsonProducto['farmacia']}',
                  // recognizer: _pressFarmacia(),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(
                        context,
                        TiendaProductos.routeName,
                        arguments: TiendaDetallesArguments(tiendas[0]),
                      ).then((value) => setState(() {}));
                    },
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        // SizedBox(height: smallPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  RatingBarIndicator(
                    unratedColor: Colors.grey.withOpacity(0.2),
                    rating:
                        double.parse(widget.jsonProdcuto.jsonProducto['stars']),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(width: smallPadding / 2),
                  Text('${widget.jsonProdcuto.jsonProducto['stars']}')
                ],
              ),
            ),
            Row(
              children: [
                Container(
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
                    Icons.favorite_rounded,
                    color: Colors.pink[300],
                    size: 25,
                  ),
                ),
                SizedBox(width: smallPadding * 1.5),
                Container(
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
              ],
            )
          ],
        ),
      ],
    );
  }

  labelCat() {
    return Wrap(
      children: [
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(smallPadding / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            child: Text(
              'Categoría',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )),
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(smallPadding / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            child: Text(
              'SubCategoría',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )),
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(smallPadding / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            child: Text(
              'SubCategoría',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )),
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(smallPadding / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            child: Text(
              'SubCategoría',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ))
      ],
    );
  }

  labels() {
    return Wrap(
      // clipBehavior: Clip.hardEdge,
      // spacing: smallPadding / 2,
      children: [
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(smallPadding / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            child: Text(
              'Etiqueta',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )),
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(smallPadding / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            child: Text(
              'Etiqueta',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )),
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(smallPadding / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            child: Text(
              'Etiqueta',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )),
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(smallPadding / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            child: Text(
              'Etiqueta',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )),
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(smallPadding / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            child: Text(
              'Etiqueta',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ))
      ],
    );
  }

  productSwiper() {
    return Swiper(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Image.asset("images/${widget.jsonProdcuto.jsonProducto['img']}",
            fit: BoxFit.contain),
      ),
      autoplay: false,
      autoplayDelay: 5000,
      scrollDirection: Axis.horizontal,
      pagination: new SwiperPagination(
          builder: new DotSwiperPaginationBuilder(
              color: Colors.white.withOpacity(0.5),
              activeColor: Theme.of(context).primaryColor),
          margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
          'INDICACIONES TERAPÉUTICAS: Antihistamínico. Está indicado para el rápido alivio de los síntomas asociados con la rinitis alérgica y otras afecciones alérgicas, incluyendo estornudos, rinorrea, congestión y prurito nasal, así como prurito, lagrimeo y enrojecimiento de los ojos, prurito del paladar y tos. También está indicado para el alivio de los síntomas y signos de la urticaria aguda y crónica y de otras afecciones dermatológicas alérgicas.',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w300, fontSize: 17),
        ),
      ],
    );
  }
}
