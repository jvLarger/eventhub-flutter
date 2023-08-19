import 'dart:convert';

import 'package:eventhub/model/token/token.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseURL = "http://192.168.1.10:8080/api";
  static String apiKey = "";

  static getHeader() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
  }

  static Uri getURI(String nmUrl) {
    Util.printInfo("URL:'$nmUrl'");
    Util.printInfo("token: $apiKey");
    return Uri.parse(nmUrl);
  }

  static Future<http.Response> criarUsuario(Usuario usuario) async {
    return await http.post(
      getURI('$baseURL/publico/nova-conta'),
      headers: getHeader(),
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }

  static tokenValido(String token) async {
    return await http.post(
      getURI('$baseURL/publico/token-valido'),
      headers: getHeader(),
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
      headers: getHeader(),
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }

  static buscarUsuarioLogado() async {
    return await http.get(
      getURI('$baseURL/usuarios'),
      headers: getHeader(),
    );
  }

  static enviarTokenRecuperacao(Token token) async {
    return await http.post(
      getURI('$baseURL/publico/recuperar-senha'),
      headers: getHeader(),
      body: jsonEncode(
        token.toJson(),
      ),
    );
  }

  static validarTokenInformado(int codigo, String email) async {
    return await http.get(
      getURI('$baseURL/publico/validar-token/$codigo/$email'),
      headers: getHeader(),
    );
  }

  static alterarSenhaUsuario(Token token) async {
    return await http.put(
      getURI('$baseURL/publico/nova-senha'),
      headers: getHeader(),
      body: jsonEncode(
        token.toJson(),
      ),
    );
  }
}
