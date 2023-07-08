import 'package:eventhub/utils/util.dart';

class UsuarioAutenticado {
  int? id;
  String? email;
  String? nomeUsuario;
  String? nomeCompleto;
  String? token;

  UsuarioAutenticado({
    this.id,
    this.email,
    this.nomeUsuario,
    this.nomeCompleto,
    this.token,
  });

  factory UsuarioAutenticado.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return UsuarioAutenticado(
      id: jsons['id'],
      email: jsons['email'],
      nomeUsuario: jsons['nomeUsuario'],
      nomeCompleto: jsons['nomeCompleto'],
      token: jsons['token'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'nomeUsuario': nomeUsuario,
        'nomeCompleto': nomeCompleto,
        'token': token
      };

  factory UsuarioAutenticado.fromJsonDb(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return UsuarioAutenticado(
      id: jsons['id'],
      nomeCompleto: jsons['nome_completo'],
      nomeUsuario: jsons['nome_usuario'],
      email: jsons['email'],
      token: jsons['token'],
    );
  }
}
