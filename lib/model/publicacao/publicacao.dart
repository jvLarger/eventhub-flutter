import 'package:eventhub/model/publicacao/publicacao_arquivo.dart';
import 'package:eventhub/model/publicacao/publicacao_comentario.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class Publicacao {
  int? id;
  Usuario? usuario;
  String? descricao;
  DateTime? data;
  int? curtidas;
  List<PublicacaoComentario>? comentarios;
  List<PublicacaoArquivo>? arquivos;

  Publicacao({
    this.id,
    this.usuario,
    this.descricao,
    this.data,
    this.curtidas,
    this.comentarios,
    this.arquivos,
  });

  factory Publicacao.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);

    List<PublicacaoComentario> comentarios = List.empty();

    if (jsons['comentarios'] != null) {
      comentarios = (jsons['comentarios'] as List).map((model) => PublicacaoComentario.fromJson(model)).toList();
    }

    List<PublicacaoArquivo> arquivos = List.empty();

    if (jsons['arquivos'] != null) {
      arquivos = (jsons['arquivos'] as List).map((model) => PublicacaoArquivo.fromJson(model)).toList();
    }

    return Publicacao(
      id: jsons['id'],
      usuario: jsons['usuario'] != null ? Usuario.fromJson(jsons['usuario']) : null,
      descricao: jsons['descricao'],
      data: jsons['data'] != null ? DateTime.parse(jsons['data']) : null,
      curtidas: jsons['curtidas'],
      comentarios: comentarios,
      arquivos: arquivos,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuario': usuario,
        'descricao': descricao,
        'data': data,
        'curtidas': curtidas,
        'comentarios': comentarios,
        'arquivos': arquivos,
      };
}
