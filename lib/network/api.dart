import 'dart:convert';

import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/publicacao/publicacao.dart';
import 'package:eventhub/model/publicacao/publicacao_comentario.dart';
import 'package:eventhub/model/token/token.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/model/usuario/usuario_comentario.dart';
import 'package:eventhub/utils/util.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseURL = "http://192.168.1.10:8080/api";
  static String apiKey = "";

  static getHeader() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
  }

  static Uri getURI(String nmUrl) {
    Util.printInfo("URL:'$nmUrl'");
    // Util.printInfo("token: $apiKey");
    return Uri.parse(nmUrl);
  }

  static Future<http.Response> criarUsuario(Usuario usuario) async {
    return await http.post(
      getURI('$baseURL/publico/nova-conta'),
      headers: getHeader(),
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }

  static tokenValido(String token) async {
    return await http.post(
      getURI('$baseURL/publico/token-valido'),
      headers: getHeader(),
      body: jsonEncode(
        {
          "token": token,
        },
      ),
    );
  }

  static login(Usuario usuario) async {
    return await http.post(
      getURI('$baseURL/publico/login'),
      headers: getHeader(),
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }

  static buscarUsuarioLogado() async {
    return await http.get(
      getURI('$baseURL/usuarios'),
      headers: getHeader(),
    );
  }

  static enviarTokenRecuperacao(Token token) async {
    return await http.post(
      getURI('$baseURL/publico/recuperar-senha'),
      headers: getHeader(),
      body: jsonEncode(
        token.toJson(),
      ),
    );
  }

  static validarTokenInformado(int codigo, String email) async {
    return await http.get(
      getURI('$baseURL/publico/validar-token/$codigo/$email'),
      headers: getHeader(),
    );
  }

  static alterarSenhaUsuario(Token token) async {
    return await http.put(
      getURI('$baseURL/publico/nova-senha'),
      headers: getHeader(),
      body: jsonEncode(
        token.toJson(),
      ),
    );
  }

  static alterarInformacoesUsuario(Usuario usuario) async {
    return await http.put(
      getURI('$baseURL/usuarios'),
      headers: getHeader(),
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }

  static uploadFile(String base64) async {
    return await http.post(
      getURI('$baseURL/arquivos'),
      headers: getHeader(),
      body: jsonEncode(
        {
          "base64": base64,
        },
      ),
    );
  }

  static alterarImagemPerfilUsuario(Arquivo arquivo) async {
    return await http.put(
      getURI('$baseURL/usuarios/foto'),
      headers: getHeader(),
      body: jsonEncode(
        arquivo.toJson(),
      ),
    );
  }

  static buscarMeuPerfil() async {
    return await http.get(
      getURI('$baseURL/perfis'),
      headers: getHeader(),
    );
  }

  static buscarPerfil(int idUsuario) async {
    return await http.get(
      getURI('$baseURL/perfis/$idUsuario'),
      headers: getHeader(),
    );
  }

  static encontrarPessoas(String nomeCompleto, int page) async {
    return await http.get(
      getURI('$baseURL/usuarios/encontrados?nomeCompleto=$nomeCompleto&page=$page&size=5000'),
      headers: getHeader(),
    );
  }

  static enviarSolicitacaoAmizade(int idUsuario) async {
    return await http.post(
      getURI('$baseURL/amizades/$idUsuario'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }

  static aceitarSolicitacaoAmizade(idNotificacao) async {
    return await http.post(
      getURI('$baseURL/amizades/$idNotificacao/aceitar'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }

  static removerAmizade(int idUsuario) async {
    return await http.delete(
      getURI('$baseURL/amizades/$idUsuario'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }

  static enviarSolicitacaoComentario(int idUsuario, UsuarioComentario usuarioComentario) async {
    return await http.post(
      getURI('$baseURL/usuarios/comentarios/$idUsuario'),
      headers: getHeader(),
      body: jsonEncode(
        usuarioComentario.toJson(),
      ),
    );
  }

  static aceitarSolicitacaoComentario(int idNotificacao) async {
    return await http.post(
      getURI('$baseURL/usuarios/comentarios/$idNotificacao/aceitar'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  static removerComentario(int idUsuarioComentario) async {
    return await http.delete(
      getURI('$baseURL/usuarios/comentarios/$idUsuarioComentario'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }

  static buscarNotificacoesPendentes() async {
    return await http.get(
      getURI('$baseURL/notificacoes/pendentes'),
      headers: getHeader(),
    );
  }

  static marcarComoLida(int idNotificacao) async {
    return await http.put(
      getURI('$baseURL/notificacoes/$idNotificacao/ler'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  static alterarIdentificadorNotificacao(UsuarioAutenticado usuarioAutenticado) async {
    return await http.put(
      getURI('$baseURL/usuarios/identificador'),
      headers: getHeader(),
      body: jsonEncode(
        usuarioAutenticado.toJson(),
      ),
    );
  }

  static criarPublicacao(Publicacao publicacao) async {
    return await http.post(
      getURI('$baseURL/publicacoes'),
      headers: getHeader(),
      body: jsonEncode(
        publicacao.toJson(),
      ),
    );
  }

  static buscarPublicacao(int idPublicacao) async {
    return await http.get(
      getURI('$baseURL/publicacoes/$idPublicacao'),
      headers: getHeader(),
    );
  }

  static excluirPublicacao(int idPublicacao) async {
    return await http.delete(
      getURI('$baseURL/publicacoes/$idPublicacao'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  static comentarPublicacao(int idPublicacao, PublicacaoComentario publicacaoComentario) async {
    return await http.post(
      getURI('$baseURL/publicacoes/comentarios/$idPublicacao'),
      headers: getHeader(),
      body: jsonEncode(
        publicacaoComentario.toJson(),
      ),
    );
  }

  static excluirComentario(int idPublicacaoComentario) async {
    return await http.delete(
      getURI('$baseURL/publicacoes/comentarios/$idPublicacaoComentario'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  static curtirPublicacao(int idPublicacao) async {
    return await http.post(
      getURI('$baseURL/publicacoes/curtidas/$idPublicacao'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  static descurtirPublicacao(int idPublicacao) async {
    return await http.delete(
      getURI('$baseURL/publicacoes/curtidas/$idPublicacao'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  static buscarUsuariosQueCurtiram(int idPublicacao) async {
    return await http.get(
      getURI('$baseURL/publicacoes/curtidas/$idPublicacao'),
      headers: getHeader(),
    );
  }
}
