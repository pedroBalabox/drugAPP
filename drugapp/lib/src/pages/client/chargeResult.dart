import 'dart:convert';

import 'package:codigojaguar/codigojaguar.dart';
import 'package:drugapp/src/service/restFunction.dart';
import 'package:drugapp/src/service/sharedPref.dart';
import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/assetImage_widget.dart';
import 'package:drugapp/src/widget/testRest.dart';
import 'package:flutter/material.dart';

class ChargeResult extends StatefulWidget {
  String chargeId;
  ChargeResult({Key key, this.chargeId}) : super(key: key);

  @override
  _ChargeResultState createState() => _ChargeResultState();
}

class _ChargeResultState extends State<ChargeResult> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String chargeId;
  bool checkingStatus = true;

  @override
  void initState() {
    super.initState();
    if (widget.chargeId != null) {
      chargeId = widget.chargeId;
      checkChargeStatus();
    }
  }

  final sharedPrefs = SharedPrefs();
  bool sucessfullPayment = false;
  String messageToUser =
      "Estamos verificando el estatus de tu pago, espera un momento.";
  RestFun rest = RestFun();
  checkChargeStatus() async {
    print("CHP");
    /* if (true) {
      setState(() {
        messageToUser = "Todo bien";
        sucessfullPayment = true;
      });
    } else {
      setState(() {
        sucessfullPayment = false;
        messageToUser = "Todo mal";
      });
    } */
    var arrayData = {"charge_id": chargeId};
    await rest
        .restService(arrayData, '$apiUrl/obtener/estatus/cargo', "", 'post')
        .then((value) {
      print(value);
      if (value['status'] == 'server_true') {
        var dataResp = value['response'];
        dataResp = jsonDecode(dataResp);

        setState(() {
          messageToUser = value['message'].toString();
          sucessfullPayment = true;
          checkingStatus = false;
        });
      } else {
        setState(() {
          sucessfullPayment = false;
          messageToUser = value['message'].toString();
          checkingStatus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).accentColor,
          title: Text("Resultado de Pago"),
          actions: [
            Container(
              padding: EdgeInsets.all(5),
              height: 50,
              width: 55,
              child: getAsset('logoDrug.png', 0.0),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              checkingStatus
                  ? SizedBox()
                  : sucessfullPayment
                      ? Image(
                          width: 100,
                          image: AssetImage("images/checkIcon.png"),
                        )
                      : Image(
                          width: 100,
                          image: AssetImage("images/crossIcon.png"),
                        ),
              SizedBox(
                height: 15,
              ),
              Text(
                checkingStatus
                    ? "Revisando información del cargo..."
                    : sucessfullPayment
                        ? "¡Enhorabuena! Tu pago se realizó con éxito"
                        : "¡Hubo un error al procesar tu pago!",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 7,
              ),
              checkingStatus
                  ? Text(messageToUser, style: TextStyle(fontSize: 19))
                  : SizedBox(),
              Text(
                  "Si la compra la hiciste desde la aplicación móvil, sólo debes cerrar esta pestaña e ir a tus compras.",
                  style: TextStyle(fontSize: 19)),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/miCuenta');
                },
                child: Container(
                  decoration: estiloBotonPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  child: Text(
                    "Ir a mi cuenta",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
