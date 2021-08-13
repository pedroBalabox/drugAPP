import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/Lobby/validate_page.dart';
import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/pages/vendedor/loginVendedor_page.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/navigation_handler.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// var itemsMenu =
//     '[{"icon": 61703, "title": "Inicio", "action": "/"}, {"icon": 62466, "title": "Mi cuenta", "action": "/miCuenta"}, {"icon": 57948, "title": "Favoritos", "action": "/favoritos"}, {"icon": 62445, "title": "Mi tienda", "action": "/miTienda"}, {"icon": 61821, "title": "Carrito", "action": "/carrito"}, {"icon": 63627, "title": "Cerrar sesión", "action": "/logout"}]';

var itemsMenu =
    '[{"icon": 61703, "title": "Categorías", "action": "/categorias"}, {"icon": 62466, "title": "Productos", "action": "/productos"}, {"icon": 57948, "title": "Favoritos", "action": "/favoritos"}, {"icon": 62445, "title": "Mi cuenta", "action": "/miCuenta"}, {"icon": 61821, "title": "Carrito", "action": "/carrito"}, {"icon": 63627, "title": "Cerrar sesión", "action": "/logout"}]';

var itemsBottomMenu =
    '[{"icon": 61703, "title": "Ofertas", "action": "/productos"}, {"icon": 62466, "title": "Pedidos especiales", "action": "/productos"}, {"icon": 57948, "title": "Tiendas", "action": "/tiendas"}, {"icon": 62445, "title": "Pregunstas frecuentes", "action": "/miTienda"}, {"icon": 61821, "title": "Carrito", "action": "/carrito"}, {"icon": 63627, "title": "Cerrar sesión", "action": "/logout"}]';

var itemsMenuMobile =
    '[{"icon": 62445, "title": "Mi cuenta", "action": "/miCuenta", "url": "false"}, {"icon": 61821, "title": "Carrito", "action": "/carrito", "url": "false"}, {"icon": 61828, "title": "Productos", "action": "/productos", "url": "false"}, {"icon": 61828, "title": "Ofertas", "action": "/productos", "url": "false"}, {"icon": 61239, "title": "Categorías", "action": "/categorias", "url": "false"}, {"icon": 62466, "title": "Pedidos especiales", "action": "https://api.whatsapp.com/send?phone=525567026709&text=Quiero%20realizar%20un%20Pedido", "url": "true"}, {"icon": 57948, "title": "Tiendas", "action": "/tiendas", "url": "false"}, {"icon": 58173, "title": "Preguntas frecuentes", "action": "/preguntas-frecuentes", "url": "false"}, {"icon": 61821, "title": "Atención pacientes", "action": "https://api.whatsapp.com/send?phone=525567026709&text=Quiero%20realizar%20un%20Pedido", "url": "true"}, {"icon": 61821, "title": "Soporte pedidos", "action": "https://api.whatsapp.com/send?phone=525567026709&text=Quiero%20realizar%20un%20Pedido", "url": "true"}, {"icon": 63627, "title": "Cerrar sesión", "action": "/logout", "url": "false"}]';

class ResponsiveAppBar extends StatefulWidget {
  final screenWidht;
  final Widget body;
  final String title;
  final bool drawerMenu;
  final UserModel userModel;
  final dynamic bottomNavigationBar;
  final bool extendedBar;

  ResponsiveAppBar(
      {Key key,
      this.screenWidht,
      this.body,
      this.title,
      this.drawerMenu = false,
      this.userModel,
      this.bottomNavigationBar,
      this.extendedBar = false})
      : super(key: key);

  @override
  _ResponsiveAppBarState createState() => _ResponsiveAppBarState();
}

class _ResponsiveAppBarState extends State<ResponsiveAppBar> {
  var jsonMenu = jsonDecode(itemsMenu.toString());
  CatalogBloc _catalogBloc = CatalogBloc();
  String query;

