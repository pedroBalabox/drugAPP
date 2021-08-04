import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/bloc_product.dart';
import 'package:drugapp/src/bloc/products_bloc.dart/event_product.dart';
import 'package:drugapp/src/pages/vendedor/editarProducto_page.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:pagination_view/pagination_view.dart';

class ProductView extends StatefulWidget {
  static const routeName = '/productosDetalles';
  final bool myStore;
  final dynamic jsonData;
  final bool showAppBar;

  ProductView(
      {Key key, this.jsonData, this.myStore = false, this.showAppBar = true})
      : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> with WidgetsBindingObserver {
  var prod;

  // Filtros de búsqueda

  var _fieldList = ['Elige una opción', 'Menor a mayor', 'Mayor a menor'];
  String chosenFilter;

  String buscarStr;

  String famaciaID;
  String userQuery;
  bool favorite;
  String availability;
  String stock = "available";
  String priceFilter;
  List myCats = [];
  List myLabels = [];

  CatalogBloc _catalogBloc = CatalogBloc();

  ProductoModel productoModel = ProductoModel();

  RestFun rest = RestFun();

  var miTienda;

  bool load = true;

  bool loadProd = true;

  bool errorProd = false;
  String errorStrProd;

  bool error = false;
  String errorStr;

  List searchList = [];
  bool _isSearching = false;

  bool favProduct = false;

  List<Category> _categories = [];
  List<Category> _labels = [];

  int prodLon = 0;

  var _itemsCat;

  var _itemCat;

  var _itemsLabel;

  var _itemLabel;

  List<Category> _myCat = [];

  List<Category> _myLabels = [];
  bool myStore;

  var newJsonData;

  bool loadmiTienda = true;

  // paginacion variables
  var listProd = [];
  var myList = [];

  int numPaination;

  bool storeExist = true;
  bool finalList = false;

  ScrollController _scrollController = ScrollController();

  int page;
  PaginationViewType paginationViewType;
  GlobalKey<PaginationViewState> key;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    numPaination = 30;

    myStore = widget.myStore;
    if (myStore != null && myStore) {
      // print("Call checkIfAllowed();");
      checkIfAllowed();
    } else {
      // print("first mistake");
      setState(() {
        newJsonData = widget.jsonData.jsonData;
      });
      loadData();
    }
    page = -1;
    paginationViewType = PaginationViewType.listView;
    key = GlobalKey<PaginationViewState>();
  }

  createProdList() {
    var x = prod.length - prodLon;

    if (x >= numPaination) {
      setState(() {
        prodLon = prodLon + numPaination;
      });
    } else {
      setState(() {
        prodLon = prodLon + x;
        finalList = true;
      });
    }
  }

