import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class UsuarioComentario {
  int? id;
  Usuario? usuarioOrigem;
  Usuario? usuario;
  DateTime? dataComentario;
  String? comentario;

  UsuarioComentario({
    this.comentario,
    this.dataComentario,
    this.id,
    this.usuarioOrigem,
    this.usuario,
  });

  factory UsuarioComentario.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return UsuarioComentario(
      id: jsons['id'],
      dataComentario: DateTime.parse(jsons['dataComentario']),
      comentario: jsons['comentario'],
      usuario: Usuario.fromJson(jsons['usuario']),
      usuarioOrigem: Usuario.fromJson(jsons['usuarioOrigem']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'dataComentario': dataComentario,
        'comentario': comentario,
        'usuarioOrigem': usuarioOrigem,
        'usuario': usuario,
      };
}
