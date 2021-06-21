import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/bloc_user.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/event_user.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/navigation_handler.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/buttom_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String correo;
  String password;
  UserModel userModel = UserModel();
  UserBloc _userBloc = UserBloc();

  @override
  void initState() {
    sharedPrefs.init();
    super.initState();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                                'images/drug3.jpg',
                                fit: BoxFit.cover,
                                width: double.maxFinite,
                                height: 400,
                              ),
                              Opacity(
                                  opacity: 0.75,
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
                                    Text('Sí, medicina on demand.',
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
                        'images/drug3.jpg',
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: 400,
                      ),
                      Opacity(
                          opacity: 0.75,
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
                  vertical: constraints.maxWidth < 1000 ? 10 : 85),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getAsset(
                        'logoDrug.png', MediaQuery.of(context).size.height / 7),
                    SizedBox(height: medPadding),
                    Text(
                      'Inicia sesión',
                      style:
                          TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: smallPadding),
                    Text(
                      'Igresa con el correo y contraseña que usaste para crear tu cuenta',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: medPadding),
                    _formLogin(),
                    SizedBox(height: medPadding),
                    Text(
                      '¿Olvidaste tu contraseña?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    SizedBox(height: smallPadding * 1.25),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/registro'),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '¿Aún no tienes cuenta?, ',
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
                    SizedBox(height: smallPadding * 1.25),
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, '/farmacia/login'),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Entra como ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'vendedor',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                    ),
                    constraints.maxWidth > 700
                        ? Container()
                        : SizedBox(height: medPadding),
                    constraints.maxWidth > 700
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 3,
                                child: SimpleButtom(
                                  gcolor: gradientWhite,
                                  mainText: 'Aviso de privacidad',
                                  textWhite: false,
                                  pressed: () => print('ok'),
                                ),
                              ),
                              Flexible(
                                  flex: 1, child: SizedBox(width: medPadding)),
                              Flexible(
                                flex: 3,
                                child: SimpleButtom(
                                  gcolor: gradientBlueLight,
                                  mainText: 'Condiciones de uso',
                                  textWhite: true,
                                  pressed: () => print('ok'),
                                ),
                              ),
                            ],
                          ),
                  ]),
            )
          ],
        ));
  }

  _formLogin() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Correo', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            tipo: 'correo',
            onChanged: (value) {
              setState(() {
                correo = value;
              });
            },
            onSaved: (value) {
              setState(() {
                correo = value;
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
            onSaved: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          SizedBox(height: medPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
            child: BotonRest(
                primerAction: () {
                  formKey.currentState.save();
                  print(correo);
                  print(password);
                },
                url: '$apiUrl/login',
                method: 'post',
                formkey: formKey,
                arrayData: {
                  'mail': '$correo',
                  'password': '$password',
                  'type': 'client'
                },
                action: (value) {
                  var jsonResp = jsonDecode(value['response']);
                  saveUserToken(jsonResp[1]['token']).then((value) {
                    loginFuntion();
                  });
                },
                contenido: Text(
                  'Iniciar sesión',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
            child: Text('Sí, medicina on demand.',
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
                        pressed: () => print('ok'),
                      ),
                    ),
                    Flexible(flex: 2, child: SizedBox(width: medPadding)),
                    Flexible(
                      flex: 2,
                      child: SimpleButtom(
                        gcolor: gradientBlueLight,
                        mainText: 'Condiciones de uso',
                        textWhite: true,
                        pressed: () => print('ok'),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  loginFuntion() {
    RestFun rest = RestFun();
    rest
        .restService(
            '', '${urlApi}perfil/usuario', sharedPrefs.clientToken, 'get')
        .then((value) {
      print(value);
      if (value['status'] == 'server_true') {
        var jsonUser = jsonDecode(value['response']);
        userModel = UserModel.fromJson(jsonUser[1]);
        saveUserModel(userModel).then((value) {
          _userBloc.sendEvent.add(AddUserItemEvent(userModel));
          //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          CJNavigator.navigator.push(context, '/');
        });
      }
    });
    // get userData from API and then
    // userModel = UserModel.fromJson(jsonDecode(dummyUser));
  }
}
