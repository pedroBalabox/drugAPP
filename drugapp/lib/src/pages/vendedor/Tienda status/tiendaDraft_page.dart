import 'dart:convert';
import 'dart:io';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/farmacia_model.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class TabDraft extends StatefulWidget {
  final dynamic miTienda;
  TabDraft({Key key, @required this.miTienda}) : super(key: key);

  @override
  _TabDraftState createState() => _TabDraftState();
}

class _TabDraftState extends State<TabDraft> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel userModel = UserModel();
  FarmaciaModel farmaciaModel = FarmaciaModel();
  var mediaData;
  Image pickedImage;
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

  bool errorSize = false;

  @override
  void initState() {
    super.initState();
    sharedPrefs.init();
    farmaciaModel = FarmaciaModel.fromJson(widget.miTienda[1]);
    setState(() {
      tipoPersona = farmaciaModel.tipoPersona == "fisica" ? "Física" : "Moral";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Termina de registrar tu tienda',
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
        Container(child: nuevaTienda(context)),
        SizedBox(
          height: smallPadding * 4,
        ),
        Text(
          'Documentos',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        errorSize
            ? Padding(
                padding: EdgeInsets.only(top: smallPadding),
                child: Text(
                  'Adjunta un documento de máximo 10 MB.',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: smallPadding,
        ),
        Container(
          child: misDocs(context),
        ),
        SizedBox(
          height: medPadding,
        ),
        aviso == null
            ? textDocs()
            : acta == null
                ? textDocs()
                : comprobante == null
                    ? textDocs()
                    : ine == null
                        ? textDocs()
                        : cedula == null
                            ? textDocs()
                            : Container(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
          child: BotonRestTest(
              habilitado: aviso == null
                  ? false
                  : acta == null
                      ? false
                      : comprobante == null
                          ? false
                          : ine == null
                              ? false
                              : cedula == null
                                  ? false
                                  : true,
              token: sharedPrefs.partnerUserToken,
              url: '$apiUrl/cargar/documentos',
              method: 'post',
              formkey: formKey,
              arrayData: {
                "farmacia_id": farmaciaModel.farmacia_id,
                "aviso_de_funcionamiento": aviso,
                "acta_constitutiva": acta,
                "comprobante_de_domicilio": comprobante,
                "ine": ine,
                "cedula_fiscal": cedula
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
              action: (value) => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/farmacia/miTienda/',
                    ModalRoute.withName('/farmacia/miCuenta'),
                  ).then((value) => setState(() {})),
              errorStyle: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
              succesStyle: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
              estilo: estiloBotonPrimary),
        ),
      ],
    );
  }

  textDocs() {
    return Column(
      children: [
        Text(
          'Adjunta todos los documentos.',
          style: TextStyle(
            color: Colors.red[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: smallPadding,
        )
      ],
    );
  }

  pickImage() async {
    int maxSize = 500;
    int quality = 60;

    try {
      final _picker = ImagePicker();
      PickedFile image = await _picker.getImage(
          source: ImageSource.gallery,
          imageQuality: quality,
          maxWidth: maxSize.toDouble(),
          maxHeight: maxSize.toDouble());
      showLoadingDialog(context, "Procesando imagen", "Espera un momento...");
      Future.delayed(Duration(milliseconds: 500), () {
        preprocessImage(image, context, maxSize, quality).then((base64) {
          if (base64 != "") {
            setState(() {
              imagePath = image;
              base64Image = base64.toString();
            });
          }
        });
      });
    } catch (e) {
      showErrorDialog(context, "Error para obtener la imagen", e.toString());
    }
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
              'Toca para subir el logo de tu famracia',
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
          /* EntradaTexto(
            valorInicial: farmaciaModel.tipoPersona,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Moral/física', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
            onChanged: (value) {
              setState(() {
                farmaciaModel.tipoPersona = value;
              });
            },
          ), */
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
          DropdownButtonFormField<String>(
            isExpanded: true,
            hint: Text("Giro del negocio"),
            value: farmaciaModel.giro,
            items: giroFarmacia.map((value) {
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
                        Text("Giro del negocio: " + value.toString()),
                      ],
                    ),
                  ),
                  // height: 5.0,
                ),
              );
            }).toList(),
            onChanged: (String val) {
              setState(() {
                // tipoPersona = val;
                farmaciaModel.giro = val;
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
                  "nombre_propietario": farmaciaModel.nombrePropietario,
                  "rfc": farmaciaModel.rfc,
                  "tipo_persona": farmaciaModel.tipoPersona,
                  "correo": farmaciaModel.correo,
                  "giro": farmaciaModel.giro,
                  "base64": base64Image == null ? null : base64Image
                },
                contenido: Text(
                  'Guardar',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                /* action: (value) => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/farmacia/miTienda/',
                      ModalRoute.withName('/farmacia/miCuenta'),
                    ).then((value) => setState(() {})), */
                action: (value) => () {},
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

  subirDoc(String docType) async {
    try {
      FilePickerResult result =
          await FilePicker.platform.pickFiles(withData: true);

      if (result != null) {
        if (result.files.single.size <= 10000000) {
          // var mimType = lookupMimeType(result.files.first.name, headerBytes: result.files.first.bytes);
          // var uri = Uri.dataFromBytes(result.files.first.bytes, mimeType: mimType).toString();
          setState(() {
            errorSize = false;
          });
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
          setState(() {
            errorSize = true;
          });
        }
      }
    } catch (e) {}
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 3,
                ),
                statusDoc(doc)
              ],
            ),
          ),
          Padding(
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
          ),
        ],
      ),
    );
  }

  statusDoc(docType) {
    Widget myWidget;

    switch (docType) {
      case 'Aviso de funcionamiento':
        myWidget = fileaviso == null ? Container() : docCargado(fileaviso);
        break;
      case 'Acta constitutiva':
        myWidget = fileacta == null ? Container() : docCargado(fileacta);

        break;
      case 'Comprobante de domicilio':
        myWidget =
            filecomprobante == null ? Container() : docCargado(filecomprobante);

        break;
      case 'INE vigente':
        myWidget = fileine == null ? Container() : docCargado(fileine);

        break;
      case 'Cédula fiscal SAT':
        myWidget = filecedula == null ? Container() : docCargado(filecedula);

        break;
      default:
    }

    return myWidget;
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