  // UserBloc _userBloc = UserBloc();

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    jsonMenu = jsonDecode(itemsMenu.toString());
    validateToken();
    //  validateClientToken(context).then((value) {
    //   if (value == 'null') {
    //     CJNavigator.navigator.push(context, '/login');
    //   } else {
    //     validateClient(context, value).then((value) {
    //       print("Resultado: " + value.toString());
    //       if (!value) {
    //         CJNavigator.navigator.push(context, '/login');
    //       }
    //     });
    //   }
    // });
    // sharedPrefs.init().then((value) {
    //   getUserData();
    // });
  }

  validateToken() async {
    await validateClientToken().then((value) {
      if (!value) {
        Navigator.pushNamed(context, '/login').then((value) => setState(() {}));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.screenWidht > 1000
            ? AppBar(
                // shadowColor: Colors.transparent,
                bottom: widget.extendedBar
                    ? PreferredSize(
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/productos')
                                          .then((value) => setState(() {})),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Ofertas'.toString().toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => launch(
                                      'https://api.whatsapp.com/send?phone=525567026709&text=Quiero%20realizar%20un%20Pedido'),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Pedidos especiales'
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/tiendas')
                                          .then((value) => setState(() {})),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Tiendas'.toString().toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pushNamed(
                                          context, '/preguntas-frecuentes')
                                      .then((value) => setState(() {})),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Preguntas frecuentes'
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => launch(
                                      'https://api.whatsapp.com/send?phone=525567026709&text=Quiero%20realizar%20un%20Pedido'),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Atención pacientes'
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => launch(
                                      'https://api.whatsapp.com/send?phone=525567026709&text=Quiero%20realizar%20un%20Pedido'),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Soporte pedidos'
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        preferredSize: Size.fromHeight(20.0))
                    : null,
                elevation: 5,
                toolbarHeight: widget.extendedBar ? 130 : 80,
                backgroundColor: bgGrey,
                // flexibleSpace: Row(
                //   children: [
                //     Flexible(
                //         flex: 4,
                //         child: Row(
                //           children: [
                //             Container(
                //               padding: EdgeInsets.all(0),
                //               height: 70,
                //               width: 70,
                //               child: getAsset('logoDrug.png', 0.0),
                //             ),
                //           ],
                //         )),
                //     Flexible(
                //       flex: 3,
                //       child: Text('hola'),
                //     )
                //   ],
                // )
                title: Container(
                  child: Row(
                    children: [
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false),
                        child: Container(
                          padding: EdgeInsets.all(0),
                          height: 70,
                          width: 70,
                          child: getAsset('logoDrug.png', 0.0),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      widget.title != null
                          ? Flexible(
                              child: Text(widget.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black)))
                          // : Container(),
                          : Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Flexible(
                                  //   flex: 1,
                                  //   child: Container(),
                                  // ),
                                  Flexible(
                                    flex: 10,
                                    child: Container(
                                      height: 35,
                                      child: TextField(
                                        onChanged: (value) {
                                          if (value != null ||
                                              value != '' ||
                                              value != ' ') {
                                            query = value;
                                          }
                                        },
                                        textInputAction: TextInputAction.search,
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        decoration: InputDecoration(
                                            // prefixIcon: Icon(Icons.search),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                            hintStyle: TextStyle(),
                                            hintText:
                                                'Búsca por nombre, sintomas y más...',
                                            fillColor: Colors.white,
                                            hoverColor: Colors.white,
                                            filled: true),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: BotonSimple(
                                          contenido: Icon(
                                            CupertinoIcons.search,
                                            color: Colors.white,
                                          ),
                                          action: () {
                                            Navigator.pushNamed(context,
                                                    '/productos-query/$query/')
                                                .then(
                                                    (value) => setState(() {}));
                                          },
                                          estilo: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.1),
                                                  blurRadius:
                                                      5.0, // soften the shadow
                                                  spreadRadius:
                                                      1.0, //extend the shadow
                                                  offset: Offset(
                                                    0.0, // Move to right 10  horizontally
                                                    3.0, // Move to bottom 10 Vertically867
                                                  ),
                                                )
                                              ],
                                              color: Theme.of(context)
                                                  .primaryColor))),
                                  Flexible(
                                    flex: 1,
                                    child: Container(),
                                  )
                                ],
                              ),
                            ),
                      // Flexible(flex: 1, child: Container())
                    ],
                  ),
                ),
                actions: [
                  Container(
                    width: 670,
                    alignment: Alignment.bottomCenter,
                    child: ListView.builder(
                      itemCount: jsonMenu.length,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      /*  shrinkWrap: true, */
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: InkWell(
                              onTap: () {
                                if (jsonMenu[index]['action'] == "/logout") {
                                  logoutUser()
                                      .then((value) =>
                                          Navigator.pushReplacementNamed(
                                              context, '/login'))
                                      .then((value) => setState(() {}));
                                } else if (jsonMenu[index]['action'] ==
                                    '/miTienda-EDITADO') {
                                  bool tokenVendor;
                                  sharedPrefs.init().then((value) {
                                    tokenVendor =
                                        sharedPrefs.partnerUserToken == ''
                                            ? false
                                            : true;

                                    if (tokenVendor) {
                                      RestFun rest = RestFun();
                                      var jsonTienda;
                                      rest
                                          .restService(
                                              '',
                                              '${urlApi}obtener/mi-farmacia',
                                              sharedPrefs.partnerUserToken,
                                              'get')
                                          .then((value) {
                                        if (value['status'] == 'server_true') {
                                          setState(() {
                                            jsonTienda =
                                                jsonDecode(value['response']);
                                          });
                                          Navigator.pushNamed(
                                            context,
                                            ProductView.routeName,
                                            arguments:
                                                ProductosDetallesArguments({
                                              "farmacia_id": jsonTienda[1]
                                                  ['farmacia_id'],
                                              "userQuery": null,
                                              "favoritos": false,
                                              "availability": null,
                                              "stock": "available",
                                              "priceFilter": null,
                                              "myLabels": [],
                                              "myCats": [],
                                              "tienda": jsonTienda[1],
                                              "title": "Mi tienda"
                                            }),
                                          ).then((value) => setState(() {}));
                                        } else {
                                          //  Navigator.pushNamed(context, '/farmacia/login/miTienda')
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginVendedor(
                                                        miTienda: true,
                                                      )))
                                              .then((value) => setState(() {}));
                                        }
                                      });
                                    } else {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginVendedor(
                                                    miTienda: true,
                                                  )))
                                          .then((value) => setState(() {}));
                                    }
                                  });
                                } else if (jsonMenu[index]['action'] == '/') {
                                  CJNavigator.navigator
                                      .push(context, '/')
                                      .then((value) => setState(() {}));
                                } else {
                                  if (Uri.base.path !=
                                      jsonMenu[index]['action']) {
                                    Navigator.pushNamed(
                                            context, jsonMenu[index]['action'])
                                        .then((value) => setState(() {}));
                                  }
                                }
                              },
                              child: jsonMenu[index]['title'] == 'Carrito'
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10, left: 10),
                                          child: Text(
                                            jsonMenu[index]['title']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        CircleAvatar(
                                            radius: 11,
                                            child: StreamBuilder<
                                                    List<ProductoModel>>(
                                                initialData: [],
                                                stream:
                                                    _catalogBloc.catalogStream,
                                                builder: (context, snapshot) {
                                                  int sum = snapshot.data
                                                      .map((expense) =>
                                                          expense.cantidad)
                                                      .fold(
                                                          0,
                                                          (prev, amount) =>
                                                              prev + amount);
                                                  return Text(
                                                    sum.toString(),
                                                    style: TextStyle(
                                                      fontSize: 9.0,
                                                    ),
                                                  );
                                                })),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        jsonMenu[index]['title']
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 13),
                                      ),
                                    )),
                        );
                      },
                    ),
                  )
                ],
              )
            : AppBar(
                elevation: 15,
                // backgroundColor: Theme.of(context).accentColor,
                backgroundColor: bgGrey,
                title: widget.title != null
                    ? Text(widget.title, style: TextStyle(color: Colors.black))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 6,
                            child: Container(
                              height: 35,
                              child: TextField(
                                onChanged: (value) {
                                  if (value != null ||
                                      value != '' ||
                                      value != ' ') {
                                    query = value;
                                  }
                                },
                                textInputAction: TextInputAction.search,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.search),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(0)),
                                    hintStyle: TextStyle(),
                                    hintText:
                                        'Búsca por nombre sintomas y más...',
                                    hoverColor: Colors.white,
                                    fillColor: Colors.white,
                                    filled: true),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 1,
                              child: BotonSimple(
                                  contenido: Icon(
                                    CupertinoIcons.search,
                                    color: Colors.white,
                                  ),
                                  action: () {
                                    Navigator.pushNamed(
                                            context, '/productos-query/$query/')
                                        .then((value) => setState(() {}));
                                  },
                                  estilo: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      blurRadius: 5.0, // soften the shadow
                                      spreadRadius: 1.0, //extend the shadow
                                      offset: Offset(
                                        0.0, // Move to right 10  horizontally
                                        3.0, // Move to bottom 10 Vertically867
                                      ),
                                    )
                                  ], color: Theme.of(context).primaryColor))),
                          Container()
                        ],
                      ),
                actions: [
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Stack(
                  //     alignment: Alignment.topRight,
                  //     children: [
                  //       Icon(
                  //         Icons.shopping_cart_outlined,
                  //         color: Colors.white,
                  //         size: 30,
                  //       ),
                  //       CircleAvatar(
                  //           radius: 7,
                  //           child: StreamBuilder<List<ProductoModel>>(
                  //               initialData: [],
                  //               stream: _catalogBloc.catalogStream,
                  //               builder: (context, snapshot) {
                  //                 int sum = snapshot.data
                  //                     .map((expense) => expense.cantidad)
                  //                     .fold(0, (prev, amount) => prev + amount);
                  //                 return Text(
                  //                   sum.toString(),
                  //                   textAlign: TextAlign.center,
                  //                   style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     fontSize: 7.0,
                  //                   ),
                  //                 );
                  //               }))
                  //     ],
                  //   ),
                  // ),
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: 50,
                      width: 55,
                      child: getAsset('logoDrug.png', 0.0),
                    ),
                  )
                ],
              ),
        drawer: widget.screenWidht > 1000
            ? null
            : widget.drawerMenu
                ? DrawerUser()
                : null,
        body: widget.body,
        bottomNavigationBar: widget.bottomNavigationBar);
  }
}

