import 'dart:convert';
import 'dart:io';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/orden_model.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/bloc_user.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/event_user.dart';
import 'package:drugapp/src/pages/client/payments/paymentFunctions.dart';
import 'package:drugapp/src/service/jsFlutter/auth_class.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/buttom_widget.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_number_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:openpay/openpay.dart';

// import 'package:flutter_openpay/flutter_openpay.dart'
//     if (dart.library.html) 'dart:js' as js;

class MiCuentaClient extends StatefulWidget {
  final int index;

  MiCuentaClient({Key key, this.index = 0}) : super(key: key);

  @override
  _MiCuentaClientState createState() => _MiCuentaClientState();
}

class _MiCuentaClientState extends State<MiCuentaClient> {
  final openpay = Openpay(
      'mroipipydkwe3txxqfht', 'pk_0450626f5da34f87b4a0279a4c34fa1c',
      isSandboxMode: true);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyPedido = GlobalKey<FormState>();
  String name;
  String first_lastname;
  String second_lastname;
  String mail;
  String phone;
  String password;
  UserModel userModel = UserModel();
  var mediaData;
  Image pickedImage;
  var imagePath;
  String base64Image;
  UserBloc _userBloc = UserBloc();

  bool loadmiInfo = true;

  //New card
  String cardHolder;
  String cp;
  String cardNumber;
  int toSendCardNumber;
  int month;
  int year;
  int cvc;
  var myCards;

  bool errorSession = true;

