import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawerVendedor_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CargarProductos extends StatefulWidget {
  CargarProductos({Key key}) : super(key: key);

  @override
  _CargarProductosState createState() => _CargarProductosState();
}

class _CargarProductosState extends State<CargarProductos> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var jsonTienda;

  var docBase64;
  var docName;

  RestFun rest = RestFun();

  String errorStr;
  bool load = true;
  bool error = false;

  String succeString;

  @override
  void initState() {
    super.initState();
    sharedPrefs.init().then((value) {
      getTienda();
    });
  }

  getTienda() {
    rest
        .restService('', '${urlApi}obtener/mi-farmacia',
            sharedPrefs.partnerUserToken, 'get')
        .then((value) {
      if (value['status'] == 'server_true') {
        setState(() {
          jsonTienda = jsonDecode(value['response']);
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

  subirDoc() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

    var uri = Uri.dataFromBytes(result.files.first.bytes).toString();
    setState(() {
      docName = result.files.single.name;
      docBase64 = uri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBarVendedor(
        drawerMenu: false,
        screenWidht: MediaQuery.of(context).size.width,
        body: load
            ? bodyLoad(context)
            : error
                ? errorWidget(errorStr, context)
                : bodyCuenta(),
        title: "Aregar productos");
  }

  bodyCuenta() {
    var size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        // height: MediaQuery.of(context).size.height - 50,
        padding: EdgeInsets.symmetric(
            horizontal: size.width > 700 ? size.width / 3.5 : medPadding * .5,
            vertical: medPadding * 1.5),
        color: bgGrey,
        width: size.width,
        child: tabCargar(),
      ),
      footerVendedor(context),
    ]);
  }

  tabCargar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(child: cargarProductos(context)),
      ],
    );
  }

  cargarProductos(context) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Proceso de carga de productos",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'FjallaOne',
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: smallPadding * 2,
            ),
            Text(
              'Para que los productos puedan aparecer en la tienda debes seguir estos pasos:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
            SizedBox(
              height: smallPadding,
            ),
            Text(
              '1. Descarga el archivo plantilla con formato CSV.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
              '2. Llena todos los campos por cada producto que deseas publicar.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'a. En el campo de cantidad debes de colocar la cantidad de productos que mandaras al equipo de DRUG para tener disponibles en almacenes..',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
            Text(
              '3. Carga tu archivo con la información solicitada de tus productos.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
              '4. El equipo de DRUG validará los productos. Te mantendremos al tanto del proceso a través de correo electrónico.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
              '5. Una vez validados los productos se te será notificado, para que procedas a mandarlos al almacén DRUG.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
              '6. Una vez recibidos los productos en nuestras instalaciones de almacenamientos, estos serán cargados al sistema por el equipo DRUG. Al terminar el proceso de carga al sistema serás notificado.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
              '7. Finalmente podrás agregar información personalizada a tu producto y habilitarlo  para que todos los usuarios de DRUG puedan comprarlo.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            SizedBox(
              height: smallPadding * 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonSimple(
                    estilo: estiloBotonPrimary,
                    contenido: Text(
                      'Descargar plantilla',
                      style: TextStyle(color: Colors.white),
                    )),
                SizedBox(
                  height: smallPadding,
                ),
                docBase64 == null
                    ? BotonSimple(
                        action: () => subirDoc(),
                        estilo: estiloBotonSecundary,
                        contenido: Text(
                          'Subir CSV',
                          style: TextStyle(color: Colors.white),
                        ))
                    : succeString != null
                        ? Row(
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
                                    succeString,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ])
                        : BotonRestTest(
                            token: sharedPrefs.partnerUserToken,
                            url: '$apiUrl/publicar/productos',
                            method: 'post',
                            arrayData: {
                              "farmacia_id": jsonTienda[1]['farmacia_id'],
                              "archivoDeProductos": docBase64
                            },
                            errorStyle: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w600,
                            ),
                            action: (value) => setState(() {
                                  succeString = value['message'];
                                }),
                            estilo: estiloBotonSecundary,
                            showSuccess: true,
                            stringCargando: 'Subiendo archivo...',
                            contenido: Text(
                              'Enviar',
                              style: TextStyle(color: Colors.white),
                            )),
                docName == null
                    ? Container()
                    : SizedBox(
                        height: smallPadding,
                      ),
                docName == null
                    ? Container()
                    : succeString != null
                        ? Container()
                        : docCargado(docName)
              ],
            )
          ],
        ));
  }

  Widget docCargado(nombreDoc) {
    return Row(
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
        SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () {
            setState(() {
              docName = null;
              docBase64 = null;
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
                size: 10,
              )),
        )
      ],
    );
  }
}