class DrawerUser extends StatefulWidget {
  DrawerUser({Key key}) : super(key: key);

  @override
  _DrawerUserState createState() => _DrawerUserState();
}

class _DrawerUserState extends State<DrawerUser> {
  UserModel userModel = UserModel();
  CatalogBloc _catalogBloc = CatalogBloc();

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    sharedPrefs.init().then((value) {
      getUserData();
    });
  }

  @override
  void dispose() {
    _catalogBloc.dispose();
    super.dispose();
  }

  getUserData() {
    var jsonUser = jsonDecode(sharedPrefs.clientData);
    setState(() {
      userModel = UserModel.fromJson(jsonUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    var jsonMenu = jsonDecode(itemsMenuMobile.toString());
    MediaQueryData queryData = MediaQuery.of(context);

    return Drawer(
        child: Container(
            decoration: BoxDecoration(
                // color: Colors.teal
                // image: DecorationImage(
                //     image: AssetImage('images/menuCover.png'), fit: BoxFit.cover),
                ),
            child: Column(
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: smallPadding),
                    decoration: BoxDecoration(gradient: gradientAppBar),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/miCuenta');
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              // margin: EdgeInsets.only(top: 0, bottom: 10),
                              decoration: new BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                image: DecorationImage(
                                  image: userModel.imgUrl == null
                                      ? AssetImage('images/logoDrug.png')
                                      : NetworkImage(userModel.imgUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          Text(
                            "Hola, ${userModel.name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w300),
                          ),
                          // SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 7,
                  child: ListView.builder(
                    itemCount: jsonMenu.length,
                    // physics: const NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      IconData menuIcon;

                      switch (jsonMenu[index]['title']) {
                        case 'Inicio':
                          menuIcon = (Icons.home_outlined);
                          break;
                        case 'Mi cuenta':
                          menuIcon = (Icons.person_outline);
                          break;
                        case 'Favoritos':
                          menuIcon = (Icons.favorite_outline);
                          break;
                        case 'Mi tienda':
                          menuIcon = (Icons.store_outlined);
                          break;
                        case 'Ofertas':
                          menuIcon = (Icons.local_offer_outlined);
                          break;
                        case 'Categorías':
                          menuIcon = (Icons.category_outlined);
                          break;
                        case 'Pedidos especiales':
                          menuIcon = (Icons.star_outline);
                          break;
                        case 'Tiendas':
                          menuIcon = (Icons.store_outlined);
                          break;
                        case 'Preguntas frecuentes':
                          menuIcon = (Icons.info_outline);
                          break;
                        case 'Atención a pacientes':
                          menuIcon = (Icons.personal_injury_outlined);
                          break;
                        case 'Soporte pedidos':
                          menuIcon = (Icons.medical_services_outlined);
                          break;
                        case 'Cerrar sesión':
                          menuIcon = (Icons.logout_outlined);
                          break;
                        default:
                          menuIcon = (Icons.medication_outlined);
                      }

                      return jsonMenu[index]['title'] == 'Carrito'
                          ? ListTile(
                              leading: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Icon(Icons.shopping_cart_outlined,
                                      color: Colors.grey),
                                  CircleAvatar(
                                      radius: 7,
                                      child: StreamBuilder<List<ProductoModel>>(
                                          initialData: [],
                                          stream: _catalogBloc.catalogStream,
                                          builder: (context, snapshot) {
                                            int sum = snapshot.data
                                                .map((expense) =>
                                                    expense.cantidad)
                                                .fold(
                                                    0,
                                                    (prev, amount) =>
                                                        prev + amount);
                                            return Text(
                                              sum.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 7.0,
                                              ),
                                            );
                                          }))
                                ],
                              ),
                              title: Text(
                                'Carrito',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              onTap: () =>
                                  Navigator.pushNamed(context, '/carrito')
                                      .then((value) => setState(() {})),
                            )
                          : listMenu(
                              context,
                              (menuIcon),
                              Colors.grey,
                              jsonMenu[index]['title'],
                              jsonMenu[index]['action'],
                              jsonMenu[index]['url']);
                    },
                  ),
                ),
              ],
            )));
  }

  Widget listMenu(BuildContext context, IconData iconMenu, Color colorIcon,
      String titleMenu, String action, String url) {
    return ListTile(
        leading: Icon(iconMenu, color: colorIcon),
        title: Text(
          titleMenu,
          style: TextStyle(color: Colors.grey[700]),
        ),
        onTap: () {
          if (action == "/logout") {
            logoutUser().then(
                (value) => Navigator.pushReplacementNamed(context, '/login'));
          } else if (action == '/fav') {
            Navigator.pushNamed(
              context,
              ProductView.routeName,
              arguments: ProductosDetallesArguments({
                "farmacia_id": null,
                "userQuery": null,
                "favoritos": true,
                "availability": null,
                "stock": "available",
                "priceFilter": null,
                "myLabels": [],
                "myCats": [],
                "title": "Prodcutos favoritos"
              }),
            ).then((value) => setState(() {}));
          } else {
            if (url == 'true') {
              launchURL(action);
            } else {
              if (Uri.base.path != action) {
                // print('ok');
                Navigator.pushNamed(context, action)
                    .then((value) => setState(() {}));
              }
            }
          }
        });
  }
}

