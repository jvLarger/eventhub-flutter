import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/usuario/usuario_comentario.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class UsuarioComentarioService {
  Future<void> enviarSolicitacaoComentario(int idUsuario, UsuarioComentario usuarioComentario) async {
    final response = await Api().enviarSolicitacaoComentario(idUsuario, usuarioComentario);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }

  Future<void> aceitarSolicitacaoComentario(int idNotificacao) async {
    final response = await Api().aceitarSolicitacaoComentario(idNotificacao);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }

  Future<void> removerComentario(int idUsuarioComentario) async {
    final response = await Api().removerComentario(idUsuarioComentario);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }
}
