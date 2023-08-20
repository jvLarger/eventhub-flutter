import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/utils/util.dart';

class PublicacaoResumida {
  int? id;
  String? descricao;
  DateTime? data;
  Arquivo? fotoPrincipal;

  PublicacaoResumida({
    this.data,
    this.descricao,
    this.fotoPrincipal,
    this.id,
  });

  factory PublicacaoResumida.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return PublicacaoResumida(
      id: jsons['id'],
      descricao: jsons['descricao'],
      data: DateTime.parse(jsons['data']),
      fotoPrincipal: Arquivo.fromJson(jsons['fotoPrincipal']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'data': data,
        'fotoPrincipal': fotoPrincipal,
      };
}
