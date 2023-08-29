import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/notificacao/notificacao.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class NotificacaoService {
  Future<List<Notificacao>> buscarNotificacoesPendentes() async {
    final response = await Api.buscarNotificacoesPendentes();

    if (response.statusCode == 200) {
      return (jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List)
          .map((model) => Notificacao.fromJson(model))
          .toList();
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<void> marcarComoLida(int idNotificacao) async {
    final response = await Api.marcarComoLida(idNotificacao);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }
}
