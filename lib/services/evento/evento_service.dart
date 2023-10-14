import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/categoria/categoria.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/evento/feed_evento.dart';
import 'package:eventhub/model/evento/indicadores_evento.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';
import 'package:geolocator/geolocator.dart';

class EventoService {
  Future<Evento> criarEvento(Evento evento) async {
    final response = await Api().criarEvento(evento);

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
    final response = await Api().alterarEvento(idEvento, evento);

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
    final response = await Api().excluirEvento(idEvento);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<List<Evento>> buscarMeusEventosPendentes() async {
    final response = await Api().buscarMeusEventosPendentes();

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
    final response = await Api().buscarMeusEventosConcluidos();

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
    final response = await Api().buscarIndicadoresEvento(idEvento);

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
    final response = await Api().buscarIngressosVendidosEvento(idEvento);

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

  Future<List<Evento>> buscarEventos(
    Position position,
    List<Categoria> categorias,
    String nome,
    double raio,
    String data,
    double valorInicial,
    double valorFinal,
    int page,
  ) async {
    String idsCategorias = "";
    int i = 0;
    for (Categoria categoria in categorias) {
      idsCategorias += categoria.id!.toString();
      if (i < categorias.length - 1) {
        idsCategorias += ", ";
      }
      i++;
    }

    final response = await Api().buscarEventos(
      position.latitude,
      position.longitude,
      idsCategorias,
      nome,
      raio,
      Util.datePtBrToEng(data),
      valorInicial,
      valorFinal,
      page,
    );

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

  Future<Evento> buscarEvento(int idEvento) async {
    final response = await Api().buscarEvento(idEvento);

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

  Future<void> demonstrarInteresse(int idEvento) async {
    final response = await Api().demonstrarInteresse(idEvento);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<void> removerInteresse(int idEvento) async {
    final response = await Api().removerInteresse(idEvento);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<void> registrarVisualizacaoEvento(int idEvento) async {
    final response = await Api().registrarVisualizacaoEvento(idEvento);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<FeedEvento> buscarFeedEventos(double latitude, double longitude) async {
    final response = await Api().buscarFeedEventos(latitude, longitude);

    if (response.statusCode == 200) {
      FeedEvento feedEvento = FeedEvento.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return feedEvento;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<void> compartilharEvento(int idEvento, int idUsuario) async {
    final response = await Api().compartilharEvento(idEvento, idUsuario);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<List<Evento>> buscarMapaCalor(double latitude, double longitude) async {
    final response = await Api().buscarMapaCalor(latitude, longitude);

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
}