//Menu User

// import 'dart:convert';

// import 'package:drugapp/model/product_model.dart';
// import 'package:drugapp/model/producto_model.dart';
// import 'package:drugapp/model/user_model.dart';
// import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
// import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
// import 'package:drugapp/src/bloc/user_bloc.dart/bloc_user.dart';
// import 'package:drugapp/src/bloc/user_bloc.dart/event_user.dart';
// import 'package:drugapp/src/service/sharedPref.dart';
// import 'package:drugapp/src/utils/theme.dart';
// import 'package:drugapp/src/widget/assetImage_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// var itemsMenu =
//     '[{"icon": 62466, "title": "Mi cuenta", "action": "/miCuenta"}, {"icon": 61703, "title": "Inicio", "action": "/home"}, {"icon": 57948, "title": "Favoritos", "action": "/fav"}, {"icon": 62445, "title": "Mi tienda", "action": "/miTienda"}, {"icon": 61821, "title": "Carrito", "action": "null"}, {"icon": 63627, "title": "Cerrar sesión", "action": "/login"}]';

// class ResponsiveAppBar extends StatefulWidget {
//   final screenWidht;
//   final Widget body;
//   final String title;
//   final bool drawerMenu;

//   ResponsiveAppBar(
//       {Key key,
//       this.screenWidht,
//       this.body,
//       this.title,
//       this.drawerMenu = false})
//       : super(key: key);

