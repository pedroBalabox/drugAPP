import 'dart:convert';
import 'dart:io';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/pages/vendedor/Tienda%20status/tiendaAceptada_page.dart';
import 'package:drugapp/src/pages/vendedor/Tienda%20status/tiendaBlock_page.dart';
import 'package:drugapp/src/pages/vendedor/Tienda%20status/tiendaFalse_page.dart';
import 'package:drugapp/src/pages/vendedor/Tienda%20status/tiendaProceso_page.dart';
import 'package:drugapp/src/pages/vendedor/Tienda%20status/tiendaRechazada_page.dart';
import 'package:drugapp/src/pages/vendedor/tabProductos_page.dart';
import 'package:drugapp/src/pages/vendedor/tabVentas_page.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawerVendedor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import 'Tienda status/tiendaDraft_page.dart';

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
  RestFun rest = RestFun();

  String statusTienda;

  var jsonTienda;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _displayDialog());
    sharedPrefs.init().then((value) {
      var jsonUser = jsonDecode(sharedPrefs.partnerUserData);
      userModel = UserModel.fromJson(jsonUser);
      getTienda();
    });

    // var jsonUser = jsonDecode(sharedPrefs.clientData);
    // userModel = UserModel.fromJson(jsonUser);
  }

  getTienda() {
    rest
        .restService('', '${urlApi}obtener/mi-farmacia',
            sharedPrefs.partnerUserToken, 'get')
        .then((value) {
      print('-----');
      setState(() {
        jsonTienda = jsonDecode(value['response']);
        if (jsonTienda.length == 1) {
          statusTienda = 'false';
        } else {
          statusTienda = jsonTienda[1]['estatus'];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBarVendedor(
        drawerMenu: true,
        screenWidht: MediaQuery.of(context).size.width,
        body: jsonTienda == null ? bodyLoad(context) : bodyTienda(statusTienda),
        title: "Mi tienda");
  }

  // bodyLoad() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height,
  //     width: MediaQuery.of(context).size.width,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Container(
  //           child: CircularProgressIndicator(),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
                          'Te recordamos que está estrictamente prohibido vender productos popiedad del sector salud, caducados, reetiquetados, en mal estado, así como servicios no autorizados por las autoridades. Evita multas y sanciones.',
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
      case 'draft':
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
                      child: TabDraft(
                        miTienda: jsonTienda,
                      ),
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
      case 'waiting_for_review':
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
                      child: TabProceso(
                        miTienda: jsonTienda,
                      ),
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
      case 'rejected':
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
                      child: TabRechazada(
                        miTienda: jsonTienda,
                      ),
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
      case 'blocked':
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
                      child: TabBlock(
                        miTienda: jsonTienda,
                      ),
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
      case 'approved':
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
                      child: TabAceptada(
                        miTienda: jsonTienda,
                      ),
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
                action: () => launchURL(
                    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
                estilo: estiloBotonSecundary),
          ),
        ],
      ),
    );
  }
}
