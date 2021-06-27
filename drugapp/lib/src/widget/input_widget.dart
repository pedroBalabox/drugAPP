import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EntradaTextoTest extends StatefulWidget {
  final String tipo;
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String> onChanged;
  final FormFieldSetter<String> onSub;
  final Function onEditingComplete;
  final bool habilitado;
  final int lineasMax;
  final int longMaxima;
  final int longMinima;
  final String valorInicial;
  final TextCapitalization textCapitalization;
  final InputDecoration estilo;
  final TextInputAction action;
  final TextInputType tipoEntrada;
  final GlobalKey<FormState> formkey;
  final String validacionStr;
  final bool requerido;
  final FocusNode focusnode;

  EntradaTextoTest(
      {Key key,
      this.tipo = 'textoCorto',
      this.onSaved,
      this.onChanged,
      this.onSub,
      this.habilitado = true,
      this.lineasMax = 1,
      this.longMaxima,
      this.longMinima,
      this.valorInicial,
      this.textCapitalization = TextCapitalization.sentences,
      this.estilo,
      this.action = TextInputAction.next,
      this.tipoEntrada = TextInputType.name,
      this.onEditingComplete,
      this.formkey,
      this.validacionStr = 'Campo olbigatorio',
      this.requerido = true,
      this.focusnode})
      : super(key: key);

  @override
  _EntradaTextoTestState createState() => _EntradaTextoTestState();
}

class _EntradaTextoTestState extends State<EntradaTextoTest> {
  Function(String) typeValidator;
  int maxCharacters;

  @override
  Widget build(BuildContext context) {
    switch (widget.tipo) {
      case "texto":
        typeValidator = (value) {
          if (widget.longMinima != null) {
            if (value.isEmpty || value.length < widget.longMinima) {
              return widget.validacionStr;
            } else {
              return null;
            }
          } else {
            if (value.isEmpty || value.length < 10) {
              return widget.validacionStr;
            } else {
              return null;
            }
          }
        };
        setState(() {
          maxCharacters = widget.longMaxima == null ? 20 : widget.longMaxima;
        });
        break;
      default:
        typeValidator = (value) {
          if (widget.longMinima != null) {
            if (value.isEmpty || value.length < widget.longMinima) {
              return widget.validacionStr;
            } else {
              return null;
            }
          } else {
            if (value.isEmpty || value.length < 10) {
              return widget.validacionStr;
            } else {
              return null;
            }
          }
        };
        setState(() {
          maxCharacters = widget.longMaxima == null ? 20 : widget.longMaxima;
        });
    }

    return TextFormField(
      focusNode: widget.focusnode,
      onFieldSubmitted: widget.onSub,
      decoration: widget.estilo,
      validator: widget.tipo == 'correo'
          ? (input) => input.isValidEmail() ? null : "Ingresa un correo"
          : widget.requerido
              ? typeValidator
              : null,
      maxLength: maxCharacters,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      obscureText: widget.tipo == 'password' ? true : false,
      enabled: widget.habilitado,
      maxLines: widget.lineasMax,
      initialValue: widget.valorInicial,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.action,
      keyboardType: widget.tipoEntrada,
      inputFormatters: widget.tipo == 'numeroINT' ||
              widget.tipo == 'moneda' ||
              widget.tipo == 'telefono'
          ? [
              // DecimalTextInputFormatter(),
              FilteringTextInputFormatter.allow(RegExp("[0-9 .]"))
            ]
          : null,
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
