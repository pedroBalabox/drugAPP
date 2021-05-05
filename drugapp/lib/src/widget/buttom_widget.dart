import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';

class SimpleButtom extends StatefulWidget {
  const SimpleButtom({
    @required this.mainText,
    this.pressed ,
    this.gcolor,
    this.textWhite = true,
  });

  final String mainText;
  final Function pressed;
  final Gradient gcolor;
  final bool textWhite;

  @override
  _SimpleButtomState createState() => _SimpleButtomState();
}

class _SimpleButtomState extends State<SimpleButtom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 5.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                3.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          // borderRadius: BorderRadius.circular(100),
          gradient: widget.gcolor),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.grey.withOpacity(0.2),
          onTap: widget.pressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            alignment: Alignment.center,
            // height: 50.0,
            child: Text(
                widget.mainText,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: widget.textWhite ? Colors.white : Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ),
        ),
      ),
      // color: Colors.white,
    );
  }
}