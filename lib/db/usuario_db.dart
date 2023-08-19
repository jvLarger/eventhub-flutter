import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/db/db.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDB {
  final EventHubDatabase _connection = EventHubDatabase.instance;

  Future<Database> _getDatabase() async {
    return await _connection.database;
  }

  Future<void> inserirUsuario(UsuarioAutenticado usuarioAutenticado) async {
    try {
      Database db = await _getDatabase();
      await db.rawInsert(
        "INSERT INTO usuario (id, nome_completo, nome_usuario, email, token, nome_absoluto_foto) VALUES (?, ?, ?, ?, ?, ?)",
        [
          usuarioAutenticado.id,
          usuarioAutenticado.nomeCompleto,
          usuarioAutenticado.nomeUsuario,
          usuarioAutenticado.email,
          usuarioAutenticado.token,
          usuarioAutenticado.foto != null ? usuarioAutenticado.foto!.nomeAbsoluto! : null,
        ],
      );
    } catch (error) {
      throw EventHubException(
        "Ocorreu um erro ao inserir o usuário no banco de dados local.",
      );
    }
  }

  Future<void> alterarNomeCompleto(Usuario usuarioAutenticado) async {
    try {
      Database db = await _getDatabase();
      await db.rawInsert(
        "UPDATE usuario SET nome_completo = ?",
        [
          usuarioAutenticado.nomeCompleto,
        ],
      );
    } catch (error) {
      throw EventHubException(
        "Ocorreu um erro ao alterar o usuário no banco de dados local.",
      );
    }
  }

  Future<void> removerUsuario() async {
    try {
      Database db = await _getDatabase();
      await db.execute("DELETE FROM usuario");
    } catch (error) {
      throw EventHubException("Ocorreu um erro ao remover o usuário do banco de dados local.");
    }
  }

  Future<UsuarioAutenticado?> buscarUsuario() async {
    try {
      Database db = await _getDatabase();
      final List<Map<String, dynamic>> maps = await db.query("usuario");

      List<UsuarioAutenticado> usuarios = List.generate(maps.length, (i) {
        return UsuarioAutenticado.fromJsonDb(maps[i]);
      });

      if (usuarios.isEmpty) {
        return null;
      } else {
        return usuarios[0];
      }
    } catch (error) {
      throw EventHubException("Ocorreu um erro ao buscar o usuário do banco de dados local.");
    }
  }
}
