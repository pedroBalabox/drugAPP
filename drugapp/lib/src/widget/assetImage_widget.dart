import 'package:flutter/material.dart';

getAsset(String image, double widhtsize) {
  return Image.asset(
    "images/$image",
    width: widhtsize,
    fit: BoxFit.cover,
    errorBuilder:
        (BuildContext context, Object exception, StackTrace stackTrace) {
      return Image.asset(
        "images/logoDrug.png",
        width: widhtsize,
        fit: BoxFit.cover,
      );
    },
  );
}
