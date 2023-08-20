import 'package:eventhub/model/publicacao/publicacao_resumida.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_comentario.dart';
import 'package:eventhub/utils/util.dart';

class Perfil {
  Usuario? usuario;
  int? numeroAmigos;
  int? numeroEventos;
  bool? isAmigo;
  List<PublicacaoResumida>? publicacoes;
  List<UsuarioComentario>? comentarios;

  Perfil({
    this.comentarios,
    this.isAmigo,
    this.numeroAmigos,
    this.numeroEventos,
    this.publicacoes,
    this.usuario,
  });

  factory Perfil.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    List<PublicacaoResumida> publicacoes = List.empty();

    if (jsons['publicacoes'] != null) {
      publicacoes = (jsons['publicacoes'] as List).map((model) => PublicacaoResumida.fromJson(model)).toList();
    }
    List<UsuarioComentario> comentarios = List.empty();

    if (jsons['comentarios'] != null) {
      comentarios = (jsons['comentarios'] as List).map((model) => UsuarioComentario.fromJson(model)).toList();
    }
    return Perfil(
      usuario: Usuario.fromJson(jsons['usuario']),
      numeroAmigos: jsons['numeroAmigos'],
      numeroEventos: jsons['numeroEventos'],
      isAmigo: jsons['isAmigo'],
      publicacoes: publicacoes,
      comentarios: comentarios,
    );
  }

  Map<String, dynamic> toJson() => {
        'comentarios': comentarios,
        'usuario': usuario,
        'numeroAmigos': numeroAmigos,
        'numeroEventos': numeroEventos,
        'isAmigo': isAmigo,
        'publicacoes': publicacoes,
      };
}
