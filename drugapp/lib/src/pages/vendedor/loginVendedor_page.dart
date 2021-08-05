import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/pages/Lobby/validate_page.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/navigation_handler.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/buttom_widget.dart';
import 'package:drugapp/src/widget/input_widget.dart';
import 'package:flutter/material.dart';

class LoginVendedor extends StatefulWidget {
  final bool miTienda;
  LoginVendedor({Key key, this.miTienda = false}) : super(key: key);

  @override
  _LoginVendedorState createState() => _LoginVendedorState();
}

class _LoginVendedorState extends State<LoginVendedor> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String correo;
  String password;
  UserModel userModel = UserModel();

  bool loadPage = true;

  @override
  void initState() {
    sharedPrefs.init();
    validateFarmaciaToken();
    super.initState();
  }

  validateFarmaciaToken() async {
    await validateVendorToken().then((value) {
      validateVendorToken().then((value) {
        if (value) {
          if (widget.miTienda) {
            setState(() {});
            Navigator.pushNamed(context, '/miTienda')
                .then((value) => Navigator.pop(context))
                .then((value) => setState(() {}));
          } else {
            Navigator.pushNamedAndRemoveUntil(
                    context, '/farmacia/miCuenta/', (route) => false)
                .then((value) => setState(() {}));
          }
        } else {
          setState(() {
            loadPage = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loadPage
        ? Scaffold(
            body: bodyLoad(context),
          )
        : Scaffold(
            extendBodyBehindAppBar:
                MediaQuery.of(context).size.width < 700 ? false : true,
            appBar: widget.miTienda
                ? AppBar(
                    shadowColor: Colors.transparent,
                    backgroundColor: MediaQuery.of(context).size.width < 700
                        ? Theme.of(context).accentColor
                        : Colors.white.withOpacity(0.3),
                  )
                : null,
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
                                      'images/coverDrug.png',
                                      fit: BoxFit.cover,
                                      width: double.maxFinite,
                                      height: 400,
                                    ),
                                    Opacity(
                                        opacity: 0.6,
                                        child: Image.asset(
                                            'images/coverColor.png',
                                            width: double.maxFinite,
                                            height: 400,
                                            fit: BoxFit.cover)),
                                    Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          RichText(
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                              text: 'Somos ',
                                              style: TextStyle(
                                                  fontSize:
                                                      constraints.maxWidth < 700
                                                          ? 22
                                                          : 47,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Drug.',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Text(
                                              'Productos para la Salud, en un solo lugar.',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize:
                                                      constraints.maxWidth < 700
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
                              'images/coverDrug.png',
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
                      'Ingresa con el correo y contraseña que usaste para crear tu cuenta',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: medPadding),
                    _formLogin(),
                    widget.miTienda
                        ? Container()
                        : SizedBox(height: medPadding),
                    widget.miTienda
                        ? Container()
                        : InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, '/vendor/restablecer-contrasena/'),
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                    // widget.miTienda
                    //     ? Container()
                    //     : 
                        SizedBox(height: smallPadding * 1.25),
                    // widget.miTienda
                    //     ? Container()
                    //     : 
                        InkWell(
                            // onTap: () => Navigator.pushNamed(
                            //     context, '/farmacia/registro/'),
                            onTap: () => launchURL('https://app.drugsiteonline.com/farmacia/registro/'),
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
                                          color:
                                              Theme.of(context).primaryColor)),
                                ],
                              ),
                            ),
                          ),
                    widget.miTienda
                        ? Container()
                        : SizedBox(height: smallPadding * 1.25),
                    widget.miTienda
                        ? Container()
                        : InkWell(
                            onTap: () => Navigator.pushNamed(context, '/login'),
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
                                      text: 'comprador',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
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
                                  pressed: () => Navigator.pushNamed(
                                      context, '/aviso-de-privacidad/vendor/'),
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
                                  pressed: () => Navigator.pushNamed(context,
                                      '/terminos-y-condiciones/vendor/'),
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
          EntradaTextoTest(
            longMaxima: 100,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
            child: BotonRest(
                url: '$apiUrl/login',
                method: 'post',
                formkey: formKey,
                arrayData: {
                  'mail': '$correo',
                  'password': '$password',
                  'type': 'vendor'
                },
                // action: () => Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => HomeClient())),
                action: (value) {
                  var jsonResp = jsonDecode(value['response']);
                  savePartnerToken(jsonResp[1]['token']).then((value) {
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
                  child: Text('Todas tus marcas de Confianza.',
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
                        pressed: () => Navigator.pushNamed(
                            context, '/aviso-de-privacidad/vendor/'),
                      ),
                    ),
                    Flexible(flex: 2, child: SizedBox(width: medPadding)),
                    Flexible(
                      flex: 2,
                      child: SimpleButtom(
                        gcolor: gradientBlueLight,
                        mainText: 'Condiciones de uso',
                        textWhite: true,
                        pressed: () => Navigator.pushNamed(
                            context, '/terminos-y-condiciones/vendor/'),
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
            '', '${urlApi}perfil/usuario', sharedPrefs.partnerUserToken, 'get')
        .then((value) {
      print(value);
      if (value['status'] == 'server_true') {
        var jsonUser = jsonDecode(value['response']);
        userModel = UserModel.fromJson(jsonUser[1]);
        savePartnerModel(userModel).then((value) {
          if (widget.miTienda) {
            // CJNavigator.navigator.push(context, '/miTienda', true);
            // Navigator.pushNamedAndRemoveUntil(context, '/miTienda', ModalRoute.withName('/'));
            Navigator.pushNamed(context, '/miTienda')
                .then((value) => Navigator.pop(context));
          } else {
            /* Navigator.pushNamedAndRemoveUntil(
                context, '/farmacia/miCuenta', (route) => false); */
            CJNavigator.navigator.push(context, '/farmacia/miCuenta/', true);
            /* Navigator.pushNamedAndRemoveUntil(
                context, '/farmacia/miCuenta', (route) => false); */
          }
        });
      }
    });
  }
}
