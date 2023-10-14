import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class IngressoSevice {
  Future<Ingresso> comprarIngresso(Ingresso ingresso) async {
    final response = await Api().comprarIngresso(ingresso);

    if (response.statusCode == 201) {
      Ingresso evento = Ingresso.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return evento;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<List<Ingresso>> buscarMeusIngressosPendentes() async {
    final response = await Api().buscarMeusIngressosPendentes();

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

  Future<List<Ingresso>> buscarMeusIngressosConcluidos() async {
    final response = await Api().buscarMeusIngressosConcluidos();

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

  Future<Ingresso> validarIngresso(String identificadorIngresso) async {
    final response = await Api().validarIngresso(identificadorIngresso);

    if (response.statusCode == 200) {
      Ingresso ingresso = Ingresso.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );
      return ingresso;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<void> utilizarIngresso(int id) async {
    final response = await Api().utilizarIngresso(id);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
