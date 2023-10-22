import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/faturamento/faturamento_pagamento.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class FaturamentoService {
  Future<FaturamentoPagamento> buscarFauramentos() async {
    final response = await Api().buscarFauramentos();

    if (response.statusCode == 200) {
      FaturamentoPagamento faturamentoPagamento = FaturamentoPagamento.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );
      return faturamentoPagamento;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<void> desvincularContaStripe() async {
    final response = await Api().desvincularContaStripe();

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<void> pagarFaturameto() async {
    final response = await Api().pagarFaturameto();

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
