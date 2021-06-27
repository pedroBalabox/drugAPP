import 'dart:convert';
import 'dart:io';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/farmacia_model.dart';
import 'package:drugapp/model/vendor_model.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class TabAceptada extends StatefulWidget {
  final dynamic miTienda;
  TabAceptada({Key key, @required this.miTienda}) : super(key: key);

  @override
  _TabAceptadaState createState() => _TabAceptadaState();
}

class _TabAceptadaState extends State<TabAceptada> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  VendorModel vendorModel = VendorModel();
  FarmaciaModel farmaciaModel = FarmaciaModel();
  var mediaData;
  Image pickedImage;
  var imagePath;
  String base64Image;
  RestFun rest = RestFun();

  var jsonDetalles;

  @override
  void initState() {
    super.initState();
    sharedPrefs.init();
    farmaciaModel = FarmaciaModel.fromJson(widget.miTienda[1]);
    getDetalles();
  }

  getDetalles() async {
    var arrayData = {
      'farmacia_id': farmaciaModel.farmacia_id,
    };
    await rest
        .restService(arrayData, '${urlApi}detalles/farmacia',
            sharedPrefs.partnerUserToken, 'post')
        .then((value) {
      setState(() {
        jsonDetalles = jsonDecode(value['response'])[1]['documentos'];
      });
    });
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
        SizedBox(
          height: smallPadding,
        ),
        Text(
          'Datos de mi tienda',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: miTienda(context)),
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

  pickImage() async {
    final _picker = ImagePicker();
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 80);
    var imgBase64Str;
    if (kIsWeb) {
      http.Response response = await http.get(Uri.parse(image.path));
      final bytes = response?.bodyBytes;
      imgBase64Str = base64Encode(bytes);
    } else {
      List<int> imageBytes = await File(image.path).readAsBytes();
      imgBase64Str = base64Encode(imageBytes);
    }
    setState(() {
      imagePath = image;
      base64Image = imgBase64Str.toString();
    });
  }

  miTienda(context) {
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
                child: InkWell(
                  // onTap: () async {
                  //   await pickImage();
                  //   setState(() {});
                  // },
                  child: CircleAvatar(
                    backgroundImage: imagePath != null
                        ? !kIsWeb
                            ? FileImage(File(imagePath.path))
                            : NetworkImage(imagePath.path)
                        : farmaciaModel.image_name == null
                            ? AssetImage('images/logoDrug.png')
                            : NetworkImage(farmaciaModel.image_name),
                  ),
                ),
              ),
            ),
            // SizedBox(height: smallPadding),
            // Text(
            //   'Toca para cambiar el logo de tu tienda',
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
            valorInicial: farmaciaModel.nombre,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Nombre comercial', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                farmaciaModel.nombre = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: farmaciaModel.nombrePropietario,
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Nombre del propietario', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                farmaciaModel.nombrePropietario = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: farmaciaModel.rfc,
            estilo:
                inputPrimarystyle(context, Icons.store_outlined, 'RFC', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                farmaciaModel.rfc = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial:
                farmaciaModel.tipoPersona == "fisica" ? "Física" : "Moral",
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Tipo de persona', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                farmaciaModel.tipoPersona = value;
              });
            },
          ),
          EntradaTexto(
            valorInicial: farmaciaModel.correo,
            estilo: inputPrimarystyle(
                context, Icons.email_outlined, 'Correo oficial', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            tipo: 'correo',
            onChanged: (value) {
              setState(() {
                farmaciaModel.correo = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: farmaciaModel.giro,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Giro del negocio', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                farmaciaModel.giro = value;
              });
            },
          ),
          SizedBox(
            height: smallPadding * 2,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
            child: BotonRestTest(
                showSuccess: true,
                token: sharedPrefs.partnerUserToken,
                url: '$apiUrl/actualizar/farmacia',
                method: 'post',
                formkey: formKey,
                arrayData: {
                  'farmacia_id': farmaciaModel.farmacia_id,
                  "nombre": farmaciaModel.nombre,
                  "correo": farmaciaModel.correo,
                  // "base64": base64Image == null ? null : base64Image
                },
                contenido: Text(
                  'Actualizar',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                action: (value) {},
                // Navigator.pushNamedAndRemoveUntil(
                //       context,
                //       '/farmacia/miTienda/',
                //       ModalRoute.withName('/farmacia/miCuenta'),
                //     ).then((value) => setState(() {})),
                errorStyle: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w600,
                ),
                estilo: estiloBotonPrimary),
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
                action: () {
                  switch (doc) {
                    case 'Aviso de funcionamiento':
                      launchURL(jsonDetalles['avi_func']['file']);
                      break;
                    case 'Acta constitutiva':
                      launchURL(jsonDetalles['act_cons']['file']);
                      break;
                    case 'Comprobante de domicilio':
                      launchURL(jsonDetalles['comp_dom']['file']);
                      break;
                    case 'INE vigente':
                      launchURL(jsonDetalles['ine']['file']);
                      break;
                    case 'Cédula fiscal SAT':
                      launchURL(jsonDetalles['ced_fis']['file']);
                      break;
                    default:
                  }
                },
                estilo: estiloBotonSecundary),
          ),
        ],
      ),
    );
  }
}
