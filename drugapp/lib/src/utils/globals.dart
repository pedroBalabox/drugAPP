import 'dart:convert';
import 'dart:io';

import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

var isSandbox = true;

var apiUrl = isSandbox
    ? 'https://sandbox.api.drugmexico.com'
    : 'https://api.drugmexico.com';

var baseFrontUrl =
    isSandbox ? 'https://sandbox.drugmexico.com' : 'https://drugmexico.com';

messageToUser(key, String message) {
  final snackBar = SnackBar(content: Text(message));
  key.currentState.showSnackBar(snackBar);
}

var dummyCat =
    '[{"name": "Antibióticos", "icon": "57619", "img": "drug2.jpg"},{"name": "Dermatología", "icon": "59653", "img": "drug2.jpg"}, {"name": "Pediatría", "icon": "58717", "img": "drug2.jpg"}, {"name": "Vacunas", "icon": "58051", "img": "drug2.jpg"}, {"name": "Más categorías", "icon": "58736", "img": "drug2.jpg"}]';

var dummyProd =
    '[{"nombre": "Abrunt desloratadina C/10 Tabs 5MG", "img": "med3.png", "farmacia": "Farmacias Guadalajara", "price": "84.0", "fav": true, "priceOferta": null, "stars": "3.0"}, {"nombre": "Acarbosa 50MG C/30 Tambs Amsa", "img": "med1.png", "farmacia": "Farmacias Guadalajara", "price": "25.0", "fav": true, "priceOferta": null, "stars": "4.7"}, {"name": "A-D Kan Vitaminas A-D 3 ML C/3 AMP", "img": "med2.jpg", "farmacia": "Farmacias Guadalajara", "price": "25.0", "fav": true, "priceOferta": null, "stars": "4.7"}, {"nombre": "Abrunt desloratadina C/10 Tabs 5MG", "img": "med3.png", "farmacia": "Farmacias Guadalajara", "price": "84.0", "fav": true, "priceOferta": null, "stars": "3.0"}, {"name": "Acarbosa 50MG C/30 Tambs Amsa", "img": "med1.png", "farmacia": "Farmacias Guadalajara", "price": "25.0", "fav": true, "priceOferta": null, "stars": "4.7"}, {"nombre": "A-D Kan Vitaminas A-D 3 ML C/3 AMP", "img": "med2.jpg", "farmacia": "Farmacias Guadalajara", "price": "25.0", "fav": true, "priceOferta": null, "stars": "4.7"}, {"name": "Abrunt desloratadina C/10 Tabs 5MG", "img": "med3.png", "farmacia": "Farmacias Guadalajara", "price": "84.0", "fav": true, "priceOferta": null, "stars": "3.0"}]';

var dummyCompras =
    '[{"name": "Acarbosa 50MG C/30 Tambs Amsa", "img": "med1.png", "farmacia": "Farmacias Guadalajara", "price": "25.0", "stars": null, "status": "preparacion", "idCompra": "123", "fechaEntrga": null, "fechaTent": "16-04-21", "fecha": "04-04-21"}, {"name": "A-D Kan Vitaminas A-D 3 ML C/3 AMP", "img": "med2.jpg", "farmacia": "Farmacias Guadalajara", "price": "25.0", "stars": "4.7", "status": "entregado", "idCompra": "123", "fechaEntrga": "04-04-21", "fechaTent": "16-04-21", "fecha": "04-04-21"}, {"name": "Abrunt desloratadina C/10 Tabs 5MG", "img": "med3.png", "farmacia": "Farmacias Guadalajara", "price": "84.0", "priceOferta": null, "stars": null, "status": "camino", "idCompra": "123", "fechaEntrga": null, "fechaTent": "16-04-21", "fecha": "04-04-21"}]';

var dummyTienda =
    '[{"name": "Farmacias Guadalajara", "img": "farm0.png", "descripcion": "Somos la Farmacia Digital con un amplio catálogo de medicamentos especializados, genéricos y marca propia"}, {"name": "Farmacias del Ahorra", "img": "farm1.jpg", "descripcion": "Somos la Farmacia Digital con un amplio catálogo de medicamentos especializados, genéricos y marca propia"}, {"name": "Farmacias Benavides", "img": "farm2.jpeg", "descripcion": "Somos la Farmacia Digital con un amplio catálogo de medicamentos especializados, genéricos y marca propia"}, {"name": "Farmacias Guadalajara", "img": "farm3.png", "descripcion": "Somos la Farmacia Digital con un amplio catálogo de medicamentos especializados, genéricos y marca propia"}, {"name": "Farmacias Guadalajara", "img": "farm0.png", "descripcion": "Somos la Farmacia Digital con un amplio catálogo de medicamentos especializados, genéricos y marca propia"}, {"name": "Farmacias del Ahorra", "img": "farm1.jpg", "descripcion": "Somos la Farmacia Digital con un amplio catálogo de medicamentos especializados, genéricos y marca propia"}, {"name": "Farmacias Benavides", "img": "farm2.jpeg", "descripcion": "Somos la Farmacia Digital con un amplio catálogo de medicamentos especializados, genéricos y marca propia"}, {"name": "Farmacias Guadalajara", "img": "farm3.png", "descripcion": "Somos la Farmacia Digital con un amplio catálogo de medicamentos especializados, genéricos y marca propia"}]';

