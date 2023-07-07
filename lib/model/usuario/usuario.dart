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

  Usuario({
    this.id,
    this.nomeUsuario,
    this.email,
    this.senha,
    this.nomeCompleto,
    this.documentoPrincipal,
    this.telefone,
    this.dataComemorativa,
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
      };
}
