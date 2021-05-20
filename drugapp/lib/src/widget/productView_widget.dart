import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/client/productoDetalle_pade.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';

class VistaProductos extends StatefulWidget {
  final ProductoModel productoModel;
  final dynamic carrito;

  VistaProductos({Key key, @required this.productoModel, this.carrito})
      : super(key: key);

  @override
  _VistaProductosState createState() => _VistaProductosState();
}

class _VistaProductosState extends State<VistaProductos> {
  @override
  Widget build(BuildContext context) {
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
                  // Image(
                  //   fit: BoxFit.contain,
                  //   image: AssetImage("images/${widget.productoModel['img']}"),
                  // ),
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
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Colors.pink[300],
                        size: 17,
                      ),
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
                  widget.productoModel,
                ),
              ).then((value) => setState(() {})),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.productoModel.nombre,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      widget.productoModel.nombre_farmacia,
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
                          '\$${widget.productoModel.precio}',
                          style: TextStyle(
                              color: Colors.black45,
                              decoration:
                                  widget.productoModel.precioConDescuento ==
                                          null
                                      ? null
                                      : TextDecoration.lineThrough),
                        ),
                        widget.productoModel.precioConDescuento == null
                            ? Container()
                            : Text(
                                '\$${widget.productoModel.precioConDescuento}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700),
                              ),
                      ],
                    ),
                    StreamBuilder<List<ProductoModel>>(
                        initialData: [],
                        stream: widget.carrito.catalogStream,
                        builder: (context, snapshot) {
                          var index;
                          bool inCart = false;
                          for (int i = 0; i <= snapshot.data.length - 1; i++) {
                            if (snapshot.data[i].idDeProducto ==
                                widget.productoModel.idDeProducto) {
                              index = i;
                              inCart = true;
                            }
                          }
                          return Row(
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
                                          if (snapshot.data[index].cantidad >
                                              1) {
                                            widget.productoModel.cantidad =
                                                snapshot.data[index].cantidad -
                                                    1;
                                            widget.carrito.sendEvent.add(
                                                EditCatalogItemEvent(
                                                    widget.productoModel));
                                          } else {
                                            widget.productoModel.cantidad =
                                                snapshot.data[index].cantidad;
                                            widget.carrito.sendEvent.add(
                                                RemoveCatalogItemEvent(
                                                    widget.productoModel));
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
                                          ? snapshot.data[index].cantidad
                                              .toString()
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
                                            ? widget.productoModel.cantidad =
                                                snapshot.data[index].cantidad +
                                                    1
                                            : widget.productoModel.cantidad = 1;
                                        widget.carrito.endEvent.add(
                                            EditCatalogItemEvent(
                                                widget.productoModel));
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
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
