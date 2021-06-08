import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/client/payments/paymentDropDown.dart';
import 'package:drugapp/src/pages/client/payments/paymentFunctions.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/buttom_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';

class CarritoPage extends StatefulWidget {
  CarritoPage({Key key}) : super(key: key);

  @override
  _CarritoPageState createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  CatalogBloc _catalogBloc = CatalogBloc();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String receta_medica;
  String calle;
  String colonia;
  String numero_exterior;
  String numero_interior;
  String codigo_postal;
  String referencias;
  String telefono_contacto;
  String comentarios;
  String card_id = 'kfipluyqmroronvvllsj';
  String device_session_id = 'kfipluyqmroronvvllsj';

  List productos = [];

  var docBase64;
  var docName;

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
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misDetalles(total(data))),
        !receta
            ? Container()
            : SizedBox(
                height: smallPadding * 4,
              ),
        !receta
            ? Container()
            : Text(
                'Receta médica',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
        !receta
            ? Container()
            : SizedBox(
                height: smallPadding,
              ),
        !receta ? Container() : Container(child: misDetalles(miReceta())),
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
        Container(child: misDetalles(formDirection())),
        SizedBox(
          height: smallPadding * 4,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
          child: BotonRestTest(
              primerAction: () {
                setState(() {
                  productos = [];
                });
                for (int i = 0; i < data.length; i++) {
                  // productos.add(ProductosOrden(
                  //     id_de_producto: data[i].idDeProducto,
                  //     cantidad: data[i].cantidad));
                  productos.add({
                    "id_de_producto": data[i].idDeProducto,
                    "cantidad": data[i].cantidad
                  });
                }
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                }
                ;
              },
              arrayData: {
                "receta_medica": docBase64,
                "calle": calle,
                "colonia": colonia,
                "numero_exterior": numero_exterior,
                "numero_interior": numero_interior,
                "codigo_postal": codigo_postal,
                "referencias": referencias,
                "telefono_contacto": telefono_contacto,
                "comentarios": comentarios,
                "card_id": 'klun7krv2gpqxzz1t6qz',
                "device_session_id": "device_session_id",
                "productos": productos,
              },
              showSuccess: true,
              url: '$apiUrl/crear/orden',
              method: 'post',
              formkey: formKey,
              token: sharedPrefs.clientToken,
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
              action: (value) {},
              errorStyle: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
              estilo: estiloBotonPrimary),
        ),
        misTarjetas(context)
      ],
    );
  }

  miReceta() {
    return Column(
      children: [
        BotonSimple(
            action: () => subirDoc(),
            estilo: estiloBotonSecundary,
            contenido: Text(
              'Subir receta',
              style: TextStyle(color: Colors.white),
            )),
        docName == null ? Container() : docCargado(docName)
      ],
    );
  }

  Widget docCargado(nombreDoc) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 15,
            color: Colors.green.withOpacity(0.8),
          ),
          SizedBox(
            width: 3,
          ),
          Flexible(
            child: Text(
              nombreDoc,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          // SizedBox(
          //   width: 5,
          // ),
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       docName = null;
          //       docBase64 = null;
          //     });
          //   },
          //   child: Container(
          //       padding: EdgeInsets.all(3),
          //       decoration: BoxDecoration(
          //           color: Colors.grey.withOpacity(0.7),
          //           borderRadius: BorderRadius.circular(100)),
          //       child: Icon(
          //         Icons.close,
          //         color: Colors.white,
          //         size: 10,
          //       )),
          // )
        ],
      ),
    );
  }

  subirDoc() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      // var mimType = lookupMimeType(result.files.first.name, headerBytes: result.files.first.bytes);
      // var uri = Uri.dataFromBytes(result.files.first.bytes, mimeType: mimType).toString();

      var uri = Uri.dataFromBytes(result.files.first.bytes).toString();
      setState(() {
        docName = result.files.single.name;
        docBase64 = uri;
      });
    }
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

  formDirection() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.location_on_outlined, 'Calle', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'generic',
            onChanged: (value) {
              setState(() {
                calle = value;
              });
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.location_on_outlined, 'Colonia', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'generic',
            onChanged: (value) {
              setState(() {
                colonia = value;
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: EntradaTexto(
                  estilo: inputPrimarystyle(
                      context, Icons.location_on_outlined, 'Núm Ext.', null),
                  tipoEntrada: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  tipo: 'generic',
                  onChanged: (value) {
                    setState(() {
                      numero_exterior = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: EntradaTexto(
                  estilo: inputPrimarystyle(
                      context, Icons.location_on_outlined, 'Núm Int.', null),
                  tipoEntrada: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  tipo: 'opcional',
                  onChanged: (value) {
                    setState(() {
                      numero_interior = value;
                    });
                  },
                ),
              ),
            ],
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.location_on_outlined, 'Código postal', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'generic',
            onChanged: (value) {
              setState(() {
                codigo_postal = value;
              });
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.location_on_outlined, 'Referencias', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'opcional',
            onChanged: (value) {
              setState(() {
                referencias = value;
              });
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.phone_outlined, 'Teléfono de Contacto', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'generic',
            onChanged: (value) {
              setState(() {
                telefono_contacto = value;
              });
            },
          ),
          EntradaTexto(
            lineasMax: 2,
            estilo: inputPrimarystyle(
                context, Icons.location_on_outlined, 'Cometarios', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'opcional',
            onChanged: (value) {
              setState(() {
                comentarios = value;
              });
            },
          ),
        ],
      ),
    );
  }

  total(data) {
    double totalPrice = 0.0;
    double sum = 0;
    List price = [];

    for (int i = 0; i < data.length; i++) {
      if (data[i].precioMayoreo != null &&
          double.parse(data[i].cantidad.toString()) >=
              double.parse(data[i].cantidadMayoreo)) {
        double total;
        total = double.parse(data[i].precioMayoreo) * data[i].cantidad;
        price.add(total);
      } else if (data[i].precioConDescuento != null) {
        double total;
        total = double.parse(data[i].precioConDescuento) * data[i].cantidad;
        price.add(total);
      } else {
        double total;
        total = double.parse(data[i].precio) * data[i].cantidad;
        price.add(total);
      }
    }

    for (num e in price) {
      sum += e;
    }
    totalPrice = sum;

    return Column(
      children: [
        SizedBox(
          height: smallPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Costo de envío',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 17),
            ),
            Text(
              '\$250 MXN',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 17),
            )
          ],
        ),
        SizedBox(height: smallPadding / 2),
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
              totalPrice >= 2500
                  ? '\$$totalPrice MXN'
                  : '\$${totalPrice + 250} MXN',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 17),
            )
          ],
        ),
        SizedBox(height: smallPadding / 2),
        Text(
          'Envio gratis a partir de compras de \$2,500.00',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
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
                    Text('${prodjson.nombre_farmacia.toString()}',
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

  misTarjetas(context) {
    var myCards;
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
        child: Column(
          children: [
            PaymentDropDown(key: ValueKey<Object>(myCards), module: "cards"),
          ],
        ));
  }
}
