import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/token/token.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class TokenService {
  Future<void> enviarTokenRecuperacao(Token token) async {
    final response = await Api.enviarTokenRecuperacao(token);
    if (response.statusCode == 200) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }

  Future<void> validarTokenInformado(int codigo, String email) async {
    final response = await Api.validarTokenInformado(codigo, email);
    if (response.statusCode == 200) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }

  Future<void> alterarSenhaUsuario(Token token) async {
    final response = await Api.alterarSenhaUsuario(token);
    if (response.statusCode == 204) {
    } else {
      throw EventHubException(
        Util.getMensagemErro(response),
      );
    }
  }
}
