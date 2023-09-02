import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class PublicacaoComentario {
  int? id;
  Usuario? usuario;
  DateTime? data;
  String? descricao;

  PublicacaoComentario({
    this.id,
    this.usuario,
    this.data,
    this.descricao,
  });

  factory PublicacaoComentario.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return PublicacaoComentario(
      id: jsons['id'],
      usuario: Usuario.fromJson(jsons['usuario']),
      data: jsons['data'] != null ? DateTime.parse(jsons['data']) : null,
      descricao: jsons['descricao'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuario': usuario,
        'data': data,
        'descricao': descricao,
      };
}
