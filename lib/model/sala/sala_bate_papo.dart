import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class SalaBatePapo {
  Usuario? usuario;
  int? mensagensNaoLidas;

  SalaBatePapo({this.usuario, this.mensagensNaoLidas});

  factory SalaBatePapo.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return SalaBatePapo(
      usuario: Usuario.fromJson(jsons['usuario']),
      mensagensNaoLidas: jsons['mensagensNaoLidas'],
    );
  }

  Map<String, dynamic> toJson() => {
        'usuario': usuario,
        'mensagensNaoLidas': mensagensNaoLidas,
      };
}
