import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';

class RecoverPass extends StatefulWidget {
  final String tipoUser;

  RecoverPass({Key key, @required this.tipoUser}) : super(key: key);

  @override
  _RecoverPassState createState() => _RecoverPassState();
}

class _RecoverPassState extends State<RecoverPass> {
  String correo;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
        title: Text('Recuperar contraseña'),
        actions: [
          Container(
            padding: EdgeInsets.all(5),
            height: 50,
            width: 55,
            child: getAsset('logoDrug.png', 0.0),
          )
        ],
      ),
      body: Container(
        color: bgGrey,
        child: ListView(children: [
          SizedBox(
            height: medPadding,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width > 700 ? size.width / 3 : medPadding * .5,
                vertical: medPadding * 1.5),
            color: bgGrey,
            width: size.width,
            child: bodyPassword(),
          ),
          // footer(context),
        ]),
      ),
    );
  }

  bodyPassword() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Introduce tu correo para que te enviemos un link para restablecer tu contraseña.',
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
                    context, Icons.mail_outline, 'Correo', null),
                tipoEntrada: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                action: TextInputAction.next,
                tipo: 'mail',
                onChanged: (value) {
                  setState(() {
                    correo = value;
                  });
                },
              ),
              SizedBox(height: medPadding),
              botonRestPAss()
            ],
          ),
        ));
  }

  botonRestPAss() {
    return Column(
      children: [
        BotonRestTest(
            showSuccess: true,
            token: null,
            url: '$apiUrl/request-password',
            method: 'post',
            formkey: formKey,
            arrayData: {"mail": correo, "type": widget.tipoUser},
            contenido: Text(
              'Enviar link de restablecimiento',
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
            estilo: estiloBotonPrimary)
      ],
    );
  }
}