var dummyUser =
    '{"nombre": "Andrea", "primer_apellido": "Sandoval", "segundo_apellido": "Gomez Farias", "usuario_id": "user123", "img_url": "https://www.latercera.com/resizer/QVU6EteFU6dR2pFZEk69FLabDUE=/900x600/smart/arc-anglerfish-arc2-prod-copesa.s3.amazonaws.com/public/PGLG6B6CCFEXVCYIQSHQ3ZTXM4.jpg"}';

var documents = [
  'Aviso de funcionamiento',
  'Acta constitutiva',
  'Comprobante de domicilio',
  'INE vigente',
  'Cédula fiscal SAT'
];

var dummyVenta =
    '[{"id": "venta_1", "fecha": "23-02-2021", "estado": "En camino", "total": "253.00", "product_list":""}, {"id": "venta_2", "fecha": "23-02-2021", "estado": "En camino", "total": "253.00", "product_list":""}]';

var dummyDocs =
    '{"avi_func": "active", "act_cons": "active", "comp_dom": "active", "ine": "active", "ced_fis": "rejected"}';

var giroFarmacia = [
  'Farmacia',
  'Farmacia Especializada',
  'Laboratorio',
  'Marca',
  'Mayorista',
  'Minorista',
  'Importadora',
  'Comercializadora',
  'Distribuidor'
];

Widget footer(context) {
  return Container(
    padding: EdgeInsets.all(medPadding / 2),
    width: MediaQuery.of(context).size.width,
    color: Color(0xffefefef),
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Drug Farmacéutica. ',
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey),
        children: <TextSpan>[
          TextSpan(
              text: 'Todos los derechos reservados 2021.',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400))
        ],
      ),
    ),
  );
}

Widget footerVendedor(context) {
  return Container(
      padding: EdgeInsets.all(medPadding / 2),
      width: MediaQuery.of(context).size.width,
      color: Color(0xffefefef),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Drug Farmacéutica. ',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey),
          children: <TextSpan>[
            TextSpan(
                text: 'Todos los derechos reservados 2021.',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
            TextSpan(
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  launchURL(
                      'https://app.drugsiteonline.com/farmacia/terminos-y-condiciones');
                },
              text: 'Términos y condiciones',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            )
          ],
        ),
      ));
}

launchURL(myurl) async {
  if (await canLaunch(myurl)) {
    await launch(myurl);
  } else {
    throw 'Could not launch $myurl';
  }
}

Widget errorWidget(errorStr, context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.close),
        SizedBox(height: smallPadding),
        Text(errorStr)
      ],
    ),
  );
}

bodyLoad(context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: CircularProgressIndicator(),
        )
      ],
    ),
  );
}

isJson(string) {
  String jsonString = string;
  bool decodeSucceeded = false;
  try {
    jsonDecode(jsonString);
    decodeSucceeded = true;
  } catch (err) {
    //print("Error en la respuesta: " + err.toString());
  }
  return decodeSucceeded;
}

getNetworkImage(String path) {
  return Image.network(
    path,
    fit: BoxFit.cover,
    errorBuilder:
        (BuildContext context, Object exception, StackTrace stackTrace) {
      return Image.asset('images/logoDrug.png');
    },
    loadingBuilder:
        (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        );
      }
    },
  );
}

getNetworkProductImage(String path) {
  return Image.network(
    path,
    fit: BoxFit.cover,
    errorBuilder:
        (BuildContext context, Object exception, StackTrace stackTrace) {
      return Image.asset('images/productPH.jpeg');
    },
    loadingBuilder:
        (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        );
      }
    },
  );
}

isLandscape(image) {
  if (image.width > image.height) {
    return true;
  } else {
    return false;
  }
}

void showErrorDialog(context, title, message) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new InkWell(
            child: new Text("Cerrar"),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showLoadingDialog(context, title, message) {
  // flutter defined function
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
      );
    },
  );
}

processImage(context, bytes, maxSize, quality, maxMegabytes) async {
  final bytesSize = bytes.lengthInBytes;
  final kb = bytesSize / 1024;
  final mb = kb / 1024;

  String encodedImage = "";

  if (mb > maxMegabytes) {
    Navigator.of(context).pop();
    showErrorDialog(
        context, "Imagen muy grande", "La imagen debe pesar menos de 1 mb");
  } else {
    img.Image chosenImage = img.decodeImage(bytes);
    img.Image thumbnail = isLandscape(chosenImage)
        ? img.copyResize(chosenImage, width: maxSize)
        : img.copyResize(chosenImage, height: maxSize);
    encodedImage = base64Encode(img.encodeJpg(thumbnail, quality: quality));
  }
  return encodedImage;
}

Future<String> preprocessImage(image, context, maxSize, quality,
    {maxMegabytes: 1}) async {
  var imgBase64Str;
  if (kIsWeb) {
    http.Response response = await http.get(Uri.parse(image.path));
    final bytes = response?.bodyBytes;
    imgBase64Str =
        await processImage(context, bytes, maxSize, quality, maxMegabytes);
    if (imgBase64Str == "") {
      return "";
    }
    Navigator.of(context).pop();
  } else {
    List<int> imageBytes = await File(image.path).readAsBytes();
    imgBase64Str = base64Encode(imageBytes);
    Navigator.of(context).pop();
  }
  return imgBase64Str;
}
