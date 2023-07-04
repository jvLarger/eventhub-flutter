import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/network/api.dart';

class UsuarioService {
  Future<void> criarUsuario(Usuario usuario) async {
    final response = await Api.criarUsuario(usuario);
    if (response.statusCode == 200) {
    } else {
      throw EventHubException("erro");
    }
  }
}