//   @override
//   _ResponsiveAppBarState createState() => _ResponsiveAppBarState();
// }

// class _ResponsiveAppBarState extends State<ResponsiveAppBar> {
//   CatalogBloc _catalogBloc = CatalogBloc();
//   UserBloc _userBloc = UserBloc();
//   UserModel userModel = UserModel();
//   bool tokenTienda = false;

//   @override
//   void initState() {
//     super.initState();
//     _catalogBloc.sendEvent.add(GetCatalogEvent());
//     _userBloc.sendEvent.add(GetUserEvent());
//     var jsonMenu = jsonDecode(itemsMenu.toString());
//     sharedPrefs.init().then((value) {
//       // getUserData();
//       var jsonUser = jsonDecode(sharedPrefs.clientData);
//       setState(() {
//         userModel = UserModel.fromJson(jsonUser);
//       });
//     });

//     sharedPrefs.init().then((value) {
//       if (sharedPrefs.partnerUserToken != '') {
//         setState(() {
//           tokenTienda = true;
//         });
//       } else {
//         setState(() {
//           tokenTienda = false;
//         });
//       }
//     });
//     print('----' + tokenTienda.toString());
//   }

// @override
// void dispose() {
//   _catalogBloc.dispose();
//   _userBloc.dispose();
//   super.dispose();
// }

