import 'dart:convert';

import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentFunctions extends StatefulWidget {
  final String module;
  PaymentFunctions({Key key, this.module}) : super(key: key);

  @override
  _PaymentFunctionsState createState() => _PaymentFunctionsState();
}

class _PaymentFunctionsState extends State<PaymentFunctions> {
  RestFun restFunction = RestFun();
  List<dynamic> cards;
  String errorStr;
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    sharedPrefs.init().then((value) => getCards());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCards() async {
    setState(() {
      cards = [];
      errorStr = "";
      loading = true;
      error = false;
    });
    await restFunction
        .restService(
            null, '$apiUrl/obtener/tarjetas', sharedPrefs.clientToken, 'get')
        .then((value) {
      //print("La respuesta: " + value.toString());
      if (value['status'] == 'server_true') {
        if (isJson(value['response'])) {
          setState(() {
            cards = jsonDecode(value['response'])[1]["cards"];
            loading = false;
            error = false;
            errorStr = value['message'];
          });
        }
      } else {
        setState(() {
          loading = false;
          error = true;
          errorStr = value['message'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.module) {
      case 'cards':
        return loading
            ? Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              )
            : error
                ? errorMessage()
                : Container(
                    child: ListView.builder(
                      itemCount: cards.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Icon iconCard = Icon(Icons.payment_outlined,
                            color: Colors.black.withOpacity(0.7));

                        switch (cards[index]['brand']) {
                          case 'visa':
                            iconCard = Icon(FontAwesomeIcons.ccVisa,
                                color: Colors.black.withOpacity(0.7));
                            break;
                          case 'mastercard':
                            iconCard = Icon(FontAwesomeIcons.ccMastercard,
                                color: Colors.black.withOpacity(0.7));
                            break;
                          case 'american_express':
                            iconCard = Icon(FontAwesomeIcons.ccAmex,
                                color: Colors.black.withOpacity(0.7));
                            break;
                          default:
                            iconCard = Icon(Icons.payment_outlined,
                                color: Colors.black.withOpacity(0.7));
                        }

                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: smallPadding / 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              iconCard,
                              Text(cards[index]["card_number"].toString()),
                              BotonRestTest(
                                  token: sharedPrefs.clientToken,
                                  url: '$apiUrl/eliminar/tarjeta',
                                  method: 'post',
                                  arrayData: {
                                    'card_id': cards[index]["id"].toString()
                                  },
                                  contenido: Text(
                                    'Eliminar',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  action: (value) {
                                    setState(() {
                                      cards.removeWhere((item) =>
                                          item["id"] == cards[index]["id"]);
                                    });
                                  },
                                  errorStyle: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  estilo: estiloBotonSecundary),
                            ],
                          ),
                        );
                      },
                    ),
                  );
        break;
    }
  }

  Widget errorMessage() {
    return Text(errorStr);
  }
}
