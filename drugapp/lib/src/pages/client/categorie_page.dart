import 'dart:convert';

import 'package:drugapp/src/pages/client/tiendaProductos_page.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/navigation_handler.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class CategoriaPage extends StatefulWidget {
  final bool showAppBar;

  CategoriaPage({Key key, this.showAppBar = true}) : super(key: key);

  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  var cat;
  RestFun rest = RestFun();

  String errorStr;
  bool load = true;
  bool error = false;

  List searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    sharedPrefs.init().then((value) => getCat());
    super.initState();
  }

  getCat() async {
    await rest
        .restService(
            null, '${urlApi}obtener/categorias', sharedPrefs.clientToken, 'get')
        .then((value) {
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp);
        setState(() {
          cat = dataResp[1]['categories'];
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
    return widget.showAppBar
        ? ResponsiveAppBar(
            screenWidht: MediaQuery.of(context).size.width,
            body: load
                ? bodyLoad(context)
                : error
                    ? errorWidget(errorStr, context)
                    : bodyCategoria(),
            title: "Categorías")
        : load
            ? bodyLoad(context)
            : error
                ? errorWidget(errorStr, context)
                : bodyCategoria();
  }

  bodyCategoria() {
    return Container(
      color: bgGrey,
      child: Column(
        children: [
          widget.showAppBar
              ? Container(
                  padding: EdgeInsets.only(
                      right: medPadding,
                      left: medPadding,
                      bottom: smallPadding),
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
                      : search())
              : Container(),
          Expanded(child: listCategorias())
        ],
      ),
    );
  }

  listCategorias() {
    return ListView(
      padding: EdgeInsets.all(smallPadding),
      children: [
        Container(
            child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: (200 / 150),
          primary: false,
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: MediaQuery.of(context).size.width < 1150
              ? MediaQuery.of(context).size.width < 700
                  ? 2
                  : 4
              : 5,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(_isSearching ? searchList.length : cat.length,
              (index) {
            return categorieCard(_isSearching ? searchList[index] : cat[index]);
          }),
        ))
      ],
    );
  }

  categorieCard(cat) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context,
              '/productos/' + cat['categoria_id'] + '/' + cat['nombre'])
          .then((value) => setState(() {})),
      child: Container(
        width: 200,
        height: 200,
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
        ),
        // image: DecorationImage(
        //     image: getNetworkImage(cat['imagen']), fit: BoxFit.cover)
        //     ),
        margin: EdgeInsets.symmetric(
            horizontal: smallPadding / 2, vertical: smallPadding * 0.5),
        // child: Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Container(
        //       padding: EdgeInsets.all(smallPadding / 2),
        //       width: double.infinity,
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).primaryColor.withOpacity(0.7),
        //       ),
        //       child: Text(
        //         cat['nombre'],
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //         style: TextStyle(
        //             color: Colors.white,
        //             fontWeight: FontWeight.w500,
        //             fontSize: 17),
        //       )),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            getNetworkImage(
              cat['imagen'],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(smallPadding / 2),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  child: Text(
                    cat['nombre'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  search() {
    return Container(
      height: 35,
      child: TextField(
        onChanged: (value) => searchOperation(value),
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
            hintText: 'Búscar categoría...',
            fillColor: Colors.white,
            filled: true),
      ),
    );
  }

  void searchOperation(String searchText) {
    searchList.clear();
    _handleSearchStart();
    if (_isSearching != null) {
      for (int i = 0; i < cat.length; i++) {
        String dataNombre = cat[i]['nombre'];
        if (dataNombre.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            searchList.add(cat[i]);
          });
        }
      }
    }
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }
}
