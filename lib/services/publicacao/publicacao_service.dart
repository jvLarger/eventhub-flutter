import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/publicacao/publicacao.dart';
import 'package:eventhub/model/publicacao/publicacao_comentario.dart';
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

  Future<Publicacao> buscarPublicacao(int idPublicacao) async {
    final response = await Api.buscarPublicacao(idPublicacao);

    if (response.statusCode == 200) {
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

  Future<void> excluirPublicacao(int idPublicacao) async {
    final response = await Api.excluirPublicacao(idPublicacao);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<PublicacaoComentario> comentarPublicacao(int idPublicacao, PublicacaoComentario publicacaoComentario) async {
    final response = await Api.comentarPublicacao(idPublicacao, publicacaoComentario);

    if (response.statusCode == 201) {
      PublicacaoComentario publicacaoComentario = PublicacaoComentario.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return publicacaoComentario;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<void> excluirComentario(int idPublicacaoComentario) async {
    final response = await Api.excluirComentario(idPublicacaoComentario);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
