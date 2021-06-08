import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/farmacia_model.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';

class TabProceso extends StatefulWidget {
  final dynamic miTienda;
  TabProceso({Key key, @required this.miTienda}) : super(key: key);

  @override
  _TabProcesoState createState() => _TabProcesoState();
}

class _TabProcesoState extends State<TabProceso> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel userModel = UserModel();
  FarmaciaModel farmaciaModel = FarmaciaModel();

  RestFun rest = RestFun();

  var jsonDetalles;

  @override
  void initState() {
    super.initState();
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
      jsonDetalles = jsonDecode(value['response'])[1]['documentos'];
      // print(jsonDetalles['avi_func']['status']);
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
            'Estamos revisando tu farmacia.',
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
                  backgroundImage: farmaciaModel.image_name != null
                      ? NetworkImage(farmaciaModel.image_name)
                      : AssetImage('images/logoDrug.png'),
                ),
              ),
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
            habilitado: false,
            valorInicial: farmaciaModel.nombre,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Nombre comercial', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: farmaciaModel.nombrePropietario,
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Nombre del propietario', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: farmaciaModel.rfc,
            estilo:
                inputPrimarystyle(context, Icons.store_outlined, 'RFC', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
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
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: farmaciaModel.correo,
            estilo: inputPrimarystyle(
                context, Icons.email_outlined, 'Correo oficial', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            tipo: 'correo',
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: farmaciaModel.giro,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Giro del negocio', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'typeValidator',
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
