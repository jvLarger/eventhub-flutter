import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/utils/util.dart';

class EventoArquivo {
  int? id;
  Arquivo? arquivo;

  EventoArquivo({
    this.id,
    this.arquivo,
  });

  factory EventoArquivo.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return EventoArquivo(
      id: jsons['id'],
      arquivo: jsons['arquivo'] != null ? Arquivo.fromJson(jsons['arquivo']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'arquivo': arquivo,
      };
}
