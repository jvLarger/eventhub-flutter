import 'package:eventhub/utils/util.dart';

class Arquivo {
  int? id;
  String? nome;
  String? nomeAbsoluto;
  String? descricao;

  Arquivo({this.id, this.nome, this.nomeAbsoluto, this.descricao});

  factory Arquivo.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Arquivo(
        id: jsons['id'],
        nome: jsons['nome'],
        nomeAbsoluto: jsons['nomeAbsoluto'],
        descricao: jsons['descricao']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'nomeAbsoluto': nomeAbsoluto,
        'descricao': descricao
      };
}
