import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class TermCondVendedor extends StatefulWidget {
  TermCondVendedor({Key key}) : super(key: key);

  @override
  _TermCondVendedorState createState() => _TermCondVendedorState();
}

class _TermCondVendedorState extends State<TermCondVendedor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terminos y condiciones'),
      ),
      body: Container(),
    );
  }
}
