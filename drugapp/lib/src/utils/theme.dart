import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
      // Font
      fontFamily: 'OpenSans',
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.grey), // 1
      ),
      // Colors
      primaryColor: Color(0xff2895A8),
      accentColor: const Color(0xff00C5D5),
      scaffoldBackgroundColor: Colors.white,
      unselectedWidgetColor: Colors.black,
      dividerColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black)
      // textSelectionColor: Colors.grey[700]
      );
}

var bgGrey = Color(0xfff7f7f7);

Gradient gradientBlueLight = LinearGradient(
    // begin: Alignment.centerLeft,
    // end: Alignment.bottomLeft,
    colors: [const Color(0xff5ED6F2), const Color(0xff5ED6F2)]);

Gradient gradientAppBar = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topRight,
    colors: [const Color(0xff53DCF4), Color(0xff00C5D5)]);

Gradient gradientBlueDark = LinearGradient(
    // begin: Alignment.centerLeft,
    // end: Alignment.bottomLeft,
    colors: [const Color(0xff2895A8), const Color(0xff23ACC3)]);

Gradient gradientWhite = LinearGradient(
    // begin: Alignment.centerLeft,
    // end: Alignment.bottomLeft,
    colors: [Colors.white, Colors.white]);

Gradient gradientBluePurple = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xff00EBFF),
      Color(0xff259AC6),
      const Color(0xff8E27F5),
    ]);

Gradient gradientDrug = LinearGradient(
    // begin: Alignment.centerLeft,
    // end: Alignment.bottomLeft,
    colors: [Color(0xff00DAC4), Color(0xff114667), Color(0xffF836FF)]);

// padding
var smallPadding = 10.0;
var medPadding = 30.0;

BoxDecoration estiloBotonPrimary = BoxDecoration(boxShadow: [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    blurRadius: 5.0, // soften the shadow
    spreadRadius: 1.0, //extend the shadow
    offset: Offset(
      0.0, // Move to right 10  horizontally
      3.0, // Move to bottom 10 Vertically867
    ),
  )
], gradient: gradientBlueDark);

BoxDecoration estiloBotonSecundary = BoxDecoration(boxShadow: [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    blurRadius: 5.0, // soften the shadow
    spreadRadius: 1.0, //extend the shadow
    offset: Offset(
      0.0, // Move to right 10  horizontally
      3.0, // Move to bottom 10 Vertically867
    ),
  )
], gradient: gradientBlueLight);

var colorRed = Colors.red[600];
inputPrimarystyle(context, icon, labelText, hintText) {
  return InputDecoration(
      counterText: "",
      prefixIcon: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.black38,
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.black54,
        fontSize: 15,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red[600]),
      ),
      errorStyle: TextStyle(color: Colors.red[600]),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red[600],
        ),
      ));
}

Gradient gradientGreen = LinearGradient(
    // begin: Alignment.centerLeft,
    // end: Alignment.bottomLeft,
    colors: [const Color(0xfd56ab2f), const Color(0xff45B649)]);

BoxDecoration estiloValidar = BoxDecoration(boxShadow: [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    blurRadius: 5.0, // soften the shadow
    spreadRadius: 1.0, //extend the shadow
    offset: Offset(
      0.0, // Move to right 10  horizontally
      3.0, // Move to bottom 10 Vertically867
    ),
  )
], gradient: gradientGreen);

TextStyle estiloErrorStr = TextStyle(
  color: Colors.red[700],
  fontWeight: FontWeight.w600,
);
