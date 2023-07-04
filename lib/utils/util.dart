import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Util {
  static goTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static printInfo(String texto) {
    if (kDebugMode) {
      print(texto);
    }
  }
}
