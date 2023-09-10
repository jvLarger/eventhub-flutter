import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/evento/indicadores_evento.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
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

  Future<void> excluirEvento(int idEvento) async {
    final response = await Api.excluirEvento(idEvento);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<List<Evento>> buscarMeusEventosPendentes() async {
    final response = await Api.buscarMeusEventosPendentes();

    if (response.statusCode == 200) {
      return (jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List)
          .map((model) => Evento.fromJson(model))
          .toList();
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<List<Evento>> buscarMeusEventosConcluidos() async {
    final response = await Api.buscarMeusEventosConcluidos();

    if (response.statusCode == 200) {
      return (jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List)
          .map((model) => Evento.fromJson(model))
          .toList();
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<IndicadoresEvento> buscarIndicadoresEvento(int idEvento) async {
    final response = await Api.buscarIndicadoresEvento(idEvento);

    if (response.statusCode == 200) {
      IndicadoresEvento indicadoresEvento = IndicadoresEvento.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return indicadoresEvento;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<List<Ingresso>> buscarIngressosVendidosEvento(int idEvento) async {
    final response = await Api.buscarIngressosVendidosEvento(idEvento);

    if (response.statusCode == 200) {
      return (jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List)
          .map((model) => Ingresso.fromJson(model))
          .toList();
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
