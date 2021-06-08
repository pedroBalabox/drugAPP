import 'dart:convert';

import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';
import 'package:drugapp/src/utils/globals.dart';

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
                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: smallPadding / 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.payment_outlined),
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