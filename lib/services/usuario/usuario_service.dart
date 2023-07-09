import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/db/usuario_db.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class UsuarioService {
  Future<UsuarioAutenticado> criarUsuario(Usuario usuario) async {
    final response = await Api.criarUsuario(usuario);

    if (response.statusCode == 201) {
      UsuarioAutenticado usuarioAutenticado = UsuarioAutenticado.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      await UsuarioDB().inserirUsuario(usuarioAutenticado);

      Api.apiKey = usuarioAutenticado.token!;

      return usuarioAutenticado;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<bool> isTokenValido(String token) async {
    final response = await Api.tokenValido(token);

    if (response.statusCode == 200) {
      // ignore: sdk_version_since
      return bool.parse(utf8.decode(response.bodyBytes));
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  login(Usuario usuario, bool isManterConectado) async {
    final response = await Api.login(usuario);

    if (response.statusCode == 200) {
      UsuarioAutenticado usuarioAutenticado = UsuarioAutenticado.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      Api.apiKey = usuarioAutenticado.token!;

      if (isManterConectado) {
        await UsuarioDB().inserirUsuario(usuarioAutenticado);
      }

      return usuarioAutenticado;
    } else {
      throw EventHubException(
          "E-mail ou senha inválidos. Por favor, verifique!");
    }
  }
}
