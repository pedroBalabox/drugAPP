import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class TabProceso extends StatefulWidget {
  TabProceso({Key key}) : super(key: key);

  @override
  _TabProcesoState createState() => _TabProcesoState();
}

class _TabProcesoState extends State<TabProceso> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel userModel = UserModel();
  String nombre = 'Famracias del Ahorro';
  String correo = 'farmacia@farmacia.com';
  String giro = 'Farmacia de medicamentos.';
  String nombre_propietario = 'Andrea Sandoval Gomez Farias';
  String rfc = 'RFC123456789';
  String tipo_persona = 'Física';
  var mediaData;
  Image pickedImage;

  var imagePath;
  String base64Image;

  String fileaviso;
  String fileacta;
  String filecomprobante;
  String fileine;
  String filecedula;

  var aviso;
  var acta;
  var comprobante;
  var ine;
  var cedula;

  String token;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString('user_token');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Mi tienda',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        // SizedBox(
        //   height: smallPadding,
        // ),
        // Text(
        //   'Status',
        //   style: TextStyle(
        //       color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        // ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: statusTienda()),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Datos de mi tienda',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: nuevaTienda(context)),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Documentos',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(
          child: misDocs(context),
        ),
      ],
    );
  }

  statusTienda() {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(100)),
              ),
              SizedBox(
                width: 3,
              ),
              Flexible(
                child: Text(
                  'En proceso de revisión.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: smallPadding,
          ),
          Text(
            'Estamos revisando tu tienda.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  nuevaTienda(context) {
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
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.all(3),
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    gradient: gradientDrug,
                    borderRadius: BorderRadius.circular(100)),
                child: CircleAvatar(
                  backgroundImage: imagePath != null
                      ? !kIsWeb
                          ? FileImage(File(imagePath.path))
                          : NetworkImage(imagePath.path)
                      : AssetImage('images/logoDrug.png'),
                ),
              ),
            ),
            // SizedBox(height: smallPadding),
            // Text(
            //   'Toca para subir el logo de tu tienda',
            //   style: TextStyle(color: Colors.black54),
            // ),
            SizedBox(height: smallPadding),
            formNuevaTienda(),
          ],
        ));
  }

  formNuevaTienda() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EntradaTexto(
            habilitado: false,
            valorInicial: nombre,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Nombre comercial', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                nombre = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: nombre_propietario,
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Nombre del propietario', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                nombre_propietario = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: rfc,
            estilo:
                inputPrimarystyle(context, Icons.store_outlined, 'RFC', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                rfc = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: tipo_persona,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Moral/física', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                tipo_persona = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: correo,
            estilo: inputPrimarystyle(
                context, Icons.email_outlined, 'Correo oficial', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            tipo: 'correo',
            onChanged: (value) {
              setState(() {
                correo = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: giro,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Giro del negocio', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                giro = value;
              });
            },
          ),
        ],
      ),
    );
  }

  misDocs(context) {
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
            ListView.builder(
              itemCount: documents.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return document(documents[index]);
              },
            ),
          ],
        ));
  }

  document(doc) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1.5)),
      ),
      padding: EdgeInsets.symmetric(vertical: smallPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon(Icons.file_copy_outlined),
          Flexible(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.attach_file_outlined,
                size: 15,
                color: Colors.black.withOpacity(0.8),
              ),
              SizedBox(
                width: 3,
              ),
              Flexible(
                child: Text(
                  doc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              )
            ],
          )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: smallPadding),
            child: BotonSimple(
                contenido: Padding(
                  padding: EdgeInsets.symmetric(horizontal: smallPadding),
                  child: Text(
                    'Ver',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                action: () => launchURL(
                    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                estilo: estiloBotonSecundary),
          ),
        ],
      ),
    );
  }
}