  @override
  void dispose() {
    _catalogBloc.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("Resumed");
    }
  }

  loadData() {
    setState(() {
      _catalogBloc = CatalogBloc();
      _catalogBloc.sendEvent.add(GetCatalogEvent());
      print("Primero" + newJsonData.toString());
      sharedPrefs.init().then((value) {
        if (storeExist) {
          if (newJsonData['farmacia_id'] != null) {
            print("Will get farm");
            getFarmacia();
          } else {
            print("Wont");
            print("Aquí va" + newJsonData['farmacia'].toString());
            getCate();
          }
        } else {
          setState(() {
            load = false;
          });
        }
      });

      if (myStore != null && !myStore) {
        famaciaID = widget.jsonData.jsonData['farmacia_id'];
      }
      famaciaID = widget.jsonData.jsonData['farmacia_id'];
      userQuery = widget.jsonData.jsonData['userQuery'];
      favorite = widget.jsonData.jsonData['favoritos'];
      availability = widget.jsonData.jsonData['availability'];
      stock = widget.jsonData.jsonData['stock'];
      priceFilter = widget.jsonData.jsonData['priceFilter'];
      myCats = widget.jsonData.jsonData['myCats'];
      myLabels = widget.jsonData.jsonData['myLabels'];
    });
  }

  getCate() async {
    await rest
        .restService(
            null, '${urlApi}obtener/categorias', sharedPrefs.clientToken, 'get')
        .then((value) {
      if (value['status'] == 'server_true') {
        _itemCat = value['response'];
        _itemCat = jsonDecode(_itemCat)[1]['categories'];

        for (int i = 0; i <= _itemCat.length - 1; i++) {
          var myCat = _itemCat[i];
          var myId = myCat['categoria_id'];
          var myName = myCat['nombre'];

          // _cat.add(Category(id: myId, name: myName));
          // _myItemCat = [Category(id: myId, name: myName)];

          setState(() {
            _categories.add(Category(id: myId, name: myName));
            _itemsCat = _categories
                .map((cat) => MultiSelectItem<Category>(cat, cat.name))
                .toList();
          });
        }

        for (int j = 0; j <= _categories.length - 1; j++) {
          for (int i = 0;
              i <= widget.jsonData.jsonData['myCats'].length - 1;
              i++) {
            if (widget.jsonData.jsonData['myCats'][i] == _categories[j].id) {
              _myCat.add(_categories[j]);
            }
          }
        }
      } else {
        setState(() {
          load = false;
          error = true;
          errorStr = value['message'];
        });
      }
    }).then((value) {
      getLabels();
    });
  }

  getLabels() async {
    await rest
        .restService(
            null, '${urlApi}obtener/etiquetas', sharedPrefs.clientToken, 'get')
        .then((value) {
      if (value['status'] == 'server_true') {
        _itemLabel = value['response'];
        _itemLabel = jsonDecode(_itemLabel)[1]['tags'];

        for (int i = 0; i <= _itemLabel.length - 1; i++) {
          var myCat = _itemLabel[i];
          var myId = myCat['id_de_etiqueta'];
          var myName = myCat['nombre'];

          // _cat.add(Category(id: myId, name: myName));
          // _myItemCat = [Category(id: myId, name: myName)];

          setState(() {
            _labels.add(Category(id: myId, name: myName));
            _itemsLabel = _labels
                .map((label) => MultiSelectItem<Category>(label, label.name))
                .toList();
          });
        }

        for (int j = 0; j <= _labels.length - 1; j++) {
          for (int i = 0;
              i <= widget.jsonData.jsonData['myLabels'].length - 1;
              i++) {
            if (widget.jsonData.jsonData['myLabels'][i] == _labels[j].id) {
              _myLabels.add(_labels[j]);
            }
          }
        }
      } else {
        setState(() {
          load = false;
          error = true;
          errorStr = value['message'];
        });
      }
    }).then((value) {
      setState(() {
        load = false;
      });
      getProductos();
    });
  }

  getFarmacia() async {
    var arrayData = {"farmacia_id": widget.jsonData.jsonData['farmacia_id']};
    await rest
        .restService(arrayData, '$apiUrl/perfil/farmacia',
            sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp);
        setState(() {
          miTienda = dataResp[1];
          loadmiTienda = false;
        });
        getCate();
        getProductos();
      } else {
        setState(() {
          load = false;
          error = true;
          errorStr = value['message'];
          loadmiTienda = false;
        });
      }
    });
  }

  getProductos() async {
    finalList = false;
    var arrayData = {
      "farmacia_id": famaciaID,
      "userQuery": userQuery,
      "favoritos": favorite,
      "availability": availability,
      "stock": stock,
      "priceFilter": priceFilter,
      "categorias": myCats,
      "etiquetas": myLabels,
    };

    await rest
        .restService(arrayData, '$apiUrl/listar/producto',
            sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp)[1]['results'];
        setState(() {
          prod = dataResp;
          // orden = dataResp.values.toList();
          loadProd = false;
          if (prod.length >= numPaination) {
            prodLon = numPaination;
          } else {
            prodLon = prod.length;
            finalList = true;
          }
        });
        // createProdList();
      } else {
        setState(() {
          loadProd = false;
          errorProd = true;
          errorStrProd = value['message'];
        });
      }
    });
  }

  addFav(idProd, fav) async {
    var arrayData = {"id_de_producto": idProd};

    String url = fav ? '$apiUrl/desmarcar/favorito' : '$apiUrl/marcar/favorito';

    await rest
        .restService(arrayData, url, sharedPrefs.clientToken, 'post')
        .then((value) {
      if (value['status'] == 'server_true') {
        setState(() {
          fav = !fav;
        });
        getProductos();
      } else {}
    });
  }

  checkIfAllowed() {
    bool tokenVendor;
    sharedPrefs.init().then((value) {
      tokenVendor = sharedPrefs.partnerUserToken == '' ? false : true;
      if (tokenVendor) {
        RestFun rest = RestFun();
        var jsonTienda;
        rest
            .restService('', '${urlApi}obtener/mi-farmacia',
                sharedPrefs.partnerUserToken, 'get')
            .then((value) {
          if (value['status'] == 'server_true') {
            setState(() {
              jsonTienda = jsonDecode(value['response']);
              famaciaID = jsonTienda[1]['farmacia_id'].toString();
              newJsonData = widget.jsonData.jsonData;
              newJsonData["farmacia"] = jsonTienda[1];
              newJsonData["farmacia_id"] = famaciaID;
              print("ID de farmacia: " + newJsonData["farmacia"].toString());
              loadData();
            });
          } else if (value['message'] ==
              '¡Parece que aún no cuentas con ninguna farmacia!') {
            setState(() {
              storeExist = false;
              loadData();
            });
          } else {
            //CJNavigator.navigator.push(context, '/farmacia/login');
            Navigator.pushReplacementNamed(context, '/cliente/farmacia/login')
                .then((value) => setState(() {}));
          }
        });
      } else {
        //CJNavigator.navigator.push(context, '/farmacia/login');
        Navigator.pushReplacementNamed(context, '/cliente/farmacia/login')
            .then((value) => setState(() {}));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return widget.showAppBar
        ? ResponsiveAppBar(
            screenWidht: MediaQuery.of(context).size.width,
            body: StreamBuilder<List<ProductoModel>>(
                initialData: [],
                stream: _catalogBloc.catalogStream,
                builder: (context, snapshot) {
                  return widget.jsonData.jsonData['farmacia_id'] == null
                      ? load
                          ? bodyLoad(context)
                          : error
                              ? errorWidget(errorStr, context)
                              : !storeExist
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width > 700
                                              ? size.width / 3
                                              : medPadding * .5,
                                          vertical: medPadding * 1.5),
                                      color: bgGrey,
                                      width: size.width,
                                      child: noTienda())
                                  : bodyCategoria(snapshot)
                      : loadmiTienda
                          ? bodyLoad(context)
                          : miTienda['estatus'] == 'approved'
                              ? load
                                  ? bodyLoad(context)
                                  : error
                                      ? errorWidget(errorStr, context)
                                      : bodyCategoria(snapshot)
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width > 700
                                          ? size.width / 3
                                          : medPadding * .5,
                                      vertical: medPadding * 1.5),
                                  color: bgGrey,
                                  width: size.width,
                                  child: statusTienda(),
                                );
                }),
            // : bodyTienda(),
            title: widget.jsonData.jsonData['title'] == null
                ? 'Productos'
                : widget.jsonData.jsonData['title'])
        : StreamBuilder<List<ProductoModel>>(
            initialData: [],
            stream: _catalogBloc.catalogStream,
            builder: (context, snapshot) {
              return widget.jsonData.jsonData['farmacia_id'] == null
                  ? load
                      ? bodyLoad(context)
                      : error
                          ? errorWidget(errorStr, context)
                          : !storeExist
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width > 700
                                          ? size.width / 3
                                          : medPadding * .5,
                                      vertical: medPadding * 1.5),
                                  color: bgGrey,
                                  width: size.width,
                                  child: noTienda())
                              : bodyCategoria(snapshot)
                  : loadmiTienda
                      ? bodyLoad(context)
                      : miTienda['estatus'] == 'approved'
                          ? load
                              ? bodyLoad(context)
                              : error
                                  ? errorWidget(errorStr, context)
                                  : bodyCategoria(snapshot)
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width > 700
                                      ? size.width / 3
                                      : medPadding * .5,
                                  vertical: medPadding * 1.5),
                              color: bgGrey,
                              width: size.width,
                              child: statusTienda(),
                            );
            });
  }

  noTienda() {
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3),
            height: 130,
            width: 130,
            decoration: BoxDecoration(
                gradient: gradientDrug,
                borderRadius: BorderRadius.circular(100)),
            child: CircleAvatar(
                backgroundImage: AssetImage('images/logoDrug.png')),
          ),
          SizedBox(
            height: medPadding / 2,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                    color: Colors.red[200],
                    borderRadius: BorderRadius.circular(100)),
              ),
              SizedBox(
                width: 3,
              ),
              Flexible(
                child: Text(
                  'No tienes una farmacia registrada.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          // SizedBox(
          //   height: medPadding / 2.5,
          // ),
          // Text(
          //   'Estamos revisando tu farmacia.',
          //   maxLines: 3,
          //   overflow: TextOverflow.ellipsis,
          //   style: TextStyle(
          //       fontSize: 15,
          //       color: Colors.black54,
          //       fontWeight: FontWeight.bold),
          // ),
          SizedBox(
            height: medPadding / 2,
          ),
          BotonSimple(
            contenido: Text('Link a panel web',
                style: TextStyle(
                  color: Colors.white,
                )),
            estilo: estiloBotonPrimary,
            action: () =>
                launchURL('https://app.drugsiteonline.com/farmacia/login'),
          )
        ],
      ),
    );
  }

  statusTienda() {
    var size = MediaQuery.of(context).size;

    switch (miTienda['estatus']) {
      case 'waiting_for_review':
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    gradient: gradientDrug,
                    borderRadius: BorderRadius.circular(100)),
                child: CircleAvatar(
                  backgroundImage: widget.jsonData.jsonData['farmacia']
                              ['image_name'] ==
                          null
                      ? AssetImage('images/logoDrug.png')
                      : NetworkImage(
                          widget.jsonData.jsonData['farmacia']['image_name']),
                ),
              ),
              SizedBox(
                height: medPadding / 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 17,
                    width: 17,
                    decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Flexible(
                    child: Text(
                      'En proceso de revisión.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: medPadding / 2.5,
              ),
              Text(
                'Estamos revisando tu farmacia.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: medPadding / 2,
              ),
              BotonSimple(
                contenido: Text('Link a panel web',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                estilo: estiloBotonPrimary,
                action: () =>
                    launchURL('https://app.drugsiteonline.com/farmacia/login'),
              )
            ],
          ),
        );
        break;
      case 'rejected':
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    gradient: gradientDrug,
                    borderRadius: BorderRadius.circular(100)),
                child: CircleAvatar(
                  backgroundImage: miTienda['logo'] == null
                      ? AssetImage('images/logoDrug.png')
                      : NetworkImage(miTienda['logo']),
                ),
              ),
              SizedBox(
                height: medPadding / 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 17,
                    width: 17,
                    decoration: BoxDecoration(
                        color: Colors.red[200],
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Flexible(
                    child: Text(
                      'Encontramos un problema',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: medPadding / 2.5,
              ),
              Text(
                'Revisa tu correo electrónico para ver mas detalles del estatus de tu tienda.',
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: medPadding / 2,
              ),
              BotonSimple(
                contenido: Text('Link a panel web',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                estilo: estiloBotonPrimary,
                action: () =>
                    launchURL('https://app.drugsiteonline.com/farmacia/login'),
              )
            ],
          ),
        );
        break;
      case 'blocked':
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    gradient: gradientDrug,
                    borderRadius: BorderRadius.circular(100)),
                child: CircleAvatar(
                  backgroundImage: widget.jsonData.jsonData['farmacia']
                              ['image_name'] ==
                          null
                      ? AssetImage('images/logoDrug.png')
                      : NetworkImage(
                          widget.jsonData.jsonData['farmacia']['image_name']),
                ),
              ),
              SizedBox(
                height: medPadding / 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 17,
                    width: 17,
                    decoration: BoxDecoration(
                        color: Colors.red[200],
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Flexible(
                    child: Text(
                      'Lamentamos los incovenientes pero tu farmacia no puede operar con nosotros.',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: medPadding / 2.5,
              ),
              Text(
                'Revisa tu correo electrónico para ver mas detalles del estatus de tu farmacia.',
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: medPadding / 2,
              ),
              BotonSimple(
                contenido: Text('Link a panel web',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                estilo: estiloBotonPrimary,
                action: () =>
                    launchURL('https://app.drugsiteonline.com/farmacia/login'),
              )
            ],
          ),
        );
        break;
      default:
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    gradient: gradientDrug,
                    borderRadius: BorderRadius.circular(100)),
                child: CircleAvatar(
                  backgroundImage: widget.jsonData.jsonData['farmacia']
                              ['image_name'] ==
                          null
                      ? AssetImage('images/logoDrug.png')
                      : NetworkImage(
                          widget.jsonData.jsonData['farmacia']['image_name']),
                ),
              ),
              SizedBox(
                height: medPadding / 2,
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       height: 17,
              //       width: 17,
              //       decoration: BoxDecoration(
              //           color: Colors.blue[200],
              //           borderRadius: BorderRadius.circular(100)),
              //     ),
              //     SizedBox(
              //       width: 3,
              //     ),
              //     Flexible(
              //       child: Text(
              //         'En proceso de revisión.',
              //         maxLines: 3,
              //         overflow: TextOverflow.ellipsis,
              //         style: TextStyle(
              //             fontSize: 17,
              //             color: Colors.black,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     )
              //   ],
              // ),
              // SizedBox(
              //   height: medPadding / 2.5,
              // ),
              Text(
                'Configura tu farmacia.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: medPadding / 2,
              ),
              BotonSimple(
                contenido: Text('Link a panel web',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                estilo: estiloBotonPrimary,
                action: () =>
                    launchURL('https://app.drugsiteonline.com/farmacia/login'),
              )
            ],
          ),
        );
        break;
    }
  }

  bodyCategoria(snapshot) {
    return Container(
      color: bgGrey,
      child: Column(
        children: [
          widget.showAppBar
              ? MediaQuery.of(context).size.width > 900
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(
                          right: medPadding,
                          left: medPadding,
                          top: smallPadding * 2,
                          bottom: smallPadding),
                      color: Theme.of(context).accentColor,
                      child: Row(children: [
                        Expanded(
                          child: search(),
                        ),
                      ]),
                    )
              : Container(),
          MediaQuery.of(context).size.width > 900
              ? Container()
              : Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 1.0, //extend the shadow
                      offset: Offset(
                        0.0, // Move to right 10  horizontally
                        3.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ]),
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
                                  Text('Precio: ',
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 17)),
                                  DropdownButton<String>(
                                    hint: Text("Selecciona una opción"),
                                    value: chosenFilter,
                                    items: _fieldList.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                          width: 180,
                                          child: new Text(value.toString()),
                                          // height: 5.0,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String val) {
                                      setState(() {
                                        if (val == 'Menor a mayor') {
                                          loadProd = true;
                                          chosenFilter = val;
                                          priceFilter = "low_to_high";
                                          getProductos();
                                        } else if (val == 'Mayor a menor') {
                                          loadProd = true;
                                          chosenFilter = val;
                                          priceFilter = "high_to_low";
                                          getProductos();
                                        } else {
                                          if (priceFilter != null) {
                                            loadProd = true;
                                            priceFilter = null;
                                            chosenFilter = val;
                                            getProductos();
                                          }
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: smallPadding,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Solo disponibles en Stock',
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
                                        value: stock == null ? false : true,
                                        onChanged: (value) {
                                          setState(() {
                                            stock = value ? "available" : null;
                                            loadProd = true;
                                            getProductos();
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              // MultiSelectDialogField<Category>(
                              //   buttonText: Text('Categoría'),
                              //   buttonIcon: Icon(Icons.arrow_drop_down),
                              //   title: Text('Categorias'),
                              //   cancelText: Text('CANCELAR'),
                              //   searchable: true,
                              //   // listType: MultiSelectListType.CHIP,
                              //   items: _itemsCat,
                              //   // initialValue: _myCat,
                              //   onConfirm: (values) {
                              //     // setState(() {
                              //     //   _newCats = [];
                              //     //   for (int j = 0;
                              //     //       j <= values.length - 1;
                              //     //       j++) {
                              //     //     _newCats.add(values[j].id);
                              //     //   }
                              //     // });
                              //   },
                              //   // maxChildSize: 0.8,
                              // ),
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
                widget.jsonData.jsonData['farmacia_id'] != null
                    ? cardTienda()
                    : Container(),
                Flexible(
                  child: detallesTienda(snapshot.data),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  detallesTienda(snapshot) {
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
                          vertical: smallPadding, horizontal: smallPadding),
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
                          Text(
                            'Filtrar lista',
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
                                  'Precio ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(height: smallPadding),
                              DropdownButton<String>(
                                hint: Text("Elige una opción",
                                    style: TextStyle(fontSize: 15),
                                    overflow: TextOverflow.ellipsis),
                                value: chosenFilter,
                                items: _fieldList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      width: 100,
                                      child: new Text(value.toString()),
                                      // height: 5.0,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String val) {
                                  setState(() {
                                    if (val == 'Menor a mayor') {
                                      loadProd = true;
                                      chosenFilter = val;
                                      priceFilter = "low_to_high";
                                      getProductos();
                                    } else if (val == 'Mayor a menor') {
                                      loadProd = true;
                                      chosenFilter = val;
                                      priceFilter = "high_to_low";
                                      getProductos();
                                    } else {
                                      if (priceFilter != null) {
                                        loadProd = true;
                                        priceFilter = null;
                                        chosenFilter = val;
                                        getProductos();
                                      }
                                    }
                                  });
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: smallPadding),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Solo disponibles en Stock',
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
                                value: stock == null ? false : true,
                                onChanged: (value) {
                                  setState(() {
                                    stock = value ? "available" : null;
                                    loadProd = true;
                                    getProductos();
                                  });
                                },
                              ),
                            ],
                          ),
                          IgnorePointer(
                            ignoring: _itemsCat == null ? true : false,
                            child: MultiSelectDialogField<Category>(
                              searchHint: 'Buscar',
                              buttonText: Text(
                                'Categoría',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: 15),
                              ),
                              buttonIcon: Icon(Icons.arrow_drop_down),
                              title: Text(
                                'Categorias',
                              ),
                              cancelText: Text('CANCELAR'),
                              searchable: true,
                              listType: MultiSelectListType.CHIP,
                              items: _itemsCat,
                              initialValue: _myCat,
                              onConfirm: (values) {
                                setState(() {
                                  myCats = [];
                                  for (int j = 0; j <= values.length - 1; j++) {
                                    myCats.add(values[j].id);
                                  }
                                  loadProd = true;
                                  getProductos();
                                });
                              },
                              // maxChildSize: 0.8,
                            ),
                          ),
                          IgnorePointer(
                            ignoring: _itemsLabel == null ? true : false,
                            child: MultiSelectDialogField<Category>(
                              searchHint: 'Buscar',
                              buttonText: Text(
                                'Etiquetas',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: 15),
                              ),
                              buttonIcon: Icon(Icons.arrow_drop_down),
                              title: Text(
                                'Etiquetas',
                              ),
                              cancelText: Text('CANCELAR'),
                              searchable: true,
                              listType: MultiSelectListType.CHIP,
                              items: _itemsLabel,
                              initialValue: _myLabels,
                              onConfirm: (values) {
                                setState(() {
                                  myLabels = [];
                                  for (int j = 0; j <= values.length - 1; j++) {
                                    myLabels.add(values[j].id);
                                  }
                                  loadProd = true;
                                  getProductos();
                                });
                              },
                              // maxChildSize: 0.8,
                            ),
                          ),
                          /* SizedBox(height: smallPadding),
                          MultiSelectBottomSheetField(
                            searchHint: 'Buscar...',
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
                            items: _itemsCat,
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
                          ), */
                          // Expanded(
                          //   child: MultiSelectDialogField(
                          //     buttonText: Text('Categoría'),
                          //     buttonIcon: Icon(Icons.arrow_drop_down),
                          //     title: Text('Categorias'),
                          //     cancelText: Text('CANCELAR'),
                          //     searchable: true,
                          //     listType: MultiSelectListType.CHIP,
                          //     items: _itemsCat,
                          //     initialValue: _selectedCat,
                          //     onConfirm: (values) => print('ok'),
                          //     // maxChildSize: 0.8,
                          //   ),
                          // ),
                        ],
                      ),
                    )),
                Expanded(
                    child: loadProd
                        ? bodyLoad(context)
                        : errorProd
                            ? errorWidget(errorStrProd, context)
                            : listProducts(snapshot))
              ],
            ),
          )
        : Container(
            // height: size.height,
            color: bgGrey,
            child: loadProd
                ? bodyLoad(context)
                : errorProd
                    ? errorWidget(errorStrProd, context)
                    : listProducts(snapshot),
          );
  }

  cardTienda() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      padding: EdgeInsets.symmetric(
          vertical: smallPadding,
          horizontal: MediaQuery.of(context).size.width > 900
              ? medPadding * 10
              : smallPadding),
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: .1, // soften the shadow
            spreadRadius: .5, //extend the shadow
            offset: Offset(
              0.0, // Move to right 10  horizontally
              0.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('${miTienda['logo']}'),
                      fit: BoxFit.contain)),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.black),
                              text: miTienda['nombre'] + ' ',
                              children: <TextSpan>[
                                // TextSpan(
                                //   text: String.fromCharCode(57689), //<-- charCode
                                //   style: TextStyle(
                                //     fontFamily: 'MaterialIcons', //<-- fontFamily
                                //     fontSize: 15.0,
                                //     color: Colors.green,
                                //   ),
                                // )
                              ],
                            ),
                          ),
                          miTienda['estatus_verificacion'] == 'not_verified'
                              ? Container()
                              : Container(
                                  child: tiendaVerificada(),
                                ),
                        ]),
                    InkWell(
                      onTap: () => _displayDialog(miTienda),
                      // Clipboard.setData(
                      //     ClipboardData(text: "¡Compatrir url de Tienda!")),
                      child: Container(
                        height: 37,
                        width: 37,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(3),
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
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          Icons.share_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: smallPadding,
                ),
                Text(
                  '${miTienda['giro']}',
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                !widget.myStore
                    ? Container()
                    : SizedBox(
                        height: smallPadding,
                      ),
                !widget.myStore
                    ? Container()
                    : BotonSimple(
                        contenido: Text('Link a panel web',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        estilo: estiloBotonPrimary,
                        action: () => launchURL(
                            'https://app.drugsiteonline.com/farmacia/login'),
                      )
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         '35 productos',
                //         maxLines: 3,
                //         overflow: TextOverflow.ellipsis,
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             fontSize: 13, fontWeight: FontWeight.w600),
                //       ),
                //       Text(
                //         '26 ventas',
                //         maxLines: 3,
                //         overflow: TextOverflow.ellipsis,
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             fontSize: 13, fontWeight: FontWeight.w700),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }

  search() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 4,
          child: Container(
            height: 35,
            child: TextField(
              onChanged: (value) {
                if (value != null || value != '' || value != ' ') {
                  buscarStr = value;
                }
              },
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
                  hintText: 'Buscar...',
                  fillColor: MediaQuery.of(context).size.width > 900
                      ? bgGrey
                      : Colors.white,
                  filled: true),
            ),
          ),
        ),
        Flexible(
            flex: 2,
            child: BotonSimple(
                contenido: Text('Buscar',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                action: () {
                  setState(() {
                    loadProd = true;
                    userQuery = buscarStr;
                  });
                  getProductos();
                },
                estilo: estiloBotonPrimary)),
      ],
    );
    // return Container(
    //     // height: 50,
    //     child: Form(
    //   key: formKey,
    //   child: Row(
    //     children: [
    //       Flexible(
    //           flex: 3,
    //           child: Container(
    //             // color: bgGrey,
    //             margin: EdgeInsets.symmetric(vertical: 10),
    //             child: EntradaTexto(
    //               // onChanged: (value) {
    //               //   if (value == '') {
    //               //     setState(() {
    //               //       buscarStr = value;
    //               //       loadProd = true;
    //               //       userQuery = buscarStr;
    //               //     });
    //               //     getProductos();
    //               //   }
    //               // },
    //               valorInicial: userQuery,
    //               lineasMax: 1,
    //               onSaved: (value) {
    //                 setState(() {
    //                   buscarStr = value;
    //                 });
    //               },
    //               estilo: InputDecoration(
    //                   isDense: true,
    //                   counterText: "",
    //                   focusColor: bgGrey,
    //                   prefixIcon: Icon(Icons.search),
    //                   focusedBorder: OutlineInputBorder(
    //                       borderSide: BorderSide.none,
    //                       borderRadius: BorderRadius.circular(0)),
    //                   enabledBorder: OutlineInputBorder(
    //                       borderSide: BorderSide.none,
    //                       borderRadius: BorderRadius.circular(0)),
    //                   hintStyle: TextStyle(),
    //                   hintText: 'Buscar...',
    //                   fillColor: bgGrey,
    //                   filled: true,
    //                   hoverColor: bgGrey),
    //             ),
    //           )),
    //       Flexible(
    //           flex: 1,
    //           child: BotonSimple(
    //               contenido: Text('Buscar',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                   )),
    //               // contenido: Icon(Icons.search, color: Colors.white),
    //               estilo: estiloBotonPrimary,
    //               action: () {
    //                 formKey.currentState.save();
    //   setState(() {
    //     loadProd = true;
    //     userQuery = buscarStr;
    //   });
    //   getProductos();
    // })
    //           // : IconButton(
    //           //     onPressed: () {
    // setState(() {
    //   buscarStr = null;
    //   userQuery = buscarStr;
    // });
    // getProductos();
    //           //     },
    //           //     icon: Icon(Icons.close)),
    //           )
    //     ],
    //   ),
    // ));
  }

  // void searchOperation(String searchText) {
  //   searchList.clear();
  //   _handleSearchStart();
  //   if (_isSearching != null) {
  //     for (int i = 0; i < prod.length; i++) {
  //       String dataNombre = prod[i]['nombre'];
  //       if (dataNombre.toLowerCase().contains(searchText.toLowerCase())) {
  //         setState(() {
  //           searchList.add(prod[i]);
  //         });
  //       }
  //     }
  //   }
  // }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  listProducts(snapshot) {
    if (!finalList) {
      _scrollController
        ..addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            createProdList();
          }
        });
    }

    return prod.length == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('No se encontraron productos')],
            ),
          )
        : ListView(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            controller: finalList ? null : _scrollController,
            padding: EdgeInsets.all(smallPadding),
            children: [
              Container(
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: (250 / 350),
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0),
                    itemCount: prodLon,
                    itemBuilder: (BuildContext ctx, index) {
                      return productFav(
                          true,
                          _isSearching ? searchList[index] : prod[index],
                          snapshot);
                    }),
              ),
              // Container(
              //     child: GridView.count(
              //   shrinkWrap: true,
              //   childAspectRatio: (250 / 350),
              //   primary: false,
              //   // Create a grid with 2 columns. If you change the scrollDirection to
              //   // horizontal, this produces 2 rows.
              //   crossAxisCount: MediaQuery.of(context).size.width < 1150
              //       ? MediaQuery.of(context).size.width < 700
              //           ? MediaQuery.of(context).size.width < 500
              //               ? 2
              //               : 3
              //           : 4
              //       : 5,
              //   // Generate 100 widgets that display their index in the List.
              //   children: List.generate(prod.length, (index) {
              // return productFav(true,
              //     _isSearching ? searchList[index] : prod[index], snapshot);
              //   }),
              // ))
            ],
          );
  }

  //  Future<List<String>> pageFetch(int offset) async {
  //   print(offset);
  //   page = (offset / 20).round();
  //   // final Faker faker = Faker();
  //   final List<String> nextUsersList = List.generate(
  //     20,
  //     (int index) => User(
  //       faker.person.name() + ' - $page$index',
  //       faker.internet.email(),
  //     ),
  //   );
  //   await Future<List<User>>.delayed(Duration(seconds: 1));
  //   return page == 5 ? [] : nextUsersList;
  // }

  productFav(fav, prod, snapshot) {
    bool inCart = false;
    int index;

    if (snapshot.length > 0) {
      for (int i = 0; i <= snapshot.length - 1; i++) {
        if (snapshot[i].idDeProducto == prod['id_de_producto']) {
          inCart = true;
          index = i;
        }
      }
    }

    var size = MediaQuery.of(context).size;
    // final double itemHeight = 280;
    // final double itemWidth = 200;
    ProductoModel productoModel = ProductoModel();
    productoModel = ProductoModel.fromJson(prod);
    if (productoModel.favorito == false) {
      favProduct = false;
    } else {
      favProduct = true;
    }
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
      child: InkWell(
        onTap: () => Navigator.pushNamed(context,
                '/detalles/producto/' + productoModel.idDeProducto.toString())
            .then((value) {
          setState(() {});
          getProductos();
        }),
        child: Column(
          children: [
            Flexible(
                flex: 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    productoModel.galeria.length == 0
                        ? Image(
                            fit: BoxFit.contain,
                            image: AssetImage("images/logoDrug.png"),
                          )
                        : Image(
                            fit: BoxFit.contain,
                            image:
                                NetworkImage(productoModel.galeria[0]['url']),
                          ),
                    Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => addFav(productoModel.idDeProducto,
                              productoModel.favorito),
                          child: Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(3),
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
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              favProduct
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline,
                              color: Colors.pink[300],
                              size: 17,
                            ),
                          ),
                        )),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          width: 45,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.star, color: Colors.amber, size: 15),
                              RatingBarIndicator(
                                unratedColor: Colors.white.withOpacity(0.5),
                                rating: productoModel.rating == null
                                    ? 0
                                    : double.parse(productoModel.rating) *
                                        100 /
                                        5 /
                                        100,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 1,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                              Text(
                                  productoModel.rating == null
                                      ? "0"
                                      : double.parse(productoModel.rating)
                                          .toStringAsFixed(1),
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
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      productoModel.nombre,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      productoModel.nombre_farmacia,
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
                          '\$${productoModel.precio}',
                          style: TextStyle(
                              color: Colors.black45,
                              decoration:
                                  productoModel.precioConDescuento == null
                                      ? null
                                      : TextDecoration.lineThrough),
                        ),
                        productoModel.precioConDescuento == null
                            ? Container()
                            : Text(
                                '\$${productoModel.precioConDescuento}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700),
                              ),
                      ],
                    ),
                    int.parse(productoModel.stock) <= 0
                        ? Text(
                            'No disponilbe',
                            style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                flex: 2,
                                child: Material(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(40),
                                  child: new InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (inCart) {
                                          if (snapshot[index].cantidad > 1) {
                                            productoModel.cantidad =
                                                snapshot[index].cantidad - 1;
                                            _catalogBloc.sendEvent.add(
                                                EditCatalogItemEvent(
                                                    productoModel));
                                          } else {
                                            productoModel.cantidad =
                                                snapshot[index].cantidad;
                                            _catalogBloc.sendEvent.add(
                                                RemoveCatalogItemEvent(
                                                    productoModel));
                                          }
                                        }
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(40),
                                    child: new Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  // padding: EdgeInsets.symmetric(
                                  //     vertical: 0.3, horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: bgGrey),
                                  alignment: Alignment.center,
                                  child: Text(
                                      inCart
                                          ? snapshot[index].cantidad.toString()
                                          : '0',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Material(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(40),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        inCart
                                            ? productoModel.cantidad =
                                                snapshot[index].cantidad + 1
                                            : productoModel.cantidad = 1;
                                        _catalogBloc.sendEvent.add(
                                            EditCatalogItemEvent(
                                                productoModel));
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(40),
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(flex: 1, child: Container()),
                            ],
                          ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            inCart
                                ? productoModel.cantidad =
                                    snapshot[index].cantidad + 1
                                : productoModel.cantidad = 1;
                            _catalogBloc.sendEvent
                                .add(EditCatalogItemEvent(productoModel));
                          });
                        },
                        child: Text('Agregar al carrito',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _displayDialog(miFarmacia) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
                scrollable: true,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: smallPadding, vertical: smallPadding * 3),
                content: Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.height / 12,
                                child: getNetworkImage(miFarmacia['logo'])),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                "Copia este link y comparte ${miFarmacia['nombre']} y sus productos.",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: bgGrey,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              Container(
                                child: Flexible(
                                  child: Text(
                                    '¡Ve la farmacia ${miFarmacia['nombre']} en Drug! https://app.drugsiteonline.com/productos-tienda/${miFarmacia['farmacia_id'].toString()}/',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              BotonSimple(
                                  action: () {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            "¡Ve la famrmacia ${miFarmacia['nombre']} en Drug! https://app.drugsiteonline.com/productos-tienda/${miFarmacia['farmacia_id'].toString()}/"));
                                  },
                                  contenido: Text(
                                    'Copiar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  estilo: estiloBotonPrimary)
                            ],
                          ),
                        )
                      ],
                    )));
          });
        });
  }
}

tiendaVerificada() {
  return Container(
    child: RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black54,
        ),
        text: 'Tienda verificada ',
        children: <TextSpan>[
          TextSpan(
            text: String.fromCharCode(60661), //<-- charCode
            style: TextStyle(
              fontFamily: 'MaterialIcons', //<-- fontFamily
              fontSize: 15.0,
              color: Colors.orange[400],
            ),
          )
        ],
      ),
    ),
  );
}
