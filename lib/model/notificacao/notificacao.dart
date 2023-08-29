import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class Notificacao {
  int? id;
  Usuario? usuarioOrigem;
  Usuario? usuarioDestino;
  DateTime? dataNotificacao;
  DateTime? dataLeitura;
  String? descricao;
  String? tipo;

  Notificacao({
    this.id,
    this.usuarioOrigem,
    this.usuarioDestino,
    this.dataNotificacao,
    this.dataLeitura,
    this.descricao,
    this.tipo,
  });

  factory Notificacao.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Notificacao(
      id: jsons['id'],
      usuarioOrigem: jsons['usuarioOrigem'] != null ? Usuario.fromJson(jsons['usuarioOrigem']) : null,
      usuarioDestino: Usuario.fromJson(jsons['usuarioDestino']),
      dataNotificacao: DateTime.parse(jsons['dataNotificacao']),
      dataLeitura: jsons['dataLeitura'] != null ? DateTime.parse(jsons['dataLeitura']) : null,
      descricao: jsons['descricao'],
      tipo: jsons['tipo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioOrigem': usuarioOrigem,
        'usuarioDestino': usuarioDestino,
        'dataNotificacao': dataNotificacao,
        'dataLeitura': dataLeitura,
        'descricao': descricao,
        'tipo': tipo,
      };
}
