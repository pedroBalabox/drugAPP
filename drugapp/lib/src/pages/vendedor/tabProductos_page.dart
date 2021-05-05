import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/producto_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/client/productoDetalle_pade.dart';
import 'package:drugapp/src/pages/vendedor/editarProducto_page.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class Categorie {
  final String name;

  Categorie({
    this.name,
  });
}

class TabProductos extends StatefulWidget {
  final String title;

  TabProductos({Key key, this.title}) : super(key: key);

  @override
  _TabProductosState createState() => _TabProductosState();
}

class _TabProductosState extends State<TabProductos> {
  var prod = [];
  var _fieldList = ['precio', 'popularidad', 'calificación'];
  bool disponible = true;
  final _items = _cat
      .map((categorie) => MultiSelectItem<Categorie>(categorie, categorie.name))
      .toList();

  CatalogBloc _catalogBloc = CatalogBloc();

  static List<Categorie> _cat = [
    Categorie(name: "Antibióticos"),
    Categorie(name: "Dermatología"),
    Categorie(name: "Pediatría"),
    Categorie(name: "Vacunas"),
    Categorie(name: "Cirugía estética"),
    Categorie(name: "Ginecología"),
    Categorie(name: "Material de curación"),
    Categorie(name: "Ropa médica"),
    Categorie(name: "Baja de peso"),
    Categorie(name: "Hospitalización"),
  ];
  var _selectedCat;

  @override
  void initState() {
    super.initState();
    _catalogBloc.sendEvent.add(GetCatalogEvent());
    prod = jsonDecode(dummyProd);
  }

  @override
  void dispose() {
    _catalogBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return bodyCategoria();
  }

  bodyCategoria() {
    return Container(
      color: bgGrey,
      child: Column(
        children: [
          SizedBox(
            height: medPadding + smallPadding * 2,
          ),
          MediaQuery.of(context).size.width > 900
              ? Container()
              : Container(
                  padding: EdgeInsets.only(
                      right: medPadding,
                      left: medPadding,
                      top: smallPadding * 2,
                      bottom: smallPadding),
                  color: Colors.white,
                  child: Row(children: [
                    Expanded(
                      child: search(),
                    ),
                    SizedBox(width: smallPadding),
                    BotonSimple(
                      action: () => Navigator.pushNamed(
                          context, '/farmacia/cargar-productos'),
                      contenido: Text('Agregar productos',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal)),
                      estilo: estiloBotonPrimary,
                    ),
                  ]),
                ),
          MediaQuery.of(context).size.width > 900
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width * 2,
                  child: ListView(
                    // scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    // physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                          height: 50,
                          color: Colors.white,
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                                horizontal: smallPadding * 0.7),
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text('Filtar lista',
                                  //     style:
                                  //         TextStyle(color: Colors.black45, fontSize: 17)),
                                  DropdownButton<String>(
                                    elevation: 10,
                                    underline: Container(
                                      padding: EdgeInsets.only(top: 10),
                                      height: 2,
                                      color: Colors.black12,
                                    ),

                                    hint: Text(
                                      "Ordenar por",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                          fontSize: 15),
                                    ),
                                    // value: null,
                                    items: _fieldList.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                          width: 100,
                                          child: new Text(value),
                                          // height: 5.0,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String val) {},
                                  ),
                                  SizedBox(
                                    width: smallPadding,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Disponibilidad',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Switch(
                                        value: disponible,
                                        onChanged: (value) {
                                          setState(() {
                                            disponible = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  MultiSelectBottomSheetField(
                                      searchHint: 'Búscar...',
                                      cancelText: Text('Cancelar'),
                                      confirmText: Text('Seleccionar'),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.black12,
                                                  width: 2))),
                                      initialChildSize: 0.3,
                                      listType: MultiSelectListType.CHIP,
                                      searchable: true,
                                      buttonText: Text(
                                        'Categorías',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54,
                                            fontSize: 15),
                                      ),
                                      buttonIcon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black54,
                                      ),
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 0),
                                        child: Text("Categorías"),
                                      ),
                                      items: _items,
                                      onConfirm: (values) {
                                        // _selectedCat = values;
                                      },
                                      chipDisplay: null),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: detallesTienda(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  detallesTienda() {
    var size = MediaQuery.of(context).size;

    return size.width > 900
        ? Container(
            color: bgGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: size.width / 4,
                    height: size.height,
                    // color: Theme.of(context).accentColor,
                    padding: EdgeInsets.all(smallPadding * 2),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                          vertical: smallPadding, horizontal: smallPadding * 2),
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
                      child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          search(),
                          SizedBox(height: smallPadding),
                          BotonSimple(
                            action: () => Navigator.pushNamed(
                                context, '/farmacia/cargar-productos'),
                            contenido: Text('Agregar productos',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                            estilo: estiloBotonPrimary,
                          ),
                          SizedBox(height: smallPadding),
                          Text(
                            'Filtar lista',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                                fontSize: 15),
                          ),
                          Divider(color: Colors.black26),
                          SizedBox(height: smallPadding),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Ordenar por ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(height: smallPadding),
                              DropdownButton<String>(
                                // value: null,
                                items: _fieldList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      width: 100,
                                      child: new Text(value),
                                      // height: 5.0,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String val) {},
                              ),
                            ],
                          ),