//   getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     var jsonUser = jsonDecode(prefs.getString('user_data'));

//     setState(() {
//       userModel = UserModel.fromJson(jsonUser);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _catalogBloc.sendEvent.add(GetCatalogEvent());
//     _userBloc.sendEvent.add(GetUserEvent());
//     return Scaffold(
//         appBar: widget.screenWidht > 1000
//             ? AppBar(
//                 elevation: 0,
//                 backgroundColor: Theme.of(context).accentColor,
//                 title: Row(
//                   children: [
//                     InkWell(
//                       onTap: () => Navigator.pushNamedAndRemoveUntil(
//                               context, '/home', (route) => false)
//                           .then((value) => setState(() {})),
//                       child: Container(
//                         padding: EdgeInsets.all(0),
//                         height: 40,
//                         width: 40,
//                         child: getAsset('logoDrug.png', 0.0),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 7,
//                     ),
//                     widget.title != null
//                         ? Text(widget.title)
//                         : Flexible(
//                             flex: 3,
//                             child: Container(
//                               height: 35,
//                               child: TextField(
//                                 textInputAction: TextInputAction.search,
//                                 textAlignVertical: TextAlignVertical.bottom,
//                                 decoration: InputDecoration(
//                                     prefixIcon: Icon(Icons.search),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                         borderRadius: BorderRadius.circular(0)),
//                                     enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                         borderRadius: BorderRadius.circular(0)),
//                                     hintStyle: TextStyle(),
//                                     hintText:
//                                         'Búsca una medicina, sítnoma o farmacia...',
//                                     fillColor: Colors.white,
//                                     filled: true),
//                               ),
//                             ),
//                           ),
//                     Flexible(flex: 2, child: Container())
//                   ],
//                 ),
//                 actions: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 7.0),
//                         child: InkWell(
//                             onTap: () => Navigator.pushNamedAndRemoveUntil(
//                                     context, '/home', (route) => false)
//                                 .then((value) => setState(() {})),
//                             child: Text('Inicio')),
//                       ),
//                       Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 7.0),
//                           child: InkWell(
//                               onTap: () => Navigator.pushNamed(context, '/fav')
//                                   .then((value) => setState(() {})),
//                               child: Text('Favoritos'))),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 7.0),
//                         child: InkWell(
//                             onTap: () => tokenTienda
//                                 ? Navigator.pushNamed(context, '/miTienda')
//                                     .then((value) => setState(() {}))
//                                 : Navigator.pushNamed(
//                                         context, '/farmacia/login/miTienda')
//                                     .then((value) => setState(() {})),
//                             child: Text('Mi tienda')),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 7.0),
//                         // child: Text('Carrito'),
//                         child: Row(
//                           children: [
//                             InkWell(
//                                 onTap: () =>
//                                     Navigator.pushNamed(context, '/carrito')
//                                         .then((value) => setState(() {})),
//                                 child: Text(
//                                   'Carrito',
//                                   textAlign: TextAlign.center,
//                                 )),
//                             SizedBox(
//                               width: 2,
//                             ),
//       CircleAvatar(
//           radius: 11,
//           child: StreamBuilder<List<ProductoModel>>(
//               initialData: [],
//               stream: _catalogBloc.catalogStream,
//               builder: (context, snapshot) {
//                 int sum = snapshot.data
//                     .map((expense) => expense.cantidad)
//                     .fold(0,
//                         (prev, amount) => prev + amount);
//                 return Text(
//                   sum.toString(),
//                   style: TextStyle(
//                     fontSize: 9.0,
//                   ),
//                 );
//               }))
//     ],
//   ),
// ),
//                       Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: smallPadding * 2),
//                           child: Row(
//                             children: [
//                               InkWell(
//                                 onTap: () =>
//                                     Navigator.pushNamed(context, '/miCuenta')
//                                         .then((value) => setState(() {})),
//                                 // child: Text('Hola, ${userModel.name}')
//                                 child: StreamBuilder<UserModel>(
//                                     initialData: userModel,
//                                     stream: _userBloc.catalogStream,
//                                     builder: (context, snapshot) {
//                                       return Text(
//                                         "Hola, ${snapshot.data.name}",
//                                       );
//                                     }),
//                               ),
//                               SizedBox(width: smallPadding),
//                               CircleAvatar(
//                                 backgroundImage: userModel.imgUrl == null
//                                     ? AssetImage('images/logoDrug.png')
//                                     : getNetworkImage(userModel.imgUrl),
//                               )
//                             ],
//                           )),
//                     ],
//                   )
//                 ],
//               )
//             : AppBar(
//                 elevation: 0,
//                 backgroundColor: Theme.of(context).accentColor,
//                 title: widget.title != null
//                     ? Text(widget.title)
//                     : Container(
//                         height: 35,
//                         child: TextField(
//                           textInputAction: TextInputAction.search,
//                           textAlignVertical: TextAlignVertical.bottom,
//                           decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.search),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide.none,
//                                   borderRadius: BorderRadius.circular(0)),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide.none,
//                                   borderRadius: BorderRadius.circular(0)),
//                               hintStyle: TextStyle(),
//                               hintText:
//                                   'Búsca una medicina, sítnoma o farmacia...',
//                               fillColor: Colors.white,
//                               filled: true),
//                         ),
//                       ),
//                 actions: [
//                   InkWell(
//                     onTap: () => Navigator.pushNamedAndRemoveUntil(
//                             context, '/home', (route) => false)
//                         .then((value) => setState(() {})),
//                     child: Container(
//                       padding: EdgeInsets.all(5),
//                       height: 50,
//                       width: 55,
//                       child: getAsset('logoDrug.png', 0.0),
//                     ),
//                   )
//                 ],
//               ),
//         drawer: widget.screenWidht > 1000
//             ? null
//             : widget.drawerMenu
//                 ? DrawerUser()
//                 : null,
//         body: widget.body);
//   }
// }

