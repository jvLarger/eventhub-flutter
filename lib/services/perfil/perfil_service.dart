import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/perfil/perfil.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class PerfilService {
  Future<Perfil> buscarMeuPerfil() async {
    final response = await Api().buscarMeuPerfil();

    if (response.statusCode == 200) {
      Perfil perfil = Perfil.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return perfil;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<Perfil> buscarPerfil(int idUsuario) async {
    final response = await Api().buscarPerfil(idUsuario);

    if (response.statusCode == 200) {
      Perfil perfil = Perfil.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return perfil;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
