import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/utils/util.dart';

class PublicacaoArquivo {
  int? id;
  Arquivo? arquivo;

  PublicacaoArquivo({
    this.id,
    this.arquivo,
  });

  factory PublicacaoArquivo.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return PublicacaoArquivo(
      id: jsons['id'],
      arquivo: Arquivo.fromJson(jsons['arquivo']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'arquivo': arquivo,
      };
}