// class DrawerUser extends StatefulWidget {
//   DrawerUser({Key key}) : super(key: key);

//   @override
//   _DrawerUserState createState() => _DrawerUserState();
// }

// class _DrawerUserState extends State<DrawerUser> {
//   CatalogBloc _catalogBloc = CatalogBloc();
//   UserBloc _userBloc = UserBloc();
//   UserModel userModel = UserModel();
//   bool tokenTienda = false;

//   @override
//   void initState() {
//     super.initState();
//     _catalogBloc.sendEvent.add(GetCatalogEvent());
//     _userBloc.sendEvent.add(GetUserEvent());
//     sharedPrefs.init().then((value) {
//       getUserData();
//     });
//   }

// @override
// void dispose() {
//   _catalogBloc.dispose();
//   _userBloc.dispose();
//   super.dispose();
// }

//   getUserData() {
//     var jsonUser = jsonDecode(sharedPrefs.clientData);
//     setState(() {
//       userModel = UserModel.fromJson(jsonUser);
//     });
//     if (sharedPrefs.partnerUserToken != '') {
//       setState(() {
//         tokenTienda = true;
//       });
//     } else {
//       setState(() {
//         tokenTienda = false;
//       });
//     }
//     //   SharedPreferences prefs = SharedPreferences.getInstance();

//     //   var jsonUser = jsonDecode(prefs.getString('user_data'));

