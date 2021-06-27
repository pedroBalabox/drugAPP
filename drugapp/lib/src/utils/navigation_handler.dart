import 'package:flutter/material.dart';

class CJNavigator {
  static final CJNavigator navigator = CJNavigator();

  push(BuildContext context, [String path = "/", bool removeUntil = false]) {
    if (path == "/" || removeUntil) {
      Navigator.pushNamedAndRemoveUntil(context, path, (route) => false)
          .then((value) => null);
    } else {
      Navigator.pushNamed(context, path);
    }
  }
}
