import 'dart:convert';
import 'dart:io';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/model/product_model.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/drawerVendedor_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class Category {
  final String id;
  final String name;

  Category({
    this.id,
    this.name,
  });
}

class ImageGallery {
  final String id;
  final dynamic path;
  final String type;

  ImageGallery({this.id, this.path, this.type});
}

class EditarProducto extends StatefulWidget {
  static const routeName = '/farmacia/editar-prodcuto';

  final dynamic jsonProducto;

  EditarProducto({Key key, this.jsonProducto}) : super(key: key);

  @override
  _EditarProductoState createState() => _EditarProductoState();
}

class _EditarProductoState extends State<EditarProducto> {
  List<Category> _categories = [];

  var _items;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProductoModel productoModel = ProductoModel();

  SwiperController swiperController = SwiperController();
  RestFun rest = RestFun();

  dynamic labels = [];

  List base64Gallery = [];

  var jsonGallery;

  var _itemCat;

  var _newCats = [];

  bool load = true;

  List<Category> _myCat = [];

  @override
  void initState() {
    super.initState();
    sharedPrefs.init().then((value) {
      rest
          .restService(null, '${urlApi}obtener/categorias',
              sharedPrefs.partnerUserToken, 'get')
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
              _items = _categories
                  .map((cat) => MultiSelectItem<Category>(cat, cat.name))
                  .toList();
            });
          }

          for (int j = 0; j <= _categories.length - 1; j++) {
            for (int i = 0; i <= productoModel.categorias.length - 1; i++) {
              if (productoModel.categorias[i]['categoria_id'] ==
                  _categories[j].id) {
                _myCat.add(_categories[j]);
              }
            }
          }