//     //  setState(() {
//     //     userModel = UserModel.fromJson(jsonUser);
//     //  });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var jsonMenu = jsonDecode(itemsMenu.toString());
//     // UserModel userModel = UserModel();
//     // sharedPrefs.init();
//     // var jsonUser = jsonDecode(sharedPrefs.clientData);
//     // userModel = UserModel.fromJson(jsonUser);
//     MediaQueryData queryData = MediaQuery.of(context);

//     return Drawer(
//         child: Container(
//       decoration: BoxDecoration(
//           // color: Colors.teal
//           // image: DecorationImage(
//           //     image: AssetImage('images/menuCover.png'), fit: BoxFit.cover),
//           ),
//       child: ListView(padding: EdgeInsets.zero, children: <Widget>[
//         // SizedBox(
//         //   height: queryData.size.height * 0.1,
//         // ),
//         Container(
//           padding: EdgeInsets.all(50),
//           decoration: BoxDecoration(gradient: gradientAppBar),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   InkWell(
//                     onTap: () {
//                       Navigator.pushNamed(context, '/miCuenta')
//                           .then((value) => setState(() {}));
//                     },
//                     child: Hero(
//                       tag: "profile_picture",
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         // margin: EdgeInsets.only(top: 0, bottom: 10),
//                         decoration: new BoxDecoration(
//                           color: Colors.grey.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(100),
//                           border: Border.all(width: 1, color: Colors.white),
//                           image: DecorationImage(
//                             image: userModel.imgUrl == null
//                                 ? AssetImage('images/logoDrug.png')
//                                 : getNetworkImage(userModel.imgUrl),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               StreamBuilder<UserModel>(
//                   initialData: userModel,
//                   stream: _userBloc.catalogStream,
//                   builder: (context, snapshot) {
//                     return Text(
//                       "Hola, ${snapshot.data.name}",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w300),
//                     );
//                   })

//               // SizedBox(height: 10,),
//             ],
//           ),
//         ),
//         ListView.builder(
//           itemCount: jsonMenu.length,
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return jsonMenu[index]['title'] == 'Carrito'
//                 ? ListTile(
//                     leading: Stack(
//                       alignment: Alignment.topRight,
//                       children: [
//                         Icon(Icons.shopping_cart_outlined, color: Colors.grey),
//                         CircleAvatar(
//                             radius: 7,
//                             child: StreamBuilder<List<ProductoModel>>(
//                                 initialData: [],
//                                 stream: _catalogBloc.catalogStream,
//                                 builder: (context, snapshot) {
//                                   int sum = snapshot.data
//                                       .map((expense) => expense.cantidad)
//                                       .fold(0, (prev, amount) => prev + amount);
//                                   return Text(
//                                     sum.toString(),
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 7.0,
//                                     ),
//                                   );
//                                 }))
//                       ],
//                     ),
//                     title: Text(
//                       'Carrito',
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                     onTap: () => Navigator.pushNamed(context, '/carrito')
//                         .then((value) => setState(() {})),
//                   )
//                 : listMenu(
//                     context,
//                     IconData(jsonMenu[index]['icon'],
//                         fontFamily: 'MaterialIcons'),
//                     Colors.grey,
//                     jsonMenu[index]['title'], () {
//                     if (jsonMenu[index]['title'] == 'Cerrar sesión') {
//                       logoutUser().then((value) {
//                         Navigator.pushNamed(context, jsonMenu[index]['action'])
//                             .then((value) => setState(() {}));
//                       });
//                     } else {
//                       if (jsonMenu[index]['title'] == 'Mi tienda') {
//                         tokenTienda
//                             ? Navigator.pushNamed(
//                                     context, jsonMenu[index]['action'])
//                                 .then((value) => setState(() {}))
//                             : Navigator.pushNamed(
//                                     context, '/farmacia/login/miTienda')
//                                 .then((value) => setState(() {}));
//                       } else {
//                         Navigator.pushNamed(context, jsonMenu[index]['action'])
//                             .then((value) => setState(() {}));
//                       }
//                     }
//                   });
//           },
//         ),
//       ]),
//     ));
//   }
// }

// Widget listMenu(BuildContext context, IconData iconMenu, Color colorIcon,
//     String titleMenu, action) {
//   return ListTile(
//       leading: Icon(iconMenu, color: colorIcon),
//       title: Text(
//         titleMenu,
//         style: TextStyle(color: Colors.grey[700]),
//       ),
//       onTap: action);
// }

// //Menu User
