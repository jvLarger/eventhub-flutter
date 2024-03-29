import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/db/usuario_db.dart';
import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/usuario/page_usuario.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UsuarioService {
  Future<UsuarioAutenticado> criarUsuario(Usuario usuario) async {
    final response = await Api().criarUsuario(usuario);

    if (response.statusCode == 201) {
      UsuarioAutenticado usuarioAutenticado = UsuarioAutenticado.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      await UsuarioDB().inserirUsuario(usuarioAutenticado);

      Api.apiKey = usuarioAutenticado.token!;

      return usuarioAutenticado;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<bool> isTokenValido(String token) async {
    final response = await Api().tokenValido(token);

    if (response.statusCode == 200) {
      // ignore: sdk_version_since
      return bool.parse(utf8.decode(response.bodyBytes));
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  login(Usuario usuario, bool isManterConectado) async {
    final response = await Api().login(usuario);

    if (response.statusCode == 200) {
      UsuarioAutenticado usuarioAutenticado = UsuarioAutenticado.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      Api.apiKey = usuarioAutenticado.token!;
      await UsuarioDB().removerUsuario();
      if (isManterConectado) {
        await UsuarioDB().inserirUsuario(usuarioAutenticado);
      }

      return usuarioAutenticado;
    } else {
      throw EventHubException("E-mail ou senha inválidos. Por favor, verifique!");
    }
  }

  void logout() {
    UsuarioDB().removerUsuario();
    Api.apiKey = "";
  }

  Future<Usuario> buscarUsuarioLogado() async {
    final response = await Api().buscarUsuarioLogado();

    if (response.statusCode == 200) {
      Usuario usuario = Usuario.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return usuario;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<Usuario> alterarInformacoesUsuario(Usuario usuario) async {
    final response = await Api().alterarInformacoesUsuario(usuario);

    if (response.statusCode == 200) {
      Usuario usuarioAutenticado = Usuario.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      await UsuarioDB().alterarNomeCompleto(usuarioAutenticado);
      return usuarioAutenticado;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<void> alterarImagemPerfilUsuario(int? idArquivo) async {
    final response = await Api().alterarImagemPerfilUsuario(
      Arquivo(
        id: idArquivo,
      ),
    );

    if (response.statusCode == 200) {
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<PageUsuario> encontrarPessoas(String nomeCompleto, int page) async {
    final response = await Api().encontrarPessoas(nomeCompleto, page);

    if (response.statusCode == 200) {
      PageUsuario pageUsuario = PageUsuario.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return pageUsuario;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }

  Future<UsuarioAutenticado> tratarIdentificadorNotificacao(UsuarioAutenticado usuarioAutenticado) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (usuarioAutenticado.identificadorNotificacao != fcmToken) {
      usuarioAutenticado.identificadorNotificacao = fcmToken;

      final response = await Api().alterarIdentificadorNotificacao(usuarioAutenticado);

      if (response.statusCode == 200) {
        await UsuarioDB().alterarIdentificadorNotificacao(fcmToken);
        return usuarioAutenticado;
      } else {
        throw EventHubException(Util.getMensagemErro(response));
      }
    }

    return usuarioAutenticado;
  }
}
