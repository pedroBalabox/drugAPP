import 'dart:convert';

import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class TiendasPage extends StatefulWidget {
  TiendasPage({Key key}) : super(key: key);

  @override
  _TiendasPageState createState() => _TiendasPageState();
}

class _TiendasPageState extends State<TiendasPage> {
  var tiendas = [];
  @override
  void initState() {
    tiendas = jsonDecode(dummyTienda);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBar(
        screenWidht: MediaQuery.of(context).size.width,
        body: bodyTiendas(),
        title: "Tiendas");
  }

  bodyTiendas() {
    return Container(
      color: bgGrey,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(
                  right: medPadding, left: medPadding, bottom: smallPadding),
              color: Theme.of(context).accentColor,
              child: MediaQuery.of(context).size.width > 700
                  ? Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(),
                        ),
                        Flexible(
                          flex: 3,
                          child: search(),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(),
                        ),
                      ],
                    )
                  : search()),
          Expanded(child: listTiendas())
        ],
      ),
    );
  }

  listTiendas() {
    return ListView(
      padding: EdgeInsets.all(smallPadding),
      children: [
        Container(
            child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: (200 / 250),
          primary: false,
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: MediaQuery.of(context).size.width < 1150
              ? MediaQuery.of(context).size.width < 700
                  ? 2
                  : 4
              : 5,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(tiendas.length, (index) {
            return tiendaCard(tiendas[index]);
          }),
        ))
      ],
    );
  }

  tiendaCard(tiendas) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        TiendaProductos.routeName,
        arguments: TiendaDetallesArguments(tiendas),
      ).then((value) => setState(() {})),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: smallPadding / 2, vertical: smallPadding * 0.5),
        padding: EdgeInsets.all(smallPadding / 2.5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 4, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                3.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          color: Colors.white,
        ),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/${tiendas['img']}'),
                        fit: BoxFit.contain)),
                // child: Align(
                //   alignment: Alignment.topRight,
                //   child: Container(
                //     width: 80,
                //     child: Tooltip(
                //       message: 'Farmacia verificada.',
                //       child: Container(
                //         padding: EdgeInsets.all(3),
                //         color: Colors.green.withOpacity(0.7),
                //         child: Row(
                //           children: [
                //             Icon(Icons.verified_outlined, size: 13, color: Colors.white,),
                //             Text('verificada',
                //                 style: TextStyle(
                //                     fontSize: 13, color: Colors.white))
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ),
            ),
            Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Tooltip(
                      message: 'Farmacia verificada',
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.black),
                          text: '${tiendas['name']} ',
                          children: <TextSpan>[
                            TextSpan(
                              text: String.fromCharCode(58959), //<-- charCode
                              style: TextStyle(
                                fontFamily: 'MaterialIcons', //<-- fontFamily
                                fontSize: 13.0,
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Text(
                    //   '${tiendas['name']} ${Icons.check}',
                    //   textAlign: TextAlign.center,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    // ),
                    Text(
                      tiendas['descripcion'].toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '35 productos',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '26 ventas',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  search() {
    return Container(
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
            hintText: 'Búscar tienda...',
            fillColor: Colors.white,
            filled: true),
      ),
    );
  }
}
