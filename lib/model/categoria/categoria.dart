import 'package:eventhub/utils/util.dart';

class Categoria {
  int? id;
  String? nome;
  String? icone;

  Categoria({
    this.id,
    this.nome,
    this.icone,
  });

  factory Categoria.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Categoria(
      id: jsons['id'],
      nome: jsons['nome'],
      icone: jsons['icone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'icone': icone,
      };
}
