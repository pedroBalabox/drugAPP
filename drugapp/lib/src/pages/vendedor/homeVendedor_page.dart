import 'dart:convert';
import 'dart:io';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawerVendedor_widget.dart';
import 'package:drugapp/src/widget/input_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class MiCuentaVendedor extends StatefulWidget {
  MiCuentaVendedor({Key key}) : super(key: key);

  @override
  _MiCuentaVendedorState createState() => _MiCuentaVendedorState();
}

class _MiCuentaVendedorState extends State<MiCuentaVendedor> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name;
  String first_lastname;
  String second_lastname;
  String mail;
  String password;
  String phone;
  UserModel userModel = UserModel();
  var mediaData;
  Image pickedImage;
  var imagePath;
  String base64Image;
  bool load = true;

  @override
  void initState() {
    super.initState();
    sharedPrefs.init().then((value) {
      var jsonUser = jsonDecode(sharedPrefs.partnerUserData);
      userModel = UserModel.fromJson(jsonUser);
      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBarVendedor(
        drawerMenu: true,
        screenWidht: MediaQuery.of(context).size.width,
        body: bodyCuenta(),
        title: "Mi cuenta");
  }

  bodyCuenta() {
    var size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width > 700 ? size.width / 3 : medPadding * .5,
            vertical: medPadding * 1.5),
        color: bgGrey,
        width: size.width,
        child: load ? CircularProgressIndicator() : tabMiCuenta(),
      ),
      footerVendedor(context),
    ]);
  }

  tabMiCuenta() {
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
        Container(child: miCuenta(context)),
        SizedBox(height: medPadding / 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
          child: BotonSimple(
            action: () =>
                Navigator.pushNamed(context, '/farmacia/cambiar-contraseña/'),
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
      ],
    );
  }

  Future<String> mobileb64(image) async {
    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
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
                child: InkWell(
                  onTap: () => pickImage(),
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
            valorInicial: userModel.second_lastname,
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
            valorInicial: userModel.mail.toString(),
            estilo:
                inputPrimarystyle(context, Icons.mail_outline, 'Correo', null),
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
                token: sharedPrefs.partnerUserToken,
                url: '$apiUrl/actualizar/usuario',
                showSuccess: true,
                method: 'post',
                formkey: formKey,
                arrayData: {
                  "user_id": userModel.user_id,
                  "name": name,
                  "first_lastname": first_lastname,
                  "second_lastname": second_lastname,
                  "password": null,
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
                          sharedPrefs.partnerUserToken, 'get')
                      .then((value) {
                    if (value['status'] == 'server_true') {
                      var jsonUser = jsonDecode(value['response']);
                      userModel = UserModel.fromJson(jsonUser[1]);
                      setState(() {
                        savePartnerModel(userModel);
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
}
