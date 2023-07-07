import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/error/standard_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';

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

  static Map<String, dynamic> getJsonWithValues(Map<String, dynamic> json) {
    Map<String, dynamic> mapBkp = Map.from(json);
    Map<String, dynamic> mapFiltered = {};

    void iterateMapEntry(key, value) {
      mapBkp[key] = value;
      if (value != null && value != "") {
        mapFiltered[key] = value;
      }
    }

    mapBkp.forEach(iterateMapEntry);
    return mapFiltered;
  }

  static void lancarErro(Response response) {
    StandardError error = StandardError.fromJson(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ),
    );
    throw EventHubException(error.message!);
  }

  static String getMensagemErro(Response response) {
    StandardError error = StandardError.fromJson(
      jsonDecode(
        utf8.decode(response.bodyBytes),
      ),
    );
    return error.message!;
  }

  static void showSnackbarError(BuildContext context, String cause) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromRGBO(247, 85, 85, 1),
      duration: const Duration(seconds: 3),
      content: Text(
        cause,
        style: const TextStyle(
          fontFamily: 'Urbanist',
        ),
      ),
    ));
  }
}
