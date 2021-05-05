// import 'package:drugapp/src/utils/theme.dart';
// import 'package:flutter/material.dart';

// import 'buttom_widget.dart';

// class FormAction extends StatefulWidget {
//   final GlobalKey<FormState> fomrkey;
//   final Widget listfields;
//   final String actionText;
//   final gradientColor;
//   final botonAction;
//   final Widget extraWidget;
//   FormAction(
//       {Key key,
//       this.listfields,
//       this.botonAction,
//       this.fomrkey,
//       this.actionText,
//       this.gradientColor,
//       this.extraWidget})
//       : super(key: key);

//   @override
//   _FormActionState createState() => _FormActionState();
// }

// class _FormActionState extends State<FormAction> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           widget.listfields,
//           widget.extraWidget == null ? Container() : widget.extraWidget,
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 50.0),
//             child: SimpleButtom(
//                 gcolor: widget.gradientColor,
//                 mainText: widget.actionText.toString(),
//                 textWhite: true,
//                 pressed: () {
//                   if (_formKey.currentState.validate()) {
//                     _formKey.currentState.save();
//                     widget.botonAction;
//                   }
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }
