import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class AmizadeService {
  Future<void> enviarSolicitacaoAmizade(int idUsuario) async {
    final response = await Api.enviarSolicitacaoAmizade(idUsuario);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }

  Future<void> aceitarSolicitacaoAmizade(int idNotificacao) async {
    final response = await Api.aceitarSolicitacaoAmizade(idNotificacao);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }

  Future<void> removerAmizade(int idUsuario) async {
    final response = await Api.removerAmizade(idUsuario);

    if (response.statusCode == 204) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }
}
