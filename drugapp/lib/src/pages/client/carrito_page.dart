import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/model/producto_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/buttom_widget.dart';
import 'package:flutter/material.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';

class CarritoPage extends StatefulWidget {
  CarritoPage({Key key}) : super(key: key);

  @override
  _CarritoPageState createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  CatalogBloc _catalogBloc = CatalogBloc();

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    var jsonMenu = jsonDecode(itemsMenu.toString());
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
        title: "Carrito");
  }

  bodyCuenta() {
    var size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width > 700 ? size.width / 3 : medPadding * .5,
            vertical: medPadding * 1.5),
        color: bgGrey,
        width: size.width,
        child: StreamBuilder<List<ProductoModel>>(
            initialData: [],
            stream: _catalogBloc.catalogStream,
            builder: (context, snapshot) {
              return snapshot.data.length == 0
                  ? noCarrito()
                  : detallesCarrito(snapshot.data);
            }),
        // child:  detallesCarrito(),
      ),
      footer(context),
    ]);
  }

  noCarrito() {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.medical_services_outlined,
            //   color: Colors.grey.withOpacity(0.7),
            //   size: 50,
            // ),
            // SizedBox(
            //   height: smallPadding,
            // ),
            Text(
              'No tienes productos en tu carrito',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            SizedBox(
              height: smallPadding * 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
              child: SimpleButtom(
                mainText: 'Ver productos',
                gcolor: gradientBlueDark,
                pressed: () => Navigator.pushNamed(context, '/home'),
              ),
            )
          ]),
    );
  }

  detallesCarrito(data) {
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
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(total())),
        // SizedBox(
        //   height: smallPadding * 4,
        // ),
        // Text(
        //   'Detalles de pago',
        //   style: TextStyle(
        //       color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        // ),
        // SizedBox(
        //   height: smallPadding,
        // ),
        // Container(child: misDetalles(misProductos(data))),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Detalles de envio',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(entrega())),
        SizedBox(
          height: smallPadding * 4,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
          child: BotonRest(
              contenido: Text(
                'Comprar ahora',
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // action: () => Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => LoginPage())),
              errorStyle: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
              estilo: estiloBotonPrimary),
        ),
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

  total() {
    return Column(
      children: [
        SizedBox(
          height: smallPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TOTAL',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 17),
            ),
            Text(
              '\$106.02 MXN',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 17),
            )
          ],
        )
      ],
    );
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
    // return StreamBuilder<List<ProductoModel>>(
    // initialData: [],
    // stream: _catalogBloc.catalogStream,
    // builder: (context, snapshot) {
    //   return ListView.builder(
    //     itemCount: snapshot.data.length,
    //     shrinkWrap: true,
    //     physics: NeverScrollableScrollPhysics(),
    //     itemBuilder: (BuildContext context, int index) {
    //       return productList(snapshot.data[index]);
    //     },
    //   );
    // });
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
            // Flexible(
            //   flex: 2,
            //   child: getAsset(prodjson., 60),
            // ),
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
                    Text('${prodjson.farmaciaId.toString()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 12)),
                    SizedBox(height: smallPadding / 2),
                    Text(
                      '\$${prodjson.precio} MXN ',
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