                          SizedBox(height: smallPadding),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Disponibilidad',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Switch(
                                value: disponible,
                                onChanged: (value) {
                                  setState(() {
                                    disponible = value;
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(height: smallPadding),
                          MultiSelectBottomSheetField(
                            searchHint: 'Búscar...',
                            cancelText: Text('Cancelar'),
                            confirmText: Text('Seleccionar'),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black12, width: 2))),
                            initialChildSize: 0.4,
                            listType: MultiSelectListType.CHIP,
                            searchable: true,
                            buttonText: Text(
                              'Categorías',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontSize: 15),
                            ),
                            buttonIcon: Icon(Icons.arrow_drop_down),
                            title: Padding(
                              padding: EdgeInsets.only(left: smallPadding),
                              child: Text("Categorías"),
                            ),
                            items: _items,
                            onConfirm: (values) {
                              _selectedCat = values;
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              onTap: (value) {
                                setState(() {
                                  _selectedCat.remove(value);
                                });
                              },
                            ),
                          ),
                          // Expanded(
                          //   child: MultiSelectDialogField(
                          //     buttonText: Text('Categoría'),
                          //     buttonIcon: Icon(Icons.arrow_drop_down),
                          //     title: Text('Categorias'),
                          //     cancelText: Text('CANCELAR'),
                          //     searchable: true,
                          //     listType: MultiSelectListType.CHIP,
                          //     items: _items,
                          //     initialValue: _selectedCat,
                          //     onConfirm: (values) => print('ok'),
                          //     // maxChildSize: 0.8,
                          //   ),
                          // ),
                        ],
                      ),
                    )),
                Expanded(child: listProducts())
              ],
            ),
          )
        : Container(
            // height: size.height,
            color: bgGrey,
            child: listProducts(),
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
            hintText: 'Búscar producto...',
            fillColor: bgGrey,
            filled: true),
      ),
    );
  }

  listProducts() {
    return ListView(
      // physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(smallPadding),
      children: [
        Container(
            child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: (250 / 350),
          primary: false,
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: MediaQuery.of(context).size.width < 1150
              ? MediaQuery.of(context).size.width < 700
                  ? 2
                  : 4
              : 5,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(prod.length, (index) {
            return productFav(true, prod[index]);
          }),
        ))
      ],
    );
  }

  productFav(fav, prod) {
    var size = MediaQuery.of(context).size;
    // final double itemHeight = 280;
    // final double itemWidth = 200;
    ProductModel productModel = ProductModel();
    productModel = ProductModel.fromJson(prod);
    return Container(
      margin: EdgeInsets.all(smallPadding * 0.7),
      padding: EdgeInsets.all(smallPadding * 0.4),
      // height: itemHeight,
      // width: itemWidth,
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        children: [
          Flexible(
              flex: 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    fit: BoxFit.contain,
                    image: AssetImage("images/${prod['img']}"),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        width: 45,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            // Icon(Icons.star, color: Colors.amber, size: 15),
                            RatingBarIndicator(
                              unratedColor: Colors.white.withOpacity(0.5),
                              rating:
                                  double.parse(prod['stars']) * 100 / 5 / 100,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 1,
                              itemSize: 15.0,
                              direction: Axis.horizontal,
                            ),
                            Text(prod['stars'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500))
                          ],
                        )),
                  ),
                ],
              )),
          Flexible(
            flex: 3,
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                ProductoDetalles.routeName,
                arguments: ProductoDetallesArguments(
                  prod,
                ),
              ).then((value) => setState(() {})),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      prod['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      prod['farmacia'],
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${prod['price']}',
                          style: TextStyle(
                              color: Colors.black45,
                              decoration: TextDecoration.lineThrough),
                        ),
                        Text(
                          '\$${prod['price']}',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    BotonSimple(
                      action: () => Navigator.pushNamed(
                        context,
                        EditarProducto.routeName,
                        arguments: EdiaterProductoDetallesArguments(
                          prod,
                        ),
                      ).then((value) => setState(() {})),
                      contenido: Text('Editar producto',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal)),
                      estilo: estiloBotonSecundary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
