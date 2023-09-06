import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/mensagem/mensagem.dart';
import 'package:eventhub/model/sala/sala_bate_papo.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class MensagemService {
  Future<List<SalaBatePapo>> buscarSalasBatePapo() async {
    final response = await Api.buscarSalasBatePapo();

    if (response.statusCode == 200) {
      return (jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List)
          .map((model) => SalaBatePapo.fromJson(model))
          .toList();
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<Mensagem> enviarMensagem(int id, Mensagem mensagem) async {
    final response = await Api.enviarMensagem(id, mensagem);

    if (response.statusCode == 201) {
      Mensagem mensagem = Mensagem.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return mensagem;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<List<Mensagem>> buscarMensagens(int id) async {
    final response = await Api.buscarMensagens(id);

    if (response.statusCode == 200) {
      return (jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List)
          .map((model) => Mensagem.fromJson(model))
          .toList();
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<List<Mensagem>> buscarMensagensRecebidasENaoLidas(int id) async {
    final response = await Api.buscarMensagensRecebidasENaoLidas(id);

    if (response.statusCode == 200) {
      return (jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List)
          .map((model) => Mensagem.fromJson(model))
          .toList();
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
