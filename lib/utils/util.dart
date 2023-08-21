// ignore_for_file: implementation_imports

import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/error/standard_error.dart';
import 'package:eventhub/network/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:intl/intl.dart';

class Util {
  static DateFormat formatterDataComHora = DateFormat('dd/MM/yyyy HH:mm');

  static goTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static goToAndOverride(BuildContext context, Widget page) {
    Navigator.pushReplacement(
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
      backgroundColor: const Color.fromRGBO(247, 85, 85, 1),
      duration: const Duration(seconds: 3),
      content: Text(
        cause,
        style: const TextStyle(
          fontFamily: 'Urbanist',
        ),
      ),
    ));
  }

  static void showSnackbarSuccess(BuildContext context, String cause) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: const Color.fromRGBO(7, 189, 116, 1),
      duration: const Duration(seconds: 3),
      content: Text(
        cause,
        style: const TextStyle(
          fontFamily: 'Urbanist',
        ),
      ),
    ));
  }

  static String getSomenteNumeros(String input) {
    RegExp regex = RegExp(r'[^\d]');
    String apenasNumeros = input.replaceAll(regex, '');
    return apenasNumeros;
  }

  static showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static String converterDataPtBrParaEngl(String dataBr) {
    String dataEng = "";

    if (dataBr.isNotEmpty) {
      dataEng = "${dataBr.split("/")[2]}-${dataBr.split("/")[1]}-${dataBr.split("/")[0]}";
    }

    return dataEng;
  }

  static String aplicarMascara(String texto, String mascara) {
    int indiceTexto = 0;
    String textoFormatado = '';

    for (int i = 0; i < mascara.length; i++) {
      if (indiceTexto >= texto.length) {
        break;
      }

      if (mascara[i] == '#') {
        textoFormatado += texto[indiceTexto];
        indiceTexto++;
      } else {
        textoFormatado += mascara[i];
      }
    }

    return textoFormatado;
  }

  static dateEngToPtBr(String data) {
    return "${data.split("-")[2]}/${data.split("-")[1]}/${data.split("-")[0]}";
  }

  static montarURlFotoByArquivo(Arquivo? arquivo) {
    if (arquivo != null) {
      return montarURlFoto(arquivo.nomeAbsoluto!);
    } else {
      return "https://i.imgur.com/X9DTFx2.png";
    }
  }

  static montarURlFoto(String nomeAbsoluto) {
    return "${Api.baseURL}/publico/imagens/$nomeAbsoluto";
  }

  static String formatarDataComHora(DateTime? data) {
    if (data != null) {
      return formatterDataComHora.format(data);
    } else {
      return "";
    }
  }
}
