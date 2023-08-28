import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/utils/util.dart';

class Usuario {
  int? id;
  String? nomeUsuario;
  String? email;
  String? senha;
  String? nomeCompleto;
  String? documentoPrincipal;
  String? telefone;
  String? dataComemorativa;
  bool? isAmigo;
  bool? isSolicitacaoAmizadePendente;
  Arquivo? foto;

  Usuario({
    this.id,
    this.nomeUsuario,
    this.email,
    this.senha,
    this.nomeCompleto,
    this.documentoPrincipal,
    this.telefone,
    this.dataComemorativa,
    this.foto,
    this.isAmigo,
    this.isSolicitacaoAmizadePendente,
  });

  factory Usuario.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Usuario(
      id: jsons['id'],
      nomeUsuario: jsons['nomeUsuario'],
      email: jsons['email'],
      senha: jsons['senha'],
      nomeCompleto: jsons['nomeCompleto'],
      documentoPrincipal: jsons['documentoPrincipal'],
      telefone: jsons['telefone'],
      dataComemorativa: jsons['dataComemorativa'],
      isAmigo: jsons['isAmigo'],
      isSolicitacaoAmizadePendente: jsons['isSolicitacaoAmizadePendente'],
      foto: jsons['foto'] != null ? Arquivo.fromJson(jsons['foto']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nomeUsuario': nomeUsuario,
        'email': email,
        'senha': senha,
        'nomeCompleto': nomeCompleto,
        'documentoPrincipal': documentoPrincipal,
        'telefone': telefone,
        'dataComemorativa': dataComemorativa,
        'foto': foto,
        'isAmigo': isAmigo,
        'isSolicitacaoAmizadePendente': isSolicitacaoAmizadePendente,
      };
}
