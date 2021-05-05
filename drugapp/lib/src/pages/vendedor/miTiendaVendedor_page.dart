import 'dart:convert';
import 'dart:io';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/pages/vendedor/Tienda%20status/tiendaFalse_page.dart';
import 'package:drugapp/src/pages/vendedor/Tienda%20status/tiendaProceso_page.dart';
import 'package:drugapp/src/pages/vendedor/Tienda%20status/tiendaRechazada_page.dart';
import 'package:drugapp/src/pages/vendedor/tabProductos_page.dart';
import 'package:drugapp/src/pages/vendedor/tabVentas_page.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawerVendedor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class MiTiendaVendedor extends StatefulWidget {
  MiTiendaVendedor({Key key}) : super(key: key);

  @override
  _MiTiendaVendedorState createState() => _MiTiendaVendedorState();
}

class _MiTiendaVendedorState extends State<MiTiendaVendedor> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name;
  String first_lastname;
  String second_lastname;
  String mail;
  String password;
  UserModel userModel = UserModel();
  var mediaData;
  Image pickedImage;
  var imagePath;
  String base64Image;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _displayDialog());
    // sharedPrefs.init();
    // var jsonUser = jsonDecode(sharedPrefs.clientData);
    // userModel = UserModel.fromJson(jsonUser);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBarVendedor(
        drawerMenu: true,
        screenWidht: MediaQuery.of(context).size.width,
        body: bodyTienda('rechazada'),
        title: "Mi tienda");
  }

  _displayDialog() {
    bool errorMessage = false;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          String errorString = '';
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            void setError(dynamic error) {
              /* scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString()))); */

              setState(() {
                errorMessage = true;
                errorString = error.message.toString();
              });
              Navigator.pop(context);
              print(error.toString());
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
                    Flexible(
                      child: Text(
                        "AVISO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'FjallaOne',
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 30.0, right: 30.0, top: smallPadding * 3),
                      child: Text(
                          'Te recordamos que está escrtictamente prohibido vender productos popiedad del sector salud, caducados, reetiquetados, en mal estado, asi como servicios no autorizados por las autoridades. Evita multas y sanciones.',
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: smallPadding * 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        BotonSimple(
                            action: () => Navigator.pop(context),
                            contenido: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: smallPadding * 2),
                              child: Text('Aceptar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal)),
                            ),
                            estilo: estiloBotonPrimary),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  bodyTienda(String status) {
    var size = MediaQuery.of(context).size;
    switch (status) {
      case 'false':
        return DefaultTabController(
          length: 1,
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
                          horizontal: size.width > 1100
                              ? size.width / 3
                              : medPadding * .5,
                          vertical: medPadding * 1.5),
                      color: bgGrey,
                      width: size.width,
                      child: TabFalse(),
                    ),
                    footerVendedor(context),
                  ]),
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
                      text: 'Mi tienda',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case 'progress':
        return DefaultTabController(
          length: 1,
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
                          horizontal: size.width > 1100
                              ? size.width / 3
                              : medPadding * .5,
                          vertical: medPadding * 1.5),
                      color: bgGrey,
                      width: size.width,
                      child: TabProceso(),
                    ),
                    footerVendedor(context),
                  ]),
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
                      text: 'Mi tienda',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;
        case 'rechazada':
         return DefaultTabController(
          length: 1,
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
                          horizontal: size.width > 1100
                              ? size.width / 3
                              : medPadding * .5,
                          vertical: medPadding * 1.5),
                      color: bgGrey,
                      width: size.width,
                      child: TabRechazada(),
                    ),
                    footerVendedor(context),
                  ]),
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
                      text: 'Mi tienda',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case 'true':
        return DefaultTabController(
          length: 3,
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
                          horizontal: size.width > 1100
                              ? size.width / 3
                              : medPadding * .5,
                          vertical: medPadding * 1.5),
                      color: bgGrey,
                      width: size.width,
                      child: tabMiCuenta(),
                    ),
                    footerVendedor(context),
                  ]),
                  TabProductos(),
                  TabVentas(),
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
                      text: 'Mi tienda',
                    ),
                    Tab(
                      text: 'Productos',
                    ),
                    Tab(
                      text: 'Ventas',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
    }
  }

  tabProgress() {
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
        Text(
          'Status',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: miTienda(context)),
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
        Container(child: miTienda(context)),
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
          child: misDocsok(context),
        ),
      ],
    );
  }

  tabMiCuenta() {
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
        Text(
          'Datos de mi tienda',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: miTienda(context)),
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
          child: misDocsok(context),
        ),
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
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    // final imgBase64Str = await kIsWeb
    //     ? networkImageToBase64(image.path)
    //     : mobileb64(File(image.path));
    var imgBase64Str;
    if (kIsWeb) {
      http.Response response = await http.get(Uri.parse(image.path));
      final bytes = response?.bodyBytes;
      imgBase64Str = base64Encode(bytes);
    } else {
      List<int> imageBytes = await File(image.path).readAsBytes();
      imgBase64Str = base64Encode(imageBytes);
    }
    setState(() {
      imagePath = image;
      base64Image = imgBase64Str.toString();
    });
  }

  miTienda(context) {
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
                  tag: "store_picture",
                  child: InkWell(
                    onTap: () async {
                      await pickImage();
                      setState(() {});
                    },
                    child: CircleAvatar(
                      backgroundImage: userModel.imgUrl == null
                          ? AssetImage('images/logoDrug.png')
                          : NetworkImage(userModel.imgUrl),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: smallPadding),
            Text(
              'Toca para cambiar el logo de tu tienda',
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
                context, Icons.store_outlined, 'Nombre comercial', null),
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
                context, Icons.person_outline, 'Nombre del propietario', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'nombre',
            onChanged: (value) {
              setState(() {
                first_lastname = value;
              });
            },
          ),
          EntradaTexto(
            valorInicial: userModel.second_lastname,
            estilo:
                inputPrimarystyle(context, Icons.store_outlined, 'RFC', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'nombre',
            onChanged: (value) {
              setState(() {
                second_lastname = value;
              });
            },
          ),
          EntradaTexto(
            valorInicial: userModel.second_lastname,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Moral/física', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'nombre',
            onChanged: (value) {
              setState(() {
                second_lastname = value;
              });
            },
          ),
          EntradaTexto(
            valorInicial: userModel.mail.toString(),
            estilo: inputPrimarystyle(
                context, Icons.email_outlined, 'Correo oficial', null),
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
            valorInicial: userModel.second_lastname,
            estilo: inputPrimarystyle(
                context, Icons.store_outlined, 'Giro del negocio', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'nombre',
            onChanged: (value) {
              setState(() {
                second_lastname = value;
              });
            },
          ),
          SizedBox(height: medPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: medPadding * 2),
            child: BotonRest(
                url: '$apiUrl/registro/cliente',
                method: 'post',
                formkey: formKey,
                arrayData: {
                  'name': name,
                  'first_lastname': first_lastname,
                  'second_lastname': second_lastname,
                  'mail': '$mail',
                  'password': '$password',
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

  misDocsok(context) {
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
                action: () => launchURL('https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                estilo: estiloBotonSecundary),
          ),
        ],
      ),
    );
  }
}
