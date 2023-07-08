import 'dart:convert';

import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseURL = "http://192.168.1.5:8080/api";
  static const String apiKey = "";

  static var header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  static Uri getURI(String nmUrl) {
    Util.printInfo("URL:'$nmUrl'");
    return Uri.parse(nmUrl);
  }

  static Future<http.Response> criarUsuario(Usuario usuario) async {
    return await http.post(
      getURI('$baseURL/publico/nova-conta'),
      headers: header,
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }

  static tokenValido(String token) async {
    return await http.post(
      getURI('$baseURL/publico/token-valido'),
      headers: header,
      body: jsonEncode(
        {
          "token": token,
        },
      ),
    );
  }

  static login(Usuario usuario) async {
    return await http.post(
      getURI('$baseURL/publico/login'),
      headers: header,
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }
}
