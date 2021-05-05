import 'dart:convert';

import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class DetallesCompra extends StatefulWidget {
  static const routeName = '/detallesCompra';

  final dynamic jsonCompra;

  DetallesCompra({this.jsonCompra});

  @override
  _DetallesCompraState createState() => _DetallesCompraState();
}

class _DetallesCompraState extends State<DetallesCompra> {
  var prod = [];
  Widget statusWidget;

  @override
  void initState() {
    prod = jsonDecode(dummyProd);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.jsonCompra.jsonCompra['status']) {
      case 'preparacion':
        statusWidget = tabProceso();
        break;
      case 'camino':
        statusWidget = tabCamino();
        break;
      case 'entregado':
        statusWidget = tabEntregado();
        break;
      default:
    }
    return ResponsiveAppBar(
        screenWidht: MediaQuery.of(context).size.width,
        body: bodyCompra(),
        title:
            "Detalles de compra ${widget.jsonCompra.jsonCompra['idCompra']}");
  }

  bodyCompra() {
    var size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width > 700 ? size.width / 3 : medPadding * .5,
            vertical: medPadding * 1.5),
        color: bgGrey,
        width: size.width,
        child: statusWidget,
      ),
      footer(context),
    ]);
  }

  tabEntregado() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Compra ${widget.jsonCompra.jsonCompra['idCompra']} - ${widget.jsonCompra.jsonCompra['fecha']}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Text(
          'Resumen de compra',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, statusEntregado())),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, products())),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Detalles de pago',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, pago())),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Detalles de entrega',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, entrega())),
      ],
    );
  }

  tabCamino() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Compra ${widget.jsonCompra.jsonCompra['idCompra']} - ${widget.jsonCompra.jsonCompra['fecha']}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Text(
          'Resumen de compra',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, statusCamino())),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, products())),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Detalles de pago',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, pago())),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Detalles de entrega',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, entrega())),
      ],
    );
  }

  tabProceso() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Compra ${widget.jsonCompra.jsonCompra['idCompra']} - ${widget.jsonCompra.jsonCompra['fecha']}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Text(
          'Resumen de compra',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, statusPreparacion())),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, products())),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Detalles de pago',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, pago())),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Detalles de entrega',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(context, entrega())),
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

  statusPreparacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(right: smallPadding),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Flexible(
              flex: 7,
              child: Text(
                'En preparación, llega el ${widget.jsonCompra.jsonCompra['fechaTent']}',
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 9),
          height: 25,
          width: 2,
          color: Colors.grey.withOpacity(0.2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(right: smallPadding, left: 1.5),
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Flexible(
              flex: 7,
              child: Text(
                'En camino',
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 9),
          height: 25,
          width: 2,
          color: Colors.grey.withOpacity(0.2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(right: smallPadding, left: 1.5),
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Flexible(
                flex: 7,
                child: Text('Entrega',
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.7),
                    )))
          ],
        ),
      ],
    );
  }

  statusCamino() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(right: smallPadding, left: 1.5),
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Flexible(
              flex: 7,
              child: Text(
                'En preparación',
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 9),
          height: 25,
          width: 2,
          color: Colors.yellow[700],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(right: smallPadding),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Flexible(
              flex: 7,
              child: Text(
                'En camino, llega el ${widget.jsonCompra.jsonCompra['fechaTent']}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 9),
          height: 25,
          width: 2,
          color: Colors.grey.withOpacity(0.2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(right: smallPadding, left: 1.5),
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Flexible(
                flex: 7,
                child: Text('Entrega',
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.7),
                    )))
          ],
        ),
      ],
    );
  }

  statusEntregado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(right: smallPadding, left: 1.5),
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Flexible(
              flex: 7,
              child: Text(
                'En preparación',
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 9),
          height: 25,
          width: 2,
          color: Colors.green[700],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(right: smallPadding, left: 1.5),
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Flexible(
                flex: 7,
                child: Text('En camino',
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.7),
                    )))
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 9),
          height: 25,
          width: 2,
          color: Colors.green[700],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(right: smallPadding),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Flexible(
              flex: 7,
              child: Text(
                'Entregado el ${widget.jsonCompra.jsonCompra['fechaEntrga']}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ],
    );
  }

  products() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          itemCount: prod.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return productList(prod[index]);
          },
        ),
        // Divider(
        //   color: bgGrey,
        //   thickness: 2,
        // ),
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

  productList(prodjson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: smallPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: getAsset(prodjson['img'], 60),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: smallPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(prodjson['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    Text('${prodjson['farmacia']}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 12)),
                    // SizedBox(height: smallPadding * 2),
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '\$${prodjson['price']} MXN ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue),
                    ),
                    Text(
                      'x 2 unidades',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                    )
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

  pago() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style:
                TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
            children: <TextSpan>[
              new TextSpan(
                text: 'Folio: ',
              ),
              new TextSpan(
                  text: '123456',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
        Row(
          children: [
            Icon(Icons.payment_outlined, color: Theme.of(context).primaryColor),
            SizedBox(
              width: smallPadding,
            ),
            Text('**** **** 456'),
          ],
        )
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
        )
      ],
    );
  }
}
