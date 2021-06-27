import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawerVendedor_widget.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:drugapp/src/widget/input_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';

class ChangePass extends StatefulWidget {
  final bool cliente;

  ChangePass({Key key, @required this.cliente}) : super(key: key);

  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  String oldPass;
  String newPass;
  String confirmnewPass;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // sharedPrefs.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return widget.cliente
        ? ResponsiveAppBar(
            screenWidht: MediaQuery.of(context).size.width,
            body: Container(
              color: bgGrey,
              child: ListView(children: [
                SizedBox(
                  height: medPadding,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          size.width > 700 ? size.width / 3 : medPadding * .5,
                      vertical: medPadding * 1.5),
                  color: bgGrey,
                  width: size.width,
                  child: bodyPassword(),
                ),
                footer(context),
              ]),
            ),
            title: "Cambiar contraseña")
        : ResponsiveAppBarVendedor(
            screenWidht: MediaQuery.of(context).size.width,
            body: Container(
              color: bgGrey,
              child: ListView(children: [
                SizedBox(
                  height: medPadding,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          size.width > 700 ? size.width / 3 : medPadding * .5,
                      vertical: medPadding * 1.5),
                  color: bgGrey,
                  width: size.width,
                  child: bodyPassword(),
                ),
                footer(context),
              ]),
            ),
            title: "Cambiar contraseña");
  }

  bodyPassword() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Cambiar mi contraseña',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Text(
          'Introduce tu contraseña anterior y confirma tu nueva contraseña.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: formPassword()),
      ],
    );
  }

  formPassword() {
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
        child: Form(
          key: formKey,
          child: Column(
            children: [
              EntradaTexto(
                longMinima: 1,
                longMaxima: 500,
                estilo: inputPrimarystyle(
                    context, Icons.lock_outline, 'Nueva contraseña', null),
                tipoEntrada: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.none,
                action: TextInputAction.done,
                tipo: 'password',
                onChanged: (value) {
                  setState(() {
                    newPass = value;
                  });
                },
              ),
              EntradaTexto(
                valorInicial: '',
                estilo: inputPrimarystyle(context, Icons.lock_outline,
                    'Confirmar nueva contraseña', null),
                tipoEntrada: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.words,
                tipo: 'password',
                onChanged: (value) {
                  setState(() {
                    confirmnewPass = value;
                  });
                },
              ),
              EntradaTexto(
                valorInicial: '',
                estilo: inputPrimarystyle(
                    context, Icons.lock, 'Contraseña anterior', null),
                tipoEntrada: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.words,
                tipo: 'password',
                onChanged: (value) {
                  setState(() {
                    oldPass = value;
                  });
                },
              ),
              SizedBox(height: medPadding),
              newPass == null || newPass == ''
                  ? botonRestPAss(false, false)
                  : confirmnewPass == null || confirmnewPass == ''
                      ? botonRestPAss(false, false)
                      : confirmnewPass == newPass
                          ? botonRestPAss(true, false)
                          : botonRestPAss(false, true)
            ],
          ),
        ));
  }

  botonRestPAss(bool habilitado, bool errorStr) {
    return Column(
      children: [
        !errorStr
            ? Container()
            : Text(
                'Las contraseñas no coinciden',
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
        !errorStr
            ? Container()
            : SizedBox(
                height: smallPadding,
              ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
          child: BotonRestTest(
              habilitado: habilitado,
              showSuccess: true,
              token: widget.cliente
                  ? sharedPrefs.clientToken
                  : sharedPrefs.partnerUserToken,
              url: '$apiUrl/cambiar/clave',
              method: 'post',
              formkey: formKey,
              arrayData: {"old_password": oldPass, "password": newPass},
              contenido: Text(
                'Cambiar contraseña',
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
        )
      ],
    );
  }
}
