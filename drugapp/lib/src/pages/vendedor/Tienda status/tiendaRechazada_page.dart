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
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TabRechazada extends StatefulWidget {
  TabRechazada({Key key}) : super(key: key);

  @override
  _TabRechazadaState createState() => _TabRechazadaState();
}

class _TabRechazadaState extends State<TabRechazada> {
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

  var docs;

  @override
  void initState() {
    super.initState();
    docs = jsonDecode(dummyDocs);
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
        SizedBox(
          height: medPadding,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
          child: BotonRestTest(
              token: token,
              url: '$apiUrl/registro/farmacia',
              method: 'post',
              formkey: formKey,
              arrayData: {
                "nombre": nombre,
                "nombre_propietario": nombre_propietario,
                "rfc": rfc,
                "tipo_persona": tipo_persona,
                "correo": correo,
                "giro": giro,
                "base64": base64Image == null ? null : base64Image
              },
              contenido: Text(
                'Enviar tienda',
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              action: (value) => print(value),
              errorStyle: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
              estilo: estiloBotonPrimary),
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
                    color: Colors.red[200],
                    borderRadius: BorderRadius.circular(100)),
              ),
              SizedBox(
                width: 3,
              ),
              Flexible(
                child: Text(
                  'Encontramos un problema',
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
            'Revisa tu correo electrónico para ver mas detalles del status de tu tienda.',
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
                child: InkWell(
                  onTap: () async {
                    await pickImage();
                    setState(() {});
                  },
                  child: CircleAvatar(
                    backgroundImage: imagePath != null
                        ? !kIsWeb
                            ? FileImage(File(imagePath.path))
                            : NetworkImage(imagePath.path)
                        : AssetImage('images/logoDrug.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: smallPadding),
            Text(
              'Toca para subir el logo de tu tienda',
              style: TextStyle(color: Colors.black54),
            ),
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
        // child: ListView.builder(
        //   itemCount: documents.length,
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemBuilder: (BuildContext context, int index) {
        //     return document(documents[index]);
        //   },
        // )
        );
  }

  subirDoc(String docType) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List uploadfile = result.files.single.bytes;
      // print('path' + result.files.first.path);
      // File file = File(result.files.first.path);
      // List<int> fileInByte = file.readAsBytesSync();
      String fileInBase64 = base64Encode(uploadfile);
      switch (docType) {
        case 'Aviso de funcionamiento':
          setState(() {
            fileaviso = result.files.single.name;
            aviso = fileInBase64;
          });
          break;
        case 'Acta constitutiva':
          setState(() {
            fileacta = result.files.single.name;
            acta = fileInBase64;
          });
          break;
        case 'Comprobante de domicilio':
          setState(() {
            filecomprobante = result.files.single.name;
            comprobante = fileInBase64;
          });
          break;
        case 'INE vigente':
          setState(() {
            fileine = result.files.single.name;
            ine = fileInBase64;
          });
          break;
        case 'Cédula fiscal SAT':
          setState(() {
            filecedula = result.files.single.name;
            cedula = fileInBase64;
          });
          break;
        default:
      }
    } else {
      // User canceled the picker
    }
  }

  document(doc) {
    Widget boton;

    switch (doc) {
      case 'Aviso de funcionamiento':
        if (docs['avi_func'] == 'active') {
          boton = botonVer(doc);
        } else
          boton = docRejected();
        break;
      case 'Acta constitutiva':
        if (docs['act_cons'] == 'active') {
          boton = docActive();
        } else
          boton = docRejected();

        break;
      case 'Comprobante de domicilio':
        if (docs['comp_dom'] == 'active') {
          boton = docActive();
        } else
          boton = docRejected();

        break;
      case 'INE vigente':
        if (docs['ine'] == 'active') {
          boton = docActive();
        } else
          boton = docRejected();
        break;
      case 'Cédula fiscal SAT':
        if (docs['ced_fis'] == 'active') {
          boton = docActive();
        } else
          boton = docRejected();
        break;
      default:
        boton = docRejected();
    }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                // statusDoc(doc),
                
              ],
            ),
          ),
          boton
        ],
      ),
    );
  }

  botonVer(doc) {
    return Padding(
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
          action: () => subirDoc(doc),
          estilo: estiloBotonSecundary),
    );
  }

  botonAsjuntar(doc) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: smallPadding),
      child: BotonSimple(
          contenido: Padding(
            padding: EdgeInsets.symmetric(horizontal: smallPadding),
            child: Text(
              'Adjuntar',
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          action: () => subirDoc(doc),
          estilo: estiloBotonSecundary),
    );
  }

  statusDoc(docType) {
    Widget myWidget;

    switch (docType) {
      case 'Aviso de funcionamiento':
        if (docs['avi_func'] == 'active') {
          myWidget = docActive();
        } else
          myWidget = docRejected();
        break;
      case 'Acta constitutiva':
        if (docs['act_cons'] == 'active') {
          myWidget = docActive();
        } else
          myWidget = docRejected();

        break;
      case 'Comprobante de domicilio':
        if (docs['comp_dom'] == 'active') {
          myWidget = docActive();
        } else
          myWidget = docRejected();

        break;
      case 'INE vigente':
        if (docs['ine'] == 'active') {
          myWidget = docActive();
        } else
          myWidget = docRejected();
        break;
      case 'Cédula fiscal SAT':
        if (docs['ced_fis'] == 'active') {
          myWidget = docActive();
        } else
          myWidget = docRejected();
        break;
      default:
        myWidget = docRejected();
    }
    return myWidget;
  }

  Widget docActive() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 13,
          color: Colors.green.withOpacity(0.8),
        ),
        SizedBox(
          width: 3,
        ),
        Flexible(
          child: Text(
            'Documento aceptado',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black45,
            ),
          ),
        )
      ],
    );
  }

  Widget docRejected() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 13,
          width: 13,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.red.withOpacity(0.8)),
          child: Icon(
            Icons.close_rounded,
            size: 10,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Flexible(
          child: Text(
            'Documento rechazado',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black45,
            ),
          ),
        )
      ],
    );
  }
}
