import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawerVendedor_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';

class EditarProducto extends StatefulWidget {
  static const routeName = '/farmacia/editar-prodcuto';

  final dynamic jsonProducto;

  EditarProducto({Key key, this.jsonProducto}) : super(key: key);

  @override
  _EditarProductoState createState() => _EditarProductoState();
}

class _EditarProductoState extends State<EditarProducto> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBarVendedor(
      title: 'Editar prodcuto',
      screenWidht: MediaQuery.of(context).size.width,
      body: bodyProducto(),
    );
  }

  bodyProducto() {
    var size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width > 700 ? size.width / 3 : medPadding * .5,
            vertical: medPadding * 1.5),
        color: bgGrey,
        width: size.width,
        child: tabProdcuto(),
      ),
      footer(context),
    ]);
  }

  tabProdcuto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Mis datos',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Text(
          'Datos personales',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: miProducto(context)),
      ],
    );
  }

  miProducto(context) {
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
            formCuenta(),
          ],
        ));
  }

  formCuenta() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EntradaTexto(
            // valorInicial: userModel.name,
            habilitado: false,
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Nombre', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.words,
            tipo: 'nombre',

            onChanged: (value) {
              setState(() {
                // name = value;
              });
            },
          ),
          EntradaTexto(
            habilitado: false,
            // valorInicial: userModel.first_lastname,
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Laboratorio / Marca', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'textolargo',
            onChanged: (value) {
              setState(() {});
            },
          ),
          EntradaTexto(
            // valorInicial: userModel.second_lastname,
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Categoría', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'apellido',
            onChanged: (value) {
              setState(() {});
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.phone_outlined, 'Subcategoria', null),
            tipoEntrada: TextInputType.phone,
            textCapitalization: TextCapitalization.none,
            tipo: 'phone',
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: medPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
            child: BotonRestTest(
                token: sharedPrefs.clientToken,
                // url: '$apiUrl/actualizar/usuario',
                method: 'post',
                formkey: formKey,
                // arrayData: {
                //   "user_id": userModel.user_id,
                //   "name": name,
                //   "first_lastname": first_lastname,
                //   "second_lastname": second_lastname,
                //   "password": "123456789",
                //   "phone": phone,
                // },
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
}
