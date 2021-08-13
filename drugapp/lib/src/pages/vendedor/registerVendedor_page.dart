import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/buttom_widget.dart';
import 'package:drugapp/src/widget/input_widget.dart';
import 'package:flutter/material.dart';

class RegisterVendedor extends StatefulWidget {
  RegisterVendedor({Key key}) : super(key: key);

  @override
  _RegisterVendedorState createState() => _RegisterVendedorState();
}

class _RegisterVendedorState extends State<RegisterVendedor> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name;
  String first_lastname;
  String second_lastname;
  String mail;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          MediaQuery.of(context).size.width < 700 ? false : true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: MediaQuery.of(context).size.width < 700
            ? Theme.of(context).primaryColor
            : Colors.white.withOpacity(0.3),
        title: Text(
          'Registro',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth < 700
            ? CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Column(
                        children: [
                          Container(
                            height: 150,
                            child: Stack(children: [
                              Image.asset(
                                'images/storebg.png',
                                fit: BoxFit.cover,
                                width: double.maxFinite,
                                height: 400,
                              ),
                              Opacity(
                                  opacity: 0.6,
                                  child: Image.asset('images/coverColor.png',
                                      width: double.maxFinite,
                                      height: 400,
                                      fit: BoxFit.cover)),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: 'Somos ',
                                        style: TextStyle(
                                            fontSize: constraints.maxWidth < 700
                                                ? 22
                                                : 47,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Drug.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        'Productos para la Salud, en un solo lugar.',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: constraints.maxWidth < 700
                                                ? 22
                                                : 47,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          _formContainer(constraints)
                        ],
                      ),
                      childCount: 1,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 6,
                    child: Stack(fit: StackFit.expand, children: [
                      Image.asset(
                        'images/storebg.png',
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: 400,
                      ),
                      Opacity(
                          opacity: 0.6,
                          child: Image.asset('images/coverColor.png',
                              width: double.maxFinite,
                              height: 400,
                              fit: BoxFit.cover)),
                      _infoContainer(constraints)
                    ]),
                  ),
                  Flexible(flex: 4, child: _formContainer(constraints)),
                ],
              );
      }),
    );
  }

  _formContainer(constraints) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/coverBlanco.png'))),
        child: ListView(
          shrinkWrap: true,
          physics: constraints.maxWidth > 700
              ? null
              : NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 1000 ? 30 : 85,
                  vertical: constraints.maxWidth < 1000 ? 10 : 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getAsset(
                        'logoDrug.png', MediaQuery.of(context).size.height / 7),
                    SizedBox(height: medPadding),
                    Text(
                      'Regístrate',
                      style:
                          TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: medPadding),
                    _formReg(),
                    SizedBox(height: medPadding),
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, '/farmacia/login/'),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '¿Ya tienes cuenta?, ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Dirígite aqui',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ));
  }

  _formReg() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Nombre', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.words,
            tipo: 'nombre',
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.lock_outline, 'Primer apellido', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'apellido',
            onChanged: (value) {
              setState(() {
                first_lastname = value;
              });
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(context, Icons.lock_outline,
                'Segundo apellido (opcional)', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'opcional',
            requerido: false,
            onChanged: (value) {
              setState(() {
                second_lastname = value;
              });
            },
          ),
          EntradaTextoTest(
            longMaxima: 50,
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Correo', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            tipo: 'correo',
            onChanged: (value) {
              setState(() {
                mail = value;
              });
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.lock_outline, 'Contraseña', null),
            tipoEntrada: TextInputType.visiblePassword,
            textCapitalization: TextCapitalization.none,
            action: TextInputAction.done,
            tipo: 'password',
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          SizedBox(height: medPadding),
          InkWell(
            onTap: () =>
                launchURL('https://drugsiteonline.com/aviso-de-privacidad/'),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Al crear tu cuenta aceptas estar deacuerdo con nuestro ',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey),
                children: <TextSpan>[
                  TextSpan(
                      text: 'aviso de privacidad.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            ),
          ),
          SizedBox(height: smallPadding * 1.25),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
            child: BotonRest(
                url: '$apiUrl/registro/usuario',
                method: 'post',
                formkey: formKey,
                arrayData: {
                  'name': name,
                  'first_lastname': first_lastname,
                  'second_lastname': second_lastname,
                  'mail': '$mail',
                  'password': '$password',
                  'type': 'vendor'
                },
                contenido: Text(
                  'Crear cuenta',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                action: (value) =>
                    Navigator.pushNamed(context, '/farmacia/login/'),
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

  _infoContainer(constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth < 700 ? 30 : 55.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: 'Somos ',
                style: TextStyle(
                    fontSize: constraints.maxWidth < 700 ? 22 : 47,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Drug.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ),
          Flexible(
            child: Text('Productos para la Salud, en un solo lugar.',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: constraints.maxWidth < 700 ? 22 : 47,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
          ),
          constraints.maxWidth < 700
              ? Container()
              : Flexible(
                  child: Text('Somos una empresa comprometida contigo.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: constraints.maxWidth < 700 ? 17 : 32,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                ),
          SizedBox(height: smallPadding),
          constraints.maxWidth < 700
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: SimpleButtom(
                        gcolor: gradientWhite,
                        mainText: 'Aviso de privacidad',
                        textWhite: false,
                        pressed: () => launchURL('https://drugsiteonline.com/aviso-de-privacidad/'),
                      ),
                    ),
                    Flexible(flex: 2, child: SizedBox(width: medPadding)),
                    Flexible(
                      flex: 2,
                      child: SimpleButtom(
                        gcolor: gradientBlueLight,
                        mainText: 'Condiciones de uso',
                        textWhite: true,
                        pressed: () => launchURL('https://drugsiteonline.com/terminos-y-condiciones/'),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
