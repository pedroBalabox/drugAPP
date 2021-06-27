import 'dart:convert';
import 'package:drugapp/model/user_model.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

var itemsMenu =
    '[{"icon": 62466, "title": "Mi cuenta", "action": "/farmacia/miCuenta/"}, {"icon": 62445, "title": "Mi tienda", "action": "/farmacia/miTienda/"},  {"icon": 63627, "title": "Cerrar sesión", "action": "/farmacia/logout/"}]';

var itemsMobileMenu =
    '[{"icon": 62466, "title": "Mi cuenta", "action": "/farmacia/miCuenta/"}, {"icon": 62445, "title": "Mi tienda", "action": "/farmacia/miTienda/mobile"},  {"icon": 63627, "title": "Cerrar sesión", "action": "/farmacia/logout/"}]';

class ResponsiveAppBarVendedor extends StatefulWidget {
  final screenWidht;
  final Widget body;
  final String title;
  final bool drawerMenu;
  final UserModel userModel;
  ResponsiveAppBarVendedor(
      {Key key,
      this.screenWidht,
      this.body,
      this.title,
      this.drawerMenu = false,
      this.userModel})
      : super(key: key);

  @override
  _ResponsiveAppBarVendedorState createState() =>
      _ResponsiveAppBarVendedorState();
}

class _ResponsiveAppBarVendedorState extends State<ResponsiveAppBarVendedor> {
  var jsonMenu;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      jsonMenu = jsonDecode(itemsMenu.toString());
    } else {
      jsonMenu = jsonDecode(itemsMobileMenu.toString());
    }
    // sharedPrefs.init().then((value) {
    //   getUserData();
    // });
  }

  // getUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   var jsonUser = jsonDecode(prefs.getString('partner_data'));

  //   setState(() {
  //     userModel = UserModel.fromJson(jsonUser);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.screenWidht > 1000
            ? AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).accentColor,
                title: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      height: 40,
                      width: 40,
                      child: getAsset('logoDrug.png', 0.0),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    widget.title != null ? Text(widget.title) : Container(),
                    // : Flexible(
                    //     flex: 3,
                    //     child: Container(
                    //       height: 35,
                    //       child: TextField(
                    //         textInputAction: TextInputAction.search,
                    //         textAlignVertical: TextAlignVertical.bottom,
                    //         decoration: InputDecoration(
                    //             prefixIcon: Icon(Icons.search),
                    //             focusedBorder: OutlineInputBorder(
                    //                 borderSide: BorderSide.none,
                    //                 borderRadius: BorderRadius.circular(0)),
                    //             enabledBorder: OutlineInputBorder(
                    //                 borderSide: BorderSide.none,
                    //                 borderRadius: BorderRadius.circular(0)),
                    //             hintStyle: TextStyle(),
                    //             hintText:
                    //                 'Búsca una medicina, sítnoma o farmacia...',
                    //             fillColor: Colors.white,
                    //             filled: true),
                    //       ),
                    //     ),
                    //   ),
                    Flexible(flex: 2, child: Container())
                  ],
                ),
                actions: [
                  /* Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /* ListView.builder(
                        itemCount: jsonMenu.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 7.0),
                            child: InkWell(
                                onTap: () {
                                  if (Uri.base.path !=
                                      jsonMenu[index]['action']) {
                                    Navigator.pushNamed(
                                            context, jsonMenu[index]['action'])
                                        .then((value) => setState(() {}));
                                  }
                                },
                                child: Text('Mi cuenta')),
                          );
                        },
                      ), */

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: InkWell(
                            onTap: () => Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/farmacia/miCuenta',
                                    (route) => false)
                                .then((value) => setState(() {})),
                            child: Text('Mi cuenta')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: InkWell(
                            onTap: () {
                              if (Uri.base.path != '/farmacia/miTienda/') {
                                Navigator.pushNamed(
                                        context, '/farmacia/miTienda/')
                                    .then((value) => setState(() {}));
                              }
                            },
                            child: Text('Mi tienda')),
                      ),
                      // Padding(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: smallPadding * 2),
                      //     child: Row(
                      //       children: [
                      //         InkWell(
                      //             onTap: () =>
                      //                 Navigator.pushNamed(context, '/miCuenta'),
                      //             child: Text('Hola, ${userModel.nombre}')),
                      //         SizedBox(width: smallPadding),
                      //         CircleAvatar(
                      //           backgroundImage: userModel.imgUrl == null
                      //               ? AssetImage('images/logoDrug.png')
                      //               : getNetworkImage(userModel.imgUrl),
                      //         )
                      //       ],
                      //     )),
                    ],
                  ) */
                  Container(
                    width: 300,
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
                                if (jsonMenu[index]['action'] ==
                                    "/farmacia/logout/") {
                                  logoutVendor().then((value) =>
                                      Navigator.pushReplacementNamed(
                                          context, '/farmacia/login/'));
                                } else {
                                  if (Uri.base.path !=
                                      jsonMenu[index]['action']) {
                                    Navigator.pushNamed(
                                            context, jsonMenu[index]['action'])
                                        .then((value) => setState(() {}));
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(jsonMenu[index]['title']),
                              )),
                        );
                      },
                    ),
                  )
                ],
              )
            : AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).accentColor,
                title: widget.title != null ? Text(widget.title) : Container(),
                // : Container(
                //     height: 35,
                //     child: TextField(
                //       textInputAction: TextInputAction.search,
                //       textAlignVertical: TextAlignVertical.bottom,
                //       decoration: InputDecoration(
                //           prefixIcon: Icon(Icons.search),
                //           focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide.none,
                //               borderRadius: BorderRadius.circular(0)),
                //           enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide.none,
                //               borderRadius: BorderRadius.circular(0)),
                //           hintStyle: TextStyle(),
                //           hintText:
                //               'Búsca una medicina, sítnoma o farmacia...',
                //           fillColor: Colors.white,
                //           filled: true),
                //     ),
                //   ),
                actions: [
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 50,
                    width: 55,
                    child: getAsset('logoDrug.png', 0.0),
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
  UserModel userModel = UserModel();
  var jsonMenu;

  @override
  void initState() {
    super.initState();
    sharedPrefs.init().then((value) {
      getUserData();
    });
    if (kIsWeb) {
      jsonMenu = jsonDecode(itemsMenu.toString());
    } else {
      jsonMenu = jsonDecode(itemsMobileMenu.toString());
    }
  }

  getUserData() {
    var jsonUser = jsonDecode(sharedPrefs.partnerUserData);
    setState(() {
      userModel = UserModel.fromJson(jsonUser);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      Navigator.pushNamed(context, '/miCuenta');
                    },
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
                ],
              ),
              SizedBox(
                height: 15,
              ),
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
        ListView.builder(
          itemCount: jsonMenu.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return listMenu(
                context,
                IconData(jsonMenu[index]['icon'], fontFamily: 'MaterialIcons'),
                Colors.grey,
                jsonMenu[index]['title'],
                jsonMenu[index]['action']);
          },
        ),
      ]),
    ));
  }
}

Widget listMenu(BuildContext context, IconData iconMenu, Color colorIcon,
    String titleMenu, String action) {
  return ListTile(
      leading: Icon(iconMenu, color: colorIcon),
      title: Text(
        titleMenu,
        style: TextStyle(color: Colors.grey[700]),
      ),
      onTap: () {
        if (action == "/farmacia/logout/") {
          logoutVendor().then((value) =>
              Navigator.pushReplacementNamed(context, '/farmacia/login/'));
        } else {
          if (Uri.base.path != action) {
            Navigator.pushNamed(context, action);
          }
        }
      });
}

//Menu User
