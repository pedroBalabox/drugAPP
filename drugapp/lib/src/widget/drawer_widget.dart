import 'dart:convert';

import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/model/producto_model.dart';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/bloc_user.dart';
import 'package:drugapp/src/bloc/user_bloc.dart/event_user.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var itemsMenu =
    '[{"icon": 62466, "title": "Mi cuenta", "action": "/miCuenta"}, {"icon": 61703, "title": "Inicio", "action": "/home"}, {"icon": 57948, "title": "Favoritos", "action": "/fav"}, {"icon": 62445, "title": "Mi tienda", "action": "/miTienda"}, {"icon": 61821, "title": "Carrito", "action": "null"}, {"icon": 63627, "title": "Cerrar sesión", "action": "/login"}]';

class ResponsiveAppBar extends StatefulWidget {
  final screenWidht;
  final Widget body;
  final String title;
  final bool drawerMenu;

  ResponsiveAppBar(
      {Key key,
      this.screenWidht,
      this.body,
      this.title,
      this.drawerMenu = false})
      : super(key: key);

  @override
  _ResponsiveAppBarState createState() => _ResponsiveAppBarState();
}

class _ResponsiveAppBarState extends State<ResponsiveAppBar> {
  CatalogBloc _catalogBloc = CatalogBloc();
  UserBloc _userBloc = UserBloc();
  UserModel userModel = UserModel();
  bool tokenTienda = false;

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    _userBloc.sendEvent.add(GetUserEvent());
    var jsonMenu = jsonDecode(itemsMenu.toString());
    sharedPrefs.init().then((value) {
      // getUserData();
      var jsonUser = jsonDecode(sharedPrefs.clientData);
      setState(() {
        userModel = UserModel.fromJson(jsonUser);
      });
    });

    sharedPrefs.init().then((value) {
      if (sharedPrefs.partnerUserToken != '') {
        setState(() {
          tokenTienda = true;
        });
      } else {
        setState(() {
          tokenTienda = false;
        });
      }
    });
    print('----' + tokenTienda.toString());
  }

  @override
  void dispose() {
    _catalogBloc.dispose();
    _userBloc.dispose();
    super.dispose();
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var jsonUser = jsonDecode(prefs.getString('user_data'));

    setState(() {
      userModel = UserModel.fromJson(jsonUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    _userBloc.sendEvent.add(GetUserEvent());
    return Scaffold(
        appBar: widget.screenWidht > 1000
            ? AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).accentColor,
                title: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false)
                          .then((value) => setState(() {})),
                      child: Container(
                        padding: EdgeInsets.all(0),
                        height: 40,
                        width: 40,
                        child: getAsset('logoDrug.png', 0.0),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    widget.title != null
                        ? Text(widget.title)
                        : Flexible(
                            flex: 3,
                            child: Container(
                              height: 35,
                              child: TextField(
                                textInputAction: TextInputAction.search,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(0)),
                                    hintStyle: TextStyle(),
                                    hintText:
                                        'Búsca una medicina, sítnoma o farmacia...',
                                    fillColor: Colors.white,
                                    filled: true),
                              ),
                            ),
                          ),
                    Flexible(flex: 2, child: Container())
                  ],
                ),
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: InkWell(
                            onTap: () => Navigator.pushNamedAndRemoveUntil(
                                    context, '/home', (route) => false)
                                .then((value) => setState(() {})),
                            child: Text('Inicio')),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: InkWell(
                              onTap: () => Navigator.pushNamed(context, '/fav')
                                  .then((value) => setState(() {})),
                              child: Text('Favoritos'))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: InkWell(
                            onTap: () => tokenTienda
                                ? Navigator.pushNamed(context, '/miTienda')
                                    .then((value) => setState(() {}))
                                : Navigator.pushNamed(
                                        context, '/farmacia/login/miTienda')
                                    .then((value) => setState(() {})),
                            child: Text('Mi tienda')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        // child: Text('Carrito'),
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/carrito')
                                        .then((value) => setState(() {})),
                                child: Text(
                                  'Carrito',
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                              width: 2,
                            ),
                            CircleAvatar(
                                radius: 11,
                                child: StreamBuilder<List<ProductoModel>>(
                                    initialData: [],
                                    stream: _catalogBloc.catalogStream,
                                    builder: (context, snapshot) {
                                      int sum = snapshot.data
                                          .map((expense) => expense.cantidad)
                                          .fold(0,
                                              (prev, amount) => prev + amount);
                                      return Text(
                                        sum.toString(),
                                        style: TextStyle(
                                          fontSize: 9.0,
                                        ),
                                      );
                                    }))
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: smallPadding * 2),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/miCuenta')
                                        .then((value) => setState(() {})),
                                // child: Text('Hola, ${userModel.name}')
                                child: StreamBuilder<UserModel>(
                                    initialData: userModel,
                                    stream: _userBloc.catalogStream,
                                    builder: (context, snapshot) {
                                      return Text(
                                        "Hola, ${snapshot.data.name}",
                                      );
                                    }),
                              ),
                              SizedBox(width: smallPadding),
                              CircleAvatar(
                                backgroundImage: userModel.imgUrl == null
                                    ? AssetImage('images/logoDrug.png')
                                    : NetworkImage(userModel.imgUrl),
                              )
                            ],
                          )),
                    ],
                  )
                ],
              )
            : AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).accentColor,
                title: widget.title != null
                    ? Text(widget.title)
                    : Container(
                        height: 35,
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(0)),
                              hintStyle: TextStyle(),
                              hintText:
                                  'Búsca una medicina, sítnoma o farmacia...',
                              fillColor: Colors.white,
                              filled: true),
                        ),
                      ),
                actions: [
                  InkWell(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false)
                        .then((value) => setState(() {})),
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
        body: widget.body);
  }
}

