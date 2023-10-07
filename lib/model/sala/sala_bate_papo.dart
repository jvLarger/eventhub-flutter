import 'package:eventhub/model/mensagem/mensagem.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class SalaBatePapo {
  Usuario? usuario;
  int? mensagensNaoLidas;
  Mensagem? ultimaMensagem;

  SalaBatePapo({
    this.usuario,
    this.mensagensNaoLidas,
    this.ultimaMensagem,
  });

  factory SalaBatePapo.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return SalaBatePapo(
      usuario: Usuario.fromJson(jsons['usuario']),
      mensagensNaoLidas: jsons['mensagensNaoLidas'],
      ultimaMensagem: jsons['ultimaMensagem'] != null ? Mensagem.fromJson(jsons['ultimaMensagem']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'usuario': usuario,
        'mensagensNaoLidas': mensagensNaoLidas,
        'ultimaMensagem': ultimaMensagem,
      };
}
