import 'package:flutter/material.dart';

class CJNavigator {
  static final CJNavigator navigator = CJNavigator();

  push(BuildContext context, [String path = "/", bool removeUntil = false]) {
    if (path == "/" || removeUntil) {
      Navigator.pushNamedAndRemoveUntil(context, path, (route) => false);
    } else {
      Navigator.pushNamed(context, path);
    }
  }
}
