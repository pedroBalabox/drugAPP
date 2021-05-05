import 'dart:convert';

import 'package:drugapp/model/producto_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:flutter/material.dart';

class ContadorProducto extends StatefulWidget {
  final dynamic prodStream;
  final dynamic producto;

  ContadorProducto({Key key, this.prodStream, @required this.producto})
      : super(key: key);

  @override
  _ContadorProductoState createState() => _ContadorProductoState();
}

class _ContadorProductoState extends State<ContadorProducto> {
  CatalogBloc _catalogBloc = CatalogBloc();

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    // productModel = ProductModel.fromJson(jsonDecode(widget.producto));
  }

  @override
  void dispose() {
    _catalogBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Material(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(40),
          child: new InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(40),
            child: new Container(
              width: 20,
              height: 20,
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
        Container(
          height: 20,
          width: 20,
          // padding: EdgeInsets.symmetric(
          //     vertical: 0.3, horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: Colors.grey[200]),
          alignment: Alignment.center,
          child: Text(
              widget.prodStream == null
                  ? '0'
                  : widget.prodStream.cantidad.toString(),
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.w700)),
        ),
        Material(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(40),
          child: InkWell(
            onTap: () {
              setState(() {
                widget.producto.cantidad = 1;
                _catalogBloc.sendEvent
                    .add(EditCatalogItemEvent(widget.producto));
              });
            },
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 20,
              height: 20,
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
      ],
    );
  }
}