  var _deviceSessionId;

//Pedido especial
  String productName;
  String productDescription;
  String productBrand;
  int productQuantity;
  int contactPhone;
  String contactMail;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      AuthManager.instance.funTest().then((value) {
        setState(() {
          try {
            _deviceSessionId = value;
            errorSession = false;
          } catch (e) {
            errorSession = true;
          }
        });
      });
    } else {
      AuthManager.instance.funTest().then((value) {
        setState(() {
          if (value == 'error') {
            errorSession = true;
          } else {
            try {
              _deviceSessionId = value;
              errorSession = false;
            } catch (e) {
              errorSession = true;
            }
          }
        });
      });
    }

    sharedPrefs.init().then((value) {
      getUserData();
    });
  }

  RestFun restFunction = RestFun();
  String cardToken;

  Future saveCard() async {
    var arrayData = {
      "token_id": cardToken.toString(),
      "device_session_id": _deviceSessionId
    };

    await restFunction
        .restService(
            arrayData, '$apiUrl/crear/tarjeta', sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showErrorDialog(context, "Parece que hubo un error", value['message']);
      }
    });
  }

  getUserData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // var jsonUser = jsonDecode(prefs.getString('partner_data'));

    setState(() {
      userModel = UserModel.fromJson(jsonDecode(sharedPrefs.clientData));
      loadmiInfo = false;
    });
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBar(
        screenWidht: MediaQuery.of(context).size.width,
        body: bodyCuenta(),
        title: "Mi cuenta");
  }

  bodyCuenta() {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 4,
      initialIndex: widget.index,
      child: Stack(
        children: [
          TabBarView(
            children: [
              ListView(children: [
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
                  child: tabMiCuenta(),
                ),
                // footer(context),
              ]),
              Container(
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
                    child: tabMisTarjetas(),
                  ),
                  // footer(context),
                ]),
              ),
              Container(
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
                    child: tabPedidoEspecial(),
                  ),
                  // footer(context),
                ]),
              ),
              TabCompras(),
            ],
          ),
          Container(
            width: size.width,
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
            child: TabBar(
              indicatorWeight: 3,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: 'Mis datos',
                ),
                Tab(
                  text: 'Mis tarjetas',
                ),
                Tab(
                  text: 'Pedidos especiales',
                ),
                Tab(
                  text: 'Compras',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  tabMiCuenta() {
    return loadmiInfo
        ? bodyLoad(context)
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Mis datos',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              SizedBox(
                height: smallPadding,
              ),
              Text(
                'Datos personales',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              SizedBox(
                height: smallPadding,
              ),
              Container(child: miCuenta(context)),
              SizedBox(height: medPadding / 2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
                child: BotonSimple(
                  action: () =>
                      Navigator.pushNamed(context, '/cambiar-contraseña'),
                  contenido: Text(
                    'Cambiar contraseña',
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  estilo: estiloBotonSecundary,
                ),
              )
              // SizedBox(
              //   height: smallPadding * 4,
              // ),
              // Text(
              //   'Dirección',
              //   style: TextStyle(
              //       color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
              // ),
              // SizedBox(
              //   height: smallPadding,
              // ),
              // Container(
              //   child: miDireccion(context),
              // ),
            ],
          );
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Future<String> mobileb64(image) async {
    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  pickImage() async {
    int maxSize = 700;
    int quality = 100;

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

  miCuenta(context) {
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
                child: Hero(
                  tag: "profile_picture",
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
                          : NetworkImage(userModel.imgUrl),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: smallPadding),
            Text(
              'Toca para cambiar tu foto de perfil',
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: smallPadding),
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
            valorInicial: userModel.name,
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
            valorInicial: userModel.first_lastname,
            estilo: inputPrimarystyle(
                context, Icons.person_outline, 'Primer apellido', null),
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
            requerido: false,
            valorInicial: userModel.second_lastname,
            estilo: inputPrimarystyle(context, Icons.person_outline,
                'Segundo apellido (opcional)', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'apellido',
            onChanged: (value) {
              setState(() {
                second_lastname = value;
              });
            },
          ),
          EntradaTexto(
            valorInicial: userModel.mail.toString(),
            estilo:
                inputPrimarystyle(context, Icons.mail_outline, 'Correo', null),
            tipoEntrada: TextInputType.phone,
            textCapitalization: TextCapitalization.none,
            tipo: 'correo',
            onChanged: (value) {
              setState(() {
                mail = value.toString();
              });
            },
          ),
          EntradaTexto(
            valorInicial: userModel.phone,
            estilo: inputPrimarystyle(
                context, Icons.phone_outlined, 'Teléfono', null),
            tipoEntrada: TextInputType.phone,
            textCapitalization: TextCapitalization.none,
            tipo: 'telefono',
            onChanged: (value) {
              setState(() {
                phone = value.toString();
              });
            },
          ),
          SizedBox(height: medPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
            child: BotonRestTest(
                showSuccess: true,
                token: sharedPrefs.clientToken,
                url: '$apiUrl/actualizar/usuario',
                method: 'post',
                formkey: formKey,
                arrayData: {
                  "user_id": userModel.user_id,
                  "name": name,
                  "first_lastname": first_lastname,
                  "second_lastname": second_lastname,
                  "password": "123456789",
                  "phone": phone,
                  "mail": mail,
                  "base64": base64Image == null ? null : base64Image
                },
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
                action: (value) {
                  RestFun rest = RestFun();
                  rest
                      .restService('', '${urlApi}perfil/usuario',
                          sharedPrefs.clientToken, 'get')
                      .then((value) {
                    if (value['status'] == 'server_true') {
                      var jsonUser = jsonDecode(value['response']);
                      userModel = UserModel.fromJson(jsonUser[1]);
                      setState(() {
                        _userBloc.sendEvent.add(EditUserItemEvent(userModel));
                        saveUserModel(userModel);
                      });
                    }
                  });
                },
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

  // miDireccion(context) {
  //   var size = MediaQuery.of(context).size;
  //   return Container(
  //       padding: EdgeInsets.all(smallPadding * 2),
  //       width: size.width,
  //       // height: size.height,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Color.fromRGBO(0, 0, 0, 0.1),
  //             blurRadius: 5.0, // soften the shadow
  //             spreadRadius: 1.0, //extend the shadow
  //             offset: Offset(
  //               0.0, // Move to right 10  horizontally
  //               3.0, // Move to bottom 10 Vertically
  //             ),
  //           )
  //         ],
  //       ),
  //       child: Column(
  //         children: [
  //           formDirection(),
  //         ],
  //       ));
  // }

  // formDirection() {
  //   return Form(
  //     key: null,
  //     child: Column(
  //       children: [
  //         EntradaTexto(
  //           estilo: inputPrimarystyle(
  //               context, Icons.location_on_outlined, 'Calle', null),
  //           tipoEntrada: TextInputType.name,
  //           textCapitalization: TextCapitalization.words,
  //           tipo: 'generic',
  //           onChanged: (value) {
  //             setState(() {
  //               name = value;
  //             });
  //           },
  //         ),
  //         EntradaTexto(
  //           estilo: inputPrimarystyle(
  //               context, Icons.location_on_outlined, 'Colonia', null),
  //           tipoEntrada: TextInputType.name,
  //           textCapitalization: TextCapitalization.words,
  //           tipo: 'generic',
  //           onChanged: (value) {
  //             setState(() {
  //               first_lastname = value;
  //             });
  //           },
  //         ),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: EntradaTexto(
  //                 estilo: inputPrimarystyle(
  //                     context, Icons.location_on_outlined, 'Núm Ext.', null),
  //                 tipoEntrada: TextInputType.name,
  //                 textCapitalization: TextCapitalization.words,
  //                 tipo: 'generic',
  //                 onChanged: (value) {
  //                   setState(() {
  //                     first_lastname = value;
  //                   });
  //                 },
  //               ),
  //             ),
  //             Expanded(
  //               child: EntradaTexto(
  //                 estilo: inputPrimarystyle(
  //                     context, Icons.location_on_outlined, 'Núm Int.', null),
  //                 tipoEntrada: TextInputType.name,
  //                 textCapitalization: TextCapitalization.words,
  //                 tipo: 'generic',
  //                 onChanged: (value) {
  //                   setState(() {
  //                     first_lastname = value;
  //                   });
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //         EntradaTexto(
  //           estilo: inputPrimarystyle(
  //               context, Icons.location_on_outlined, 'Código postal', null),
  //           tipoEntrada: TextInputType.name,
  //           textCapitalization: TextCapitalization.words,
  //           tipo: 'generic',
  //           onChanged: (value) {
  //             setState(() {
  //               first_lastname = value;
  //             });
  //           },
  //         ),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: EntradaTexto(
  //                 estilo: inputPrimarystyle(
  //                     context, Icons.location_on_outlined, 'Estado', null),
  //                 tipoEntrada: TextInputType.name,
  //                 textCapitalization: TextCapitalization.words,
  //                 tipo: 'generic',
  //                 onChanged: (value) {
  //                   setState(() {
  //                     first_lastname = value;
  //                   });
  //                 },
  //               ),
  //             ),
  //             Expanded(
  //               child: EntradaTexto(
  //                 estilo: inputPrimarystyle(
  //                     context, Icons.location_on_outlined, 'Municipio', null),
  //                 tipoEntrada: TextInputType.name,
  //                 textCapitalization: TextCapitalization.words,
  //                 tipo: 'generic',
  //                 onChanged: (value) {
  //                   setState(() {
  //                     first_lastname = value;
  //                   });
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //         EntradaTexto(
  //           lineasMax: 2,
  //           estilo: inputPrimarystyle(
  //               context, Icons.location_on_outlined, 'Referencia', null),
  //           tipoEntrada: TextInputType.name,
  //           textCapitalization: TextCapitalization.words,
  //           tipo: 'generic',
  //           onChanged: (value) {
  //             setState(() {
  //               first_lastname = value;
  //             });
  //           },
  //         ),
  //         SizedBox(height: medPadding),
  //         Padding(
  //           padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
  //           child: BotonRest(
  //               url: '$apiUrl/actualizar/usuario',
  //               method: 'post',
  //               formkey: formKey,
  //               arrayData: {
  //                 'name': name,
  //                 'first_lastname': first_lastname,
  //                 'second_lastname': second_lastname,
  //                 'mail': '$mail',
  //                 'password': '$password',
  //               },
  //               contenido: Text(
  //                 'Actualizar',
  //                 textAlign: TextAlign.center,
  //                 overflow: TextOverflow.fade,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //               // action: () => Navigator.push(context,
  //               //     MaterialPageRoute(builder: (context) => LoginPage())),
  //               errorStyle: TextStyle(
  //                 color: Colors.red[700],
  //                 fontWeight: FontWeight.w600,
  //               ),
  //               estilo: estiloBotonPrimary),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  tabMisTarjetas() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Mis tarjetas',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misTarjetas(context)),
        SizedBox(
          height: smallPadding * 2,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
          child: SimpleButtom(
            mainText: 'Agregar tarjeta',
            pressed: () => _displayDialog().then((value) => setState(() {
                  myCards = Object();
                })),
            // action: () => Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => LoginPage())),
            gcolor: gradientBlueDark,
          ),
        ),
      ],
    );
  }

  Future _displayDialog() {
    bool errorMessage = false;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) {
          String errorString = '';
          return StatefulBuilder(builder: (context, StateSetter setState) {
            void setError(dynamic error) {
              /* scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString()))); */

              setState(() {
                errorMessage = true;
                errorString = error.message.toString();
              });
              Navigator.pop(context);
              //print(error.toString());
            }

            return AlertDialog(
              // insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width /10, vertical: MediaQuery.of(context).size.height / 10),
              scrollable: true,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: smallPadding, vertical: smallPadding * 3),
              content: Container(
                width: MediaQuery.of(context).size.width / 3,
                // height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "AGREGAR NUEVA TARJETA",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'FjallaOne',
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              EntradaTexto(
                                tipoEntrada: TextInputType.name,
                                estilo: InputDecoration(
                                  labelText: 'Nombre',
                                  counterText: '',
                                ),
                                onSaved: (value) {
                                  setState(() {
                                    cardHolder = value;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    cardHolder = value;
                                  });
                                },
                              ),
                              /* EntradaTexto(
                                tipoEntrada: TextInputType.number,
                                estilo: InputDecoration(
                                  counterText: '',
                                  labelText: 'Codigo posttal',
                                ),
                                onSaved: (value) {
                                  setState(() {
                                    cp = value;
                                  });
                                },
                              ), */
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  CreditCardNumberInputFormatter()
                                ],
                                decoration: InputDecoration(
                                    counterText: '',
                                    counterStyle: TextStyle(fontSize: 0),
                                    labelText: 'Número de tarjeta'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    cardNumber = value;
                                  });
                                },
                                onChanged: (value) {
                                  if (value != "") {
                                    setState(() {
                                      toSendCardNumber = int.parse(value
                                          .replaceAll(new RegExp(r"\s+"), ""));
                                    });
                                  }
                                },
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: EntradaTexto(
                                      tipoEntrada: TextInputType.number,
                                      longMaxima: 2,
                                      tipo: 'number',
                                      estilo: InputDecoration(
                                          hintText: 'MM',
                                          labelText: 'Mes',
                                          counterText: ''),
                                      onSaved: (value) {
                                        if (value != "") {
                                          setState(() {
                                            month = int.parse(value);
                                          });
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          month = int.parse(value);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Expanded(
                                    child: EntradaTexto(
                                      tipoEntrada: TextInputType.number,
                                      longMaxima: 2,
                                      tipo: 'number',
                                      estilo: InputDecoration(
                                          hintText: 'AA',
                                          labelText: 'Año',
                                          counterText: ''),
                                      onSaved: (value) {
                                        setState(() {
                                          year = int.parse(value);
                                        });
                                      },
                                      onChanged: (value) {
                                        if (value != "") {
                                          setState(() {
                                            year = int.parse(value);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              EntradaTexto(
                                tipoEntrada: TextInputType.number,
                                tipo: 'number',
                                longMaxima: 5,
                                estilo: InputDecoration(
                                  hintText: '123',
                                  counterText: '',
                                  labelText: 'CVC',
                                ),
                                onSaved: (value) {
                                  setState(() {
                                    cvc = int.parse(value);
                                  });
                                },
                                onChanged: (value) {
                                  if (value != "") {
                                    setState(() {
                                      cvc = int.parse(value);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        )),
                    errorMessage
                        ? Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                                child: Text(
                              errorString,
                              style: TextStyle(color: Colors.red),
                            )))
                        : Container(),
                    SizedBox(
                      height: smallPadding * 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("images/openpayLogo.png"),
                          height: 50,
                        ),
                        Image(
                          image: AssetImage("images/cardBrands.png"),
                          height: 50,
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        errorSession
                            ? Text('Ha ocurrido un error',
                                style: estiloErrorStr)
                            : Flexible(
                                child: InkWell(
                                child: Container(
                                  width: 200,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  decoration: toSendCardNumber.toString() !=
                                              "" &&
                                          toSendCardNumber.toString() != "" &&
                                          cardHolder.toString() != "" &&
                                          year.toString() != "" &&
                                          month.toString() != "" &&
                                          cvc.toString() != "" &&
                                          toSendCardNumber != null &&
                                          toSendCardNumber != null &&
                                          cardHolder != null &&
                                          year != null &&
                                          month != null &&
                                          cvc != null
                                      ? estiloBotonPrimary
                                      : estiloBotonDisabled,
                                  child: Text('Agregar tarjeta',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal)),
                                ),
                                onTap: () {
                                  if (toSendCardNumber.toString() != "" &&
                                      toSendCardNumber.toString() != "" &&
                                      cardHolder.toString() != "" &&
                                      year.toString() != "" &&
                                      month.toString() != "" &&
                                      cvc.toString() != "" &&
                                      toSendCardNumber != null &&
                                      toSendCardNumber != null &&
                                      cardHolder != null &&
                                      year != null &&
                                      month != null &&
                                      cvc != null) {
                                    showLoadingDialog(
                                        context,
                                        "Guardando tarjeta",
                                        "Espera un momento...");
                                    openpay
                                        .createToken(
                                      CardInfo(
                                        toSendCardNumber.toString(),
                                        cardHolder,
                                        year.toString(),
                                        month.toString(),
                                        cvc.toString(),
                                      ),
                                    )
                                        .then((value) {
                                      setState(() {
                                        cardToken = value.id.toString();
                                        saveCard();
                                      });
                                    }).catchError((error, stackTrace) {
                                      Navigator.pop(context);
                                      showErrorDialog(
                                          context,
                                          "Parece que hay un error",
                                          error.toString());
                                    });
                                  }
                                },
                              )
                                /* BotonRestTest(
                                    primerAction: () {},
                                    formkey: _formKey,
                                    token: sharedPrefs.clientToken,
                                    url: '$apiUrl/crear/tarjeta',
                                    method: 'post',
                                    arrayData: {
                                      "card_number": toSendCardNumber,
                                      "holder_name": ,
                                      "expiration_year": year,
                                      "expiration_month": month,
                                      "cvv2": cvc,
                                      "device_session_id": _deviceSessionId
                                    },
                                    showSuccess: true,
                                    action: (value) {
                                      Navigator.pop(context);
                                    },
                                    contenido: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: smallPadding),
                                      child: Text('Agregar',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                    estilo: estiloBotonPrimary), */
                                ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  misTarjetas(context) {
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
            PaymentFunctions(key: ValueKey<Object>(myCards), module: "cards"),
          ],
        ));
  }

  tabPedidoEspecial() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Pedidos especiales',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Text(
          '¿Te hace falta un producto?',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        Text(
          'Accede los datos y solicita una cotización.',
          style: TextStyle(
              color: Colors.black45, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: miPedido(context)),
      ],
    );
  }

  miPedido(context) {
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
            formPedido(),
          ],
        ));
  }

  formPedido() {
    return Form(
      key: formKeyPedido,
      child: Column(
        children: [
          EntradaTexto(
            longMinima: 3,
            estilo: inputPrimarystyle(context, Icons.medical_services_outlined,
                'Nombre del prodcuto', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'texto',
            onChanged: (value) {
              setState(() {
                productName = value;
              });
            },
          ),
          EntradaTexto(
            longMinima: 3,
            estilo: inputPrimarystyle(context, Icons.info_outline,
                'Descripción / Sustancia activa', null),
            tipoEntrada: TextInputType.name,
            lineasMax: 2,
            textCapitalization: TextCapitalization.words,
            tipo: 'texto',
            onChanged: (value) {
              setState(() {
                productDescription = value;
              });
            },
          ),
          EntradaTexto(
            longMinima: 3,
            estilo: inputPrimarystyle(
                context, Icons.info_outline, 'Marca / Laboratorio', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'texto',
            onChanged: (value) {
              setState(() {
                productBrand = value;
              });
            },
          ),
          EntradaTexto(
            longMinima: 1,
            estilo: inputPrimarystyle(context, Icons.info_outline,
                'Número de piezas requeridas', null),
            tipoEntrada: TextInputType.number,
            textCapitalization: TextCapitalization.words,
            tipo: 'numeroINT',
            onChanged: (value) {
              setState(() {
                productQuantity = int.parse(value);
              });
            },
          ),
          EntradaTexto(
            estilo: inputPrimarystyle(
                context, Icons.phone_outlined, 'Teléfono', null),
            tipoEntrada: TextInputType.phone,
            textCapitalization: TextCapitalization.words,
            tipo: 'telefono',
            onChanged: (value) {
              setState(() {
                contactPhone = int.parse(value);
              });
            },
          ),
          EntradaTexto(
            estilo:
                inputPrimarystyle(context, Icons.mail_outline, 'Correo', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            tipo: 'correo',
            onChanged: (value) {
              setState(() {
                contactMail = value;
              });
              //print(contactMail);
            },
          ),
          SizedBox(height: medPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
            child: BotonRestTest(
                primerAction: () {
                  if (formKeyPedido.currentState.validate()) {
                    formKeyPedido.currentState.save();
                  }
                },
                formkey: formKeyPedido,
                token: sharedPrefs.clientToken,
                url: '$apiUrl/pedido/especial',
                method: 'post',
                arrayData: {
                  "nombre_producto": productName,
                  "descripcion_producto": productDescription,
                  "marca": productBrand,
                  "piezas_requeridas": productQuantity,
                  "telefono": contactPhone,
                  "correo": contactMail
                },
                action: (value) {
                  //print(value);
                },
                showSuccess: true,
                contenido: Text(
                  'Enviar cotización especial',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // action: () => Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => LoginPage())),
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

class TabCompras extends StatefulWidget {
  TabCompras({Key key}) : super(key: key);

  @override
  _TabComprasState createState() => _TabComprasState();
}

class _TabComprasState extends State<TabCompras> {
  var jsonCompras = [];
  RestFun restFun = RestFun();
  OrdenModel ordenModel = OrdenModel();

  String errorStr;
  bool load = true;
  bool error = false;
  bool fav = false;

  var orden;

  @override
  void initState() {
    super.initState();
    jsonCompras = jsonDecode(dummyCompras);
    sharedPrefs.init().then((value) => gerCompras());
  }

  gerCompras() async {
    await restFun
        .restService(null, '$apiUrl/ver/ordenes-usuario',
            sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp)[1];
        setState(() {
          orden = dataResp['orders'];
          // print(orden[0]['cliente']);
          // ordenModel = OrdenModel.fromJson(dataResp[1]);
          // print(ordenModel.toString());
          load = false;
        });
      } else {
        setState(() {
          load = false;
          error = true;
          errorStr = value['message'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return load
        ? bodyLoad(context)
        : error
            ? errorWidget(errorStr, context)
            : Container(
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
                    child: tabCompras(),
                  ),
                  // footer(context),
                ]),
              );
  }

  tabCompras() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Mis compras',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: misCompras(context)),
      ],
    );
  }

  misCompras(context) {
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
              itemCount: orden.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return compra(orden[index]);
              },
            ),
          ],
        ));
  }

  compra(comprajson) {
    Widget status;
    switch (comprajson['estatus_de_envio']) {
      case 'delivered':
        status = Row(
          children: [
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(100)),
            ),
            SizedBox(
              width: 3,
            ),
            Text('Entregado',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black54))
          ],
        );
        break;
      case 'on_the_way':
        status = Row(
          children: [
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(100)),
            ),
            SizedBox(
              width: 3,
            ),
            Text('En camino',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black54))
          ],
        );
        break;
      case 'preparing':
        status = Row(
          children: [
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(100)),
            ),
            SizedBox(
              width: 3,
            ),
            Flexible(
              child: Text('En preparación',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black54)),
            )
          ],
        );

        break;
      default:
        status = Row(
          children: [
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(100)),
            ),
            SizedBox(
              width: 3,
            ),
            Flexible(
              child: Text('En preparación',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black54)),
            )
          ],
        );
        break;
    }
    return Container(
        padding: EdgeInsets.symmetric(vertical: smallPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flexible(
                //   flex: 2,
                //   child: getAsset(comprajson['img'], 70),
                // ),
                Flexible(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      status,
                      SizedBox(
                        height: smallPadding * 2,
                      ),
                      RichText(
                        text: new TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87),
                          children: <TextSpan>[
                            new TextSpan(
                              text: 'Número de compra: ',
                            ),
                            new TextSpan(
                                text: '${comprajson['id_de_orden']}',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: smallPadding / 2),
                      RichText(
                        text: new TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87),
                          children: <TextSpan>[
                            new TextSpan(
                              text: 'Fecha de compra: ',
                            ),
                            new TextSpan(
                                text: '${comprajson['fecha_de_creacion']}',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: smallPadding * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87),
                              children: <TextSpan>[
                                new TextSpan(
                                  text: 'Productos: ',
                                ),
                                new TextSpan(
                                    text:
                                        '${comprajson['cantidad_de_productos']}',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ),
                          RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87),
                              children: <TextSpan>[
                                new TextSpan(
                                  text: 'Total: ',
                                ),
                                new TextSpan(
                                    text: '\$${comprajson['monto_total']}',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: smallPadding * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Text(
                          //   "\$${comprajson['price']} MXN",
                          //   style: TextStyle(
                          //       color: Theme.of(context).primaryColor,
                          //       fontWeight: FontWeight.w700),
                          // ),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context,
                                '/miCuenta/compra/' +
                                    comprajson['id_de_orden']),
                            child: Text(
                              'Ver detalles',
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: bgGrey,
              thickness: 2,
            )
          ],
        ));
  }
}
