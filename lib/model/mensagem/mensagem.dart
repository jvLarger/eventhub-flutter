import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class Mensagem {
  int? id;
  Usuario? usuarioOrigem;
  Usuario? usuarioDestino;
  DateTime? dataMensagem;
  DateTime? dataLeitura;
  String? descricao;
  Evento? evento;

  Mensagem({this.id, this.usuarioOrigem, this.usuarioDestino, this.dataMensagem, this.dataLeitura, this.descricao, this.evento});

  factory Mensagem.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Mensagem(
      id: jsons['id'],
      usuarioOrigem: jsons['usuarioOrigem'] != null ? Usuario.fromJson(jsons['usuarioOrigem']) : null,
      usuarioDestino: jsons['usuarioDestino'] != null ? Usuario.fromJson(jsons['usuarioDestino']) : null,
      dataMensagem: jsons['dataMensagem'] != null ? DateTime.parse(jsons['dataMensagem']) : null,
      dataLeitura: jsons['dataLeitura'] != null ? DateTime.parse(jsons['dataLeitura']) : null,
      descricao: jsons['descricao'],
      evento: jsons['evento'] != null ? Evento.fromJson(jsons['evento']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioOrigem': usuarioOrigem,
        'usuarioDestino': usuarioDestino,
        'dataMensagem': dataMensagem,
        'dataLeitura': dataLeitura,
        'descricao': descricao,
        'evento': evento,
      };
}
