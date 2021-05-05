import 'dart:convert';

import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class CategoriaPage extends StatefulWidget {
  CategoriaPage({Key key}) : super(key: key);

  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  var cat = [];
  @override
  void initState() {
    cat = jsonDecode(dummyCat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBar(
        screenWidht: MediaQuery.of(context).size.width,
        body: bodyCategoria(),
        title: "Categorías");
  }

  bodyCategoria() {
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
          children: List.generate(cat.length, (index) {
            return categorieCard(cat[index]);
          }),
        ))
      ],
    );
  }

  categorieCard(cat) {
    return Container(
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
          image: DecorationImage(
              image: AssetImage('images/${cat['img']}'), fit: BoxFit.cover)),
      margin: EdgeInsets.symmetric(
          horizontal: smallPadding / 2, vertical: smallPadding * 0.5),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            padding: EdgeInsets.all(smallPadding / 2),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
            child: Text(
              cat['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            )),
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
            hintText: 'Búscar categoría...',
            fillColor: Colors.white,
            filled: true),
      ),
    );
  }
}