          setState(() {
            load = false;
          });
        }
      });
    });

    productoModel = ProductoModel.fromJson(widget.jsonProducto.jsonProducto);

    labeltoList();
    setState(() {
      jsonGallery = jsonDecode(jsonEncode(productoModel.galeria));
    });

    print('----' + productoModel.categorias.toString());
  }

  @override
  void dispose() {
    swiperController.dispose();
    super.dispose();
  }

  labeltoList() {
    if (productoModel.etiqueta1 != null) {
      labels.add(productoModel.etiqueta1);
    }
    if (productoModel.etiqueta2 != null) {
      labels.add(productoModel.etiqueta2);
    }
    if (productoModel.etiqueta3 != null) {
      labels.add(productoModel.etiqueta3);
    }
    if (productoModel.etiqueta4 != null) {
      labels.add(productoModel.etiqueta4);
    }
    if (productoModel.etiqueta5 != null) {
      labels.add(productoModel.etiqueta5);
    }
  }

  deletePicture(archivoId) async {
    var arrayData = {
      "id_de_producto": productoModel.idDeProducto,
      "archivo_id": archivoId,
    };
    await rest
        .restService(arrayData, '${urlApi}eliminar/imagen-producto',
            sharedPrefs.partnerUserToken, 'post')
        .then((value) {
      if (value['status'] != 'server_true') {
        var productosResp = value['response'];
        print(productosResp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBarVendedor(
      title: 'Editar prodcuto',
      screenWidht: MediaQuery.of(context).size.width,
      body: bodyProducto(),
    );
  }

  bodyProducto() {
    var size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width > 700 ? size.width / 3 : medPadding * .5,
            vertical: medPadding * 1.5),
        color: bgGrey,
        width: size.width,
        child: tabProdcuto(),
      ),
      footer(context),
    ]);
  }

  tabProdcuto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Imágenes del producto',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: miGaleria()),
        SizedBox(
          height: medPadding,
        ),
        Text(
          'Información del producto',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: miProducto(context)),
        SizedBox(
          height: medPadding,
        ),
        Text(
          'Categorias',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        SizedBox(
          height: smallPadding,
        ),
        Container(child: miEtiqeuta(context)),
        SizedBox(
          height: medPadding,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: smallPadding, horizontal: medPadding),
          child: BotonRestTest(
            arrayData: {
              "id_de_producto": productoModel.idDeProducto,
              "sku": productoModel.sku,
              "descripcion": productoModel.descripcion,
              "precio": productoModel.precio,
              "precio_con_descuento": productoModel.precioConDescuento,
              "precio_mayoreo": productoModel.precioMayoreo,
              "cantidad_mayoreo": int.parse(productoModel.cantidadMayoreo),
              "categorias": _newCats,
              "galeria": base64Gallery
            },
            token: sharedPrefs.partnerUserToken,
            method: 'post',
            showSuccess: true,
            stringCargando: 'Actualizando producto...',
            action: (value) => null,
            url: '${urlApi}actualizar/mi-producto',
            contenido: Text('Actualizar producto',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal)),
            estilo: estiloValidar,
          ),
        )
      ],
    );
  }

  miGaleria() {
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.7,
            child: productSwiper(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              jsonGallery.length >= 10
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: smallPadding),
                      child: BotonSimple(
                        action: () =>
                            jsonGallery.length >= 10 ? null : pickImage(),
                        contenido: Text('Agregar imágen',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal)),
                        estilo: estiloBotonSecundary,
                      ),
                    ),
              // base64Gallery.length == 0
              //     ? Container()
              // : Padding(
              //     padding: EdgeInsets.symmetric(vertical: smallPadding),
              //     child: BotonSimple(
              //       action: () =>
              //           jsonGallery.length >= 10 ? null : pickImage(),
              //       contenido: Text('Guardar',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 15,
              //               fontWeight: FontWeight.normal)),
              //       estilo: estiloValidar,
              //     ),
              //   )
            ],
          )
        ],
      ),
    );
  }

  pickImage() async {
    final _picker = ImagePicker();
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 30);
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
      base64Gallery.add(imgBase64Str);
      var image = ImageGallery(id: '', path: imgBase64Str, type: 'base64');
      var listOfMaps = List<Map<String, dynamic>>();
      listOfMaps.add({'id': image.id, 'path': image.path, 'type': image.type});
      jsonGallery.add(listOfMaps[0]);
    });
    callback();
  }

  callback() async {
    await swiperController.next();
  }

  productSwiper() {
    return Swiper(
      key: UniqueKey(),
      // control: SwiperControl(),
      // controller: swiperController,
      itemCount: jsonGallery.length,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Stack(
          children: [
            Center(
                child: jsonGallery[index]['type'] == 'network'
                    ? Image.network("${jsonGallery[index]['url']}",
                        fit: BoxFit.cover)
                    : Image.memory(base64Decode(jsonGallery[index]['path']),
                        fit: BoxFit.cover)),
            InkWell(
              onTap: () {
                _showMyDialogphoto(jsonGallery[index])
                    .then((value) => setState(() {}));
              },
              child: Container(
                  // padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(50)),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
      autoplay: false,
      scrollDirection: Axis.horizontal,
      pagination: new SwiperPagination(
          builder: new DotSwiperPaginationBuilder(
              color: Colors.grey.withOpacity(0.5),
              activeColor: Theme.of(context).primaryColor),
          margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          alignment: Alignment.bottomCenter),
    );
  }

  Future<void> _showMyDialogphoto(photoDetail) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar imágen',
            style: TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Eliminar',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                swiperController.previous();
                setState(() {
                  jsonGallery.remove(photoDetail);
                  if (photoDetail['type'] == 'base64') {
                    base64Gallery.remove(photoDetail['path']);
                  } else {
                    deletePicture(photoDetail["archivo_id"]);
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // deletePhoto(photoId) async {
  //   await verdeService
  //       .deleteService(
  //           'productos/imagenes?id=$photoId&producto_id=${widget.productId}',
  //           sharedPrefs.partnerUserToken)
  //       .then((serverResp) {
  //     if (serverResp['status'] == 'server_true') {
  //       var jsonCat = jsonDecode(serverResp['response']);
  //       print(jsonCat['message']);
  //       Navigator.pop(context);
  //       // getProducts();
  //       messageToUser(_scaffoldKey, jsonCat['message']);
  //     } else {
  //       var jsonCat = jsonDecode(serverResp['response']);
  //       Navigator.pop(context);
  //       // getProducts();
  //       messageToUser(_scaffoldKey, jsonCat['message']);
  //     }
  //   }).then((value) => getProducts());
  // }

  miProducto(context) {
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
            formProducto(),
          ],
        ));
  }

  formProducto() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EntradaTexto(
            valorInicial: productoModel.nombre,
            habilitado: false,
            estilo: inputPrimarystyle(
                context, Icons.medical_services_outlined, 'Nombre', null),
            tipoEntrada: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.words,
            tipo: 'nombre',
            onChanged: (value) {
              setState(() {
                // name = value;
              });
            },
          ),
          EntradaTexto(
            valorInicial: productoModel.marca,
            habilitado: false,
            estilo: inputPrimarystyle(context, Icons.medical_services_outlined,
                'Laboratorio / Marca', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'textoLargo',
            onChanged: (value) {
              setState(() {});
            },
          ),
          EntradaTexto(
            valorInicial: productoModel.sku,
            habilitado: false,
            estilo: inputPrimarystyle(
                context, Icons.medical_services_outlined, 'SKU', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'textoLargo',
            onChanged: (value) {
              setState(() {});
            },
          ),
          EntradaTexto(
            valorInicial: productoModel.descripcion,
            estilo: inputPrimarystyle(
                context, Icons.info_outline, 'Descripción', null),
            textCapitalization: TextCapitalization.words,
            tipo: 'textoLargo',
            lineasMax: 10,
            onChanged: (value) {
              setState(() {
                productoModel.descripcion = value;
              });
            },
          ),
          Row(
            children: [
              Flexible(
                child: EntradaTexto(
                  habilitado: false,
                  valorInicial: productoModel.precio,
                  estilo: inputPrimarystyle(
                      context, Icons.attach_money_outlined, 'Precio', null),
                  tipoEntrada: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  tipo: 'textoLargo',
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Flexible(
                child: EntradaTexto(
                  habilitado: false,
                  valorInicial: productoModel.precioConDescuento,
                  estilo: inputPrimarystyle(
                      context,
                      Icons.attach_money_outlined,
                      'Precio con Descuento',
                      null),
                  tipoEntrada: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  tipo: 'textolargo',
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: EntradaTexto(
                  habilitado: false,
                  valorInicial: productoModel.precioMayoreo,
                  estilo: inputPrimarystyle(context,
                      Icons.attach_money_outlined, 'Precio mayorista', null),
                  tipoEntrada: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  tipo: 'textolargo',
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Flexible(
                child: EntradaTexto(
                  habilitado: false,
                  valorInicial: productoModel.cantidadMayoreo,
                  estilo: inputPrimarystyle(context, Icons.add_box_outlined,
                      'Cantidad mayoreo', null),
                  tipoEntrada: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  tipo: 'textolargo',
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: productoModel.stock,
            estilo: inputPrimarystyle(
                context, Icons.add_box_outlined, 'Stock', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'textolargo',
            onChanged: (value) {
              setState(() {});
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: productoModel.categoria,
            estilo: inputPrimarystyle(
                context, Icons.medical_services_outlined, 'Categoría', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'textolargo',
            onChanged: (value) {
              setState(() {});
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: productoModel.subcategoria1,
            estilo: inputPrimarystyle(
                context, Icons.medical_services_outlined, 'SubCategoría', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'textolargo',
            onChanged: (value) {
              setState(() {});
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: productoModel.subcategoria2,
            estilo: inputPrimarystyle(
                context, Icons.medical_services_outlined, 'SubCategoría', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'textolargo',
            onChanged: (value) {
              setState(() {});
            },
          ),
          EntradaTexto(
            habilitado: false,
            valorInicial: productoModel.subcategoria3,
            estilo: inputPrimarystyle(
                context, Icons.medical_services_outlined, 'SubCategoría', null),
            tipoEntrada: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            tipo: 'textolargo',
            onChanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  miEtiqeuta(context) {
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
            load
                ? Container()
                : MultiSelectDialogField<Category>(
                    buttonText: Text('Categoría'),
                    buttonIcon: Icon(Icons.arrow_drop_down),
                    title: Text('Categorias'),
                    cancelText: Text('CANCELAR'),
                    searchable: true,
                    listType: MultiSelectListType.CHIP,
                    items: _items,
                    initialValue: _myCat,
                    onConfirm: (values) {
                      setState(() {
                        _newCats = [];
                        for (int j = 0; j <= values.length - 1; j++) {
                          _newCats.add(values[j].id);
                        }
                      });
                    },
                    // maxChildSize: 0.8,
                  ),
            labelsWidget(),
          ],
        ));
  }

  labelsWidget() {
    return Wrap(
      children: labels
          .map((item) => Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(smallPadding / 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor.withOpacity(0.7)),
              child: Text(
                item,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              )))
          .toList()
          .cast<Widget>(),
    );
  }
}
