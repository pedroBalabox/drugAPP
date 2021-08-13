import 'dart:convert';

import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

var isSandbox = true;

var apiUrl = isSandbox
    ? 'https://sandbox.app.drugsiteonline.com'
    : 'https://api.production.drugsiteonline.com';

var baseFrontUrl = isSandbox
    ? 'https://sandboxfront.app.drugsiteonline.com'
    : 'https://app.drugsiteonline.com';

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
  'Farmacia de medicamentos',
  'Farmacia productos ',
  'Farmacia especializada'
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
    print("Error en la respuesta: " + err.toString());
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
