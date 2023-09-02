import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/publicacao/publicacao.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class PublicacaoService {
  Future<Publicacao> criarPublicacao(Publicacao publicacao) async {
    final response = await Api.criarPublicacao(publicacao);

    if (response.statusCode == 201) {
      Publicacao publicacao = Publicacao.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return publicacao;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}