import 'dart:convert';

import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class DetallesCompra extends StatefulWidget {
  static const routeName = '/detallesCompra';

  final dynamic jsonCompra;

  final String idCompra;

  DetallesCompra({this.jsonCompra, this.idCompra});

  @override
  _DetallesCompraState createState() => _DetallesCompraState();
}

class _DetallesCompraState extends State<DetallesCompra> {
  var prod;
  Widget statusWidget;

  RestFun restFun = RestFun();

  String errorStr;
  bool load = true;
  bool error = false;
  var orden;

  @override
  void initState() {
    sharedPrefs.init().then((value) => gerCompras());
    super.initState();
  }

  getPrducts() {
    setState(() {
      prod = orden['relaciones'];
      load = false;
    });
    //print(prod);
  }

  gerCompras() async {
    var arrayData = {"id_de_orden": widget.idCompra.toString()};

    await restFun
        .restService(
            arrayData, '$apiUrl/ver/orden', sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp)[1];
        setState(() {
          orden = dataResp['details'];
        });
        //print('----' + orden.toString());
        getPrducts();
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
  Widget build(BuildContext context) {
    if (orden != null) {
      switch (orden['estatus_de_envio']) {
        case 'preparing':
          statusWidget = tabProceso();
          break;
        case 'on_the_way':
          statusWidget = tabCamino();
          break;
        case 'delivered':
          statusWidget = tabEntregado();
          break;
        default:
          statusWidget = tabProceso();
          break;
      }
    }
    return ResponsiveAppBar(
        screenWidht: MediaQuery.of(context).size.width,
        body: load
            ? bodyLoad(context)
            : error
                ? errorWidget(errorStr, context)
                : bodyCompra(),
        title: "Detalles de compra");
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
      // footer(context),
    ]);
  }

  tabEntregado() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Compra ${orden['id_de_orden']} - ${orden['fecha_de_creacion']}',
          textAlign: TextAlign.center,
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
          'Compra ${orden['id_de_orden']} - ${orden['fecha_de_creacion']}',
          textAlign: TextAlign.center,
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
          'Compra ${orden['id_de_orden']} - ${orden['fecha_de_creacion']}',
          textAlign: TextAlign.center,
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
                'En preparación',
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
                'En camino',
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
                'Entregado',
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
              '\$${orden['monto_total']} MXN',
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
              child: prodjson['galeria'].length == 0
                  ? getAsset('images/productPH.jpeg', 60)
                  : getNetworkImage(prodjson['galeria'][0]['url']),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: smallPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(prodjson['nombre'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    Text('${prodjson['marca']}',
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
                      '\$${prodjson['costo_unitario']} MXN ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue),
                    ),
                    Text(
                      'x ${prodjson['cantidad']} unidades',
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
    var jsonLogs = jsonDecode(orden['detalles_cargo']);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
                  text: '${jsonLogs['id']}',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.payment_outlined, color: Theme.of(context).primaryColor),
            SizedBox(
              width: smallPadding,
            ),
            Text('${jsonLogs['card']['card_number']}'),
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
                '${orden['colonia']}, ${orden['colonia']}, ${orden['numero_exterior']}, ${orden['numero_interior']}, ${orden['codigo_postal']}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        // SizedBox(
        //   height: smallPadding,
        // ),
        // Row(
        //   children: [
        //     Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
        //     SizedBox(
        //       width: smallPadding,
        //     ),
        //     // Flexible(
        //     //   child: Text(
        //     //     '${orden['cliente']}',
        //     //     style: TextStyle(color: Colors.black),
        //     //   ),
        //     // ),
        //   ],
        // )
      ],
    );
  }
}
