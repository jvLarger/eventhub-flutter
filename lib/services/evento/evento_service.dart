import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class EventoService {
  Future<Evento> criarEvento(Evento evento) async {
    final response = await Api.criarEvento(evento);

    if (response.statusCode == 201) {
      Evento evento = Evento.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return evento;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<Evento> alterarEvento(int idEvento, Evento evento) async {
    final response = await Api.alterarEvento(idEvento, evento);

    if (response.statusCode == 200) {
      Evento evento = Evento.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return evento;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
