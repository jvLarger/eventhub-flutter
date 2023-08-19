import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class Token {
  int? id;
  Usuario? usuario;
  int? codigo;
  DateTime? dataExpiracao;

  Token({
    this.codigo,
    this.dataExpiracao,
    this.id,
    this.usuario,
  });

  factory Token.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Token(
      id: jsons['id'],
      codigo: jsons['codigo'],
      dataExpiracao: jsons['dataExpiracao'],
      usuario: Usuario.fromJson(
        jsons['usuario'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'dataExpiracao': dataExpiracao,
        'usuario': usuario,
      };
}
