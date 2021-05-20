import 'dart:convert';
import 'dart:io';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/farmacia_model.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class TabRechazada extends StatefulWidget {
  final dynamic miTienda;
  TabRechazada({Key key, @required this.miTienda}) : super(key: key);

  @override
  _TabRechazadaState createState() => _TabRechazadaState();
}

class _TabRechazadaState extends State<TabRechazada> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel userModel = UserModel();
  var mediaData;
  Image pickedImage;

  FarmaciaModel farmaciaModel = FarmaciaModel();

  var imagePath;
  String base64Image;

  String fileaviso;
  String fileacta;
  String filecomprobante;
  String fileine;
  String filecedula;

  String tipoPersona;

  var aviso;
  var acta;
  var comprobante;
  var ine;
  var cedula;

  RestFun rest = RestFun();

  var jsonDetalles;

  @override
  void initState() {
    super.initState();
    sharedPrefs.init();
    farmaciaModel = FarmaciaModel.fromJson(widget.miTienda[1]);
    setState(() {
      tipoPersona = farmaciaModel.tipoPersona == "fisica" ? "Física" : "Moral";
    });
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
              token: sharedPrefs.partnerUserToken,
              url: '$apiUrl/actualizar/farmacia',
              method: 'post',
              formkey: formKey,
              arrayData: {
                "farmacia_id": farmaciaModel.farmacia_id,
                "nombre": farmaciaModel.nombre,
                "nombre_propietario": farmaciaModel.nombrePropietario,
                "rfc": farmaciaModel.rfc,
                "tipo_persona": farmaciaModel.tipoPersona,
                "correo": farmaciaModel.correo,
                "giro": farmaciaModel.giro,
                "base64": base64Image == null ? null : base64Image
              },
              contenido: Text(
                'Enviar a revisión',
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              action: (value) => saveDocuments(),
              errorStyle: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
              estilo: estiloBotonPrimary),
        ),
      ],
    );
  }

  saveDocuments() async {
    var arrayData = {
      "farmacia_id": farmaciaModel.farmacia_id,
      "aviso_de_funcionamiento": aviso,
      "acta_constitutiva": acta,
      "comprobante_de_domicilio": comprobante,
      "ine": ine,
      "cedula_fiscal": cedula
    };
    await rest
        .restService(arrayData, '${urlApi}cargar/documentos',
            sharedPrefs.partnerUserToken, 'post')
        .then((value) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/farmacia/miTienda',
        ModalRoute.withName('/farmacia/miCuenta'),
      ).then((value) => setState(() {}));
      // print(jsonDetalles['avi_func']['status']);
    });
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
                        : farmaciaModel.image_name == null
                            ? AssetImage('images/logoDrug.png')
                            : NetworkImage(farmaciaModel.image_name),
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
          DropdownButtonFormField<String>(
            isExpanded: true,
            hint: Text("Tipo de persona"),
            value: tipoPersona,
            items: ["Moral", "Física"].map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: Row(
                      children: [
                        Icon(Icons.store_outlined),
                        SizedBox(
                          width: 7,
                        ),
                        Text("Tipo de persona: " + value.toString()),
                      ],
                    ),
                  ),
                  // height: 5.0,
                ),
              );
            }).toList(),
            onChanged: (String val) {
              setState(() {
                tipoPersona = val;
                farmaciaModel.tipoPersona =
                    val == "Física" ? "fisica" : "moral";
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

  subirDoc(String docType) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      // var mimType = lookupMimeType(result.files.first.name, headerBytes: result.files.first.bytes);
      // var uri = Uri.dataFromBytes(result.files.first.bytes, mimeType: mimType).toString();

      var uri = Uri.dataFromBytes(result.files.first.bytes).toString();

      switch (docType) {
        case 'Aviso de funcionamiento':
          setState(() {
            fileaviso = result.files.single.name;
            aviso = uri;
          });
          break;
        case 'Acta constitutiva':
          setState(() {
            fileacta = result.files.single.name;
            acta = uri;
          });
          break;
        case 'Comprobante de domicilio':
          setState(() {
            filecomprobante = result.files.single.name;
            comprobante = uri;
          });
          break;
        case 'INE vigente':
          setState(() {
            fileine = result.files.single.name;
            ine = uri;
          });
          break;
        case 'Cédula fiscal SAT':
          setState(() {
            filecedula = result.files.single.name;
            cedula = uri;
          });
          break;
        default:
      }
    } else {
      // User canceled the picker
    }
  }

  document(doc) {
    Widget botonDoc;
    String status;

    switch (doc) {
      case 'Aviso de funcionamiento':
        botonDoc = jsonDetalles['avi_func']['status'] == 'rejected'
            ? botonAdjuntar(doc)
            : botonVer(doc);
        status = jsonDetalles['avi_func']['status'];
        break;
      case 'Acta constitutiva':
        botonDoc = jsonDetalles['act_cons']['status'] == 'rejected'
            ? botonAdjuntar(doc)
            : botonVer(doc);
        status = jsonDetalles['act_cons']['status'];
        break;
      case 'Comprobante de domicilio':
        botonDoc = jsonDetalles['comp_dom']['status'] == 'rejected'
            ? botonAdjuntar(doc)
            : botonVer(doc);
        status = jsonDetalles['comp_dom']['status'];
        break;
      case 'INE vigente':
        botonDoc = jsonDetalles['ine']['status'] == 'rejected'
            ? botonAdjuntar(doc)
            : botonVer(doc);
        status = jsonDetalles['ine']['status'];
        break;
      case 'Cédula fiscal SAT':
        botonDoc = jsonDetalles['ced_fis']['status'] == 'rejected'
            ? botonAdjuntar(doc)
            : botonVer(doc);
        status = jsonDetalles['ced_fis']['status'];
        break;
      default:
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
                statusDoc(doc, status)
              ],
            ),
          ),
          botonDoc
        ],
      ),
    );
  }

  Widget botonAdjuntar(doc) {
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

  Widget botonVer(doc) {
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
    );
  }

  Widget statusWidget(status) {
    Widget myWidget;
    switch (status) {
      case 'rejected':
        myWidget = docRechazado();
        break;
      case 'active':
        myWidget = docActive();
        break;
      case 'approved':
        myWidget = docAceptado();
        break;
      default:
    }
    return myWidget;
  }

  statusDoc(docType, status) {
    Widget myWidget;

    switch (docType) {
      case 'Aviso de funcionamiento':
        myWidget =
            fileaviso == null ? statusWidget(status) : docCargado(fileaviso);
        break;
      case 'Acta constitutiva':
        myWidget =
            fileacta == null ? statusWidget(status) : docCargado(fileacta);

        break;
      case 'Comprobante de domicilio':
        myWidget = filecomprobante == null
            ? statusWidget(status)
            : docCargado(filecomprobante);

        break;
      case 'INE vigente':
        myWidget = fileine == null ? statusWidget(status) : docCargado(fileine);

        break;
      case 'Cédula fiscal SAT':
        myWidget =
            filecedula == null ? statusWidget(status) : docCargado(filecedula);

        break;
      default:
    }

    return myWidget;
  }

  Widget docActive() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue[200],
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Flexible(
          child: Text(
            'Documento cargado',
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

  Widget docRechazado() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 13,
          width: 13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.red.withOpacity(0.8),
          ),
          child: Icon(
            Icons.close,
            size: 8,
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

  Widget docAceptado() {
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
            'Documento validado',
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

  Widget docCargado(nombreDoc) {
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
            nombreDoc,
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
