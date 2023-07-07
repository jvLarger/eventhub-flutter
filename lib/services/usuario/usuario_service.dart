import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class UsuarioService {
  Future<UsuarioAutenticado> criarUsuario(Usuario usuario) async {
    final response = await Api.criarUsuario(usuario);

    if (response.statusCode == 201) {
      return UsuarioAutenticado.fromJson(jsonDecode(
        utf8.decode(response.bodyBytes),
      ));
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
