// import 'dart:convert';

// import 'package:drugapp/src/service/restFunction.dart';
// import 'package:drugapp/src/service/sharedPref.dart';
// import 'package:drugapp/src/utils/theme.dart';
// import 'package:drugapp/src/widget/testRest.dart';
// import 'package:flutter/material.dart';
// import 'package:drugapp/src/utils/globals.dart';

// class PaymentDropDown extends StatefulWidget {
//   final String module;
//   PaymentDropDown({Key key, this.module}) : super(key: key);

//   @override
//   _PaymentDropDownState createState() => _PaymentDropDownState();
// }

// class _PaymentDropDownState extends State<PaymentDropDown> {
//   RestFun restFunction = RestFun();
//   List<dynamic> cards;
//   String errorStr;
//   bool loading = true;
//   bool error = false;

//   @override
//   void initState() {
//     sharedPrefs.init().then((value) => getCards());
//     super.initState();
//   }

//   getCards() async {
//     setState(() {
//       cards = [];
//       errorStr = "";
//       loading = true;
//       error = false;
//     });
//     await restFunction
//         .restService(
//             null, '$apiUrl/obtener/tarjetas', sharedPrefs.clientToken, 'get')
//         .then((value) {
//       //print("La respuesta: " + value.toString());
//       if (value['status'] == 'server_true') {
//         if (isJson(value['response'])) {
//           setState(() {
//             cards = jsonDecode(value['response'])[1]["cards"];
//             loading = false;
//             error = false;
//             errorStr = value['message'];
//           });
//         }
//       } else {
//         setState(() {
//           loading = false;
//           error = true;
//           errorStr = value['message'];
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch (widget.module) {
//       case 'cards':
//         return loading
//             ? Container(
//                 width: 30,
//                 height: 30,
//                 child: CircularProgressIndicator(),
//               )
//             : error
//                 ? errorMessage()
//                 : Container(
//                     child: DropdownButtonFormField<dynamic>(
//                     hint: Text('Selecciona una tarjeta'),
//                     icon: Icon(
//                       Icons.arrow_drop_down,
//                       color: Theme.of(context).accentColor,
//                     ),
//                     items: cards.map((dynamic card) {
//                       return new DropdownMenuItem<dynamic>(
//                         value: card,
//                         child: new Text(card['card_number']),
//                       );
//                     }).toList(),
//                     onChanged: (val) {
//                       print(val);
//                     },
//                   ));
//         break;
//       default:
//         return Container();
//     }
//   }

//   Widget errorMessage() {
//     return Text(errorStr);
//   }
// }