class DrawerUser extends StatefulWidget {
  DrawerUser({Key key}) : super(key: key);

  @override
  _DrawerUserState createState() => _DrawerUserState();
}

class _DrawerUserState extends State<DrawerUser> {
  CatalogBloc _catalogBloc = CatalogBloc();
  UserBloc _userBloc = UserBloc();
  UserModel userModel = UserModel();
  bool tokenTienda = false;

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    _userBloc.sendEvent.add(GetUserEvent());
    sharedPrefs.init().then((value) {
      getUserData();
    });
  }

  @override
  void dispose() {
    _catalogBloc.dispose();
    _userBloc.dispose();
    super.dispose();
  }

  getUserData() {
    var jsonUser = jsonDecode(sharedPrefs.clientData);
    setState(() {
      userModel = UserModel.fromJson(jsonUser);
    });
    if (sharedPrefs.partnerUserToken != '') {
      setState(() {
        tokenTienda = true;
      });
    } else {
      setState(() {
        tokenTienda = false;
      });
    }
    //   SharedPreferences prefs = SharedPreferences.getInstance();

    //   var jsonUser = jsonDecode(prefs.getString('user_data'));

    //  setState(() {
    //     userModel = UserModel.fromJson(jsonUser);
    //  });
  }

  @override
  Widget build(BuildContext context) {
    var jsonMenu = jsonDecode(itemsMenu.toString());
    // UserModel userModel = UserModel();
    // sharedPrefs.init();
    // var jsonUser = jsonDecode(sharedPrefs.clientData);
    // userModel = UserModel.fromJson(jsonUser);
    MediaQueryData queryData = MediaQuery.of(context);

    return Drawer(
        child: Container(
      decoration: BoxDecoration(
          // color: Colors.teal
          // image: DecorationImage(
          //     image: AssetImage('images/menuCover.png'), fit: BoxFit.cover),
          ),
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        // SizedBox(
        //   height: queryData.size.height * 0.1,
        // ),
        Container(
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(gradient: gradientAppBar),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/miCuenta')
                          .then((value) => setState(() {}));
                    },
                    child: Hero(
                      tag: "profile_picture",
                      child: Container(
                        width: 100,
                        height: 100,
                        // margin: EdgeInsets.only(top: 0, bottom: 10),
                        decoration: new BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 1, color: Colors.white),
                          image: DecorationImage(
                            image: userModel.imgUrl == null
                                ? AssetImage('images/logoDrug.png')
                                : NetworkImage(userModel.imgUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder<UserModel>(
                  initialData: userModel,
                  stream: _userBloc.catalogStream,
                  builder: (context, snapshot) {
                    return Text(
                      "Hola, ${snapshot.data.name}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w300),
                    );
                  })

              // SizedBox(height: 10,),
            ],
          ),
        ),
        ListView.builder(
          itemCount: jsonMenu.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return jsonMenu[index]['title'] == 'Carrito'
                ? ListTile(
                    leading: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Icon(Icons.shopping_cart_outlined, color: Colors.grey),
                        CircleAvatar(
                            radius: 7,
                            child: StreamBuilder<List<ProductoModel>>(
                                initialData: [],
                                stream: _catalogBloc.catalogStream,
                                builder: (context, snapshot) {
                                  int sum = snapshot.data
                                      .map((expense) => expense.cantidad)
                                      .fold(0, (prev, amount) => prev + amount);
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
                    onTap: () => Navigator.pushNamed(context, '/carrito')
                        .then((value) => setState(() {})),
                  )
                : listMenu(
                    context,
                    IconData(jsonMenu[index]['icon'],
                        fontFamily: 'MaterialIcons'),
                    Colors.grey,
                    jsonMenu[index]['title'], () {
                    if (jsonMenu[index]['title'] == 'Cerrar sesión') {
                      logoutUser().then((value) {
                        Navigator.pushNamed(context, jsonMenu[index]['action'])
                            .then((value) => setState(() {}));
                      });
                    } else {
                      if (jsonMenu[index]['title'] == 'Mi tienda') {
                        tokenTienda
                            ? Navigator.pushNamed(
                                    context, jsonMenu[index]['action'])
                                .then((value) => setState(() {}))
                            : Navigator.pushNamed(
                                    context, '/farmacia/login/miTienda')
                                .then((value) => setState(() {}));
                      } else {
                        Navigator.pushNamed(context, jsonMenu[index]['action'])
                            .then((value) => setState(() {}));
                      }
                    }
                  });
          },
        ),
      ]),
    ));
  }
}

Widget listMenu(BuildContext context, IconData iconMenu, Color colorIcon,
    String titleMenu, action) {
  return ListTile(
      leading: Icon(iconMenu, color: colorIcon),
      title: Text(
        titleMenu,
        style: TextStyle(color: Colors.grey[700]),
      ),
      onTap: action);
}

//Menu User
