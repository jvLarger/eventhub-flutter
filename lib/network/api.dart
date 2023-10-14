import 'dart:convert';

import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/model/mensagem/mensagem.dart';
import 'package:eventhub/model/publicacao/publicacao.dart';
import 'package:eventhub/model/publicacao/publicacao_comentario.dart';
import 'package:eventhub/model/token/token.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/model/usuario/usuario_comentario.dart';
import 'package:eventhub/utils/singleton.dart';
import 'package:eventhub/utils/util.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseURL = "/api";
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
    return Uri.parse(nmUrl);
  }

  Future<http.Response> criarUsuario(Usuario usuario) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/publico/nova-conta'),
      headers: getHeader(),
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }

  tokenValido(String token) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/publico/token-valido'),
      headers: getHeader(),
      body: jsonEncode(
        {
          "token": token,
        },
      ),
    );
  }

  login(Usuario usuario) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/publico/login'),
      headers: getHeader(),
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }

  buscarUsuarioLogado() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/usuarios'),
      headers: getHeader(),
    );
  }

  enviarTokenRecuperacao(Token token) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/publico/recuperar-senha'),
      headers: getHeader(),
      body: jsonEncode(
        token.toJson(),
      ),
    );
  }

  validarTokenInformado(int codigo, String email) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/publico/validar-token/$codigo/$email'),
      headers: getHeader(),
    );
  }

  alterarSenhaUsuario(Token token) async {
    return await http.put(
      getURI('${EventhubSingleton().getHost()}/publico/nova-senha'),
      headers: getHeader(),
      body: jsonEncode(
        token.toJson(),
      ),
    );
  }

  alterarInformacoesUsuario(Usuario usuario) async {
    return await http.put(
      getURI('${EventhubSingleton().getHost()}/usuarios'),
      headers: getHeader(),
      body: jsonEncode(
        usuario.toJson(),
      ),
    );
  }

  uploadFile(String base64) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/arquivos'),
      headers: getHeader(),
      body: jsonEncode(
        {
          "base64": base64,
        },
      ),
    );
  }

  alterarImagemPerfilUsuario(Arquivo arquivo) async {
    return await http.put(
      getURI('${EventhubSingleton().getHost()}/usuarios/foto'),
      headers: getHeader(),
      body: jsonEncode(
        arquivo.toJson(),
      ),
    );
  }

  buscarMeuPerfil() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/perfis'),
      headers: getHeader(),
    );
  }

  buscarPerfil(int idUsuario) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/perfis/$idUsuario'),
      headers: getHeader(),
    );
  }

  encontrarPessoas(String nomeCompleto, int page) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/usuarios/encontrados?nomeCompleto=$nomeCompleto&page=$page&size=5000'),
      headers: getHeader(),
    );
  }

  enviarSolicitacaoAmizade(int idUsuario) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/amizades/$idUsuario'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }

  aceitarSolicitacaoAmizade(idNotificacao) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/amizades/$idNotificacao/aceitar'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }

  removerAmizade(int idUsuario) async {
    return await http.delete(
      getURI('${EventhubSingleton().getHost()}/amizades/$idUsuario'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }

  enviarSolicitacaoComentario(int idUsuario, UsuarioComentario usuarioComentario) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/usuarios/comentarios/$idUsuario'),
      headers: getHeader(),
      body: jsonEncode(
        usuarioComentario.toJson(),
      ),
    );
  }

  aceitarSolicitacaoComentario(int idNotificacao) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/usuarios/comentarios/$idNotificacao/aceitar'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  removerComentario(int idUsuarioComentario) async {
    return await http.delete(
      getURI('${EventhubSingleton().getHost()}/usuarios/comentarios/$idUsuarioComentario'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }

  buscarNotificacoesPendentes() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/notificacoes/pendentes'),
      headers: getHeader(),
    );
  }

  marcarComoLida(int idNotificacao) async {
    return await http.put(
      getURI('${EventhubSingleton().getHost()}/notificacoes/$idNotificacao/ler'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  alterarIdentificadorNotificacao(UsuarioAutenticado usuarioAutenticado) async {
    return await http.put(
      getURI('${EventhubSingleton().getHost()}/usuarios/identificador'),
      headers: getHeader(),
      body: jsonEncode(
        usuarioAutenticado.toJson(),
      ),
    );
  }

  criarPublicacao(Publicacao publicacao) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/publicacoes'),
      headers: getHeader(),
      body: jsonEncode(
        publicacao.toJson(),
      ),
    );
  }

  buscarPublicacao(int idPublicacao) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/publicacoes/$idPublicacao'),
      headers: getHeader(),
    );
  }

  excluirPublicacao(int idPublicacao) async {
    return await http.delete(
      getURI('${EventhubSingleton().getHost()}/publicacoes/$idPublicacao'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  comentarPublicacao(int idPublicacao, PublicacaoComentario publicacaoComentario) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/publicacoes/comentarios/$idPublicacao'),
      headers: getHeader(),
      body: jsonEncode(
        publicacaoComentario.toJson(),
      ),
    );
  }

  excluirComentario(int idPublicacaoComentario) async {
    return await http.delete(
      getURI('${EventhubSingleton().getHost()}/publicacoes/comentarios/$idPublicacaoComentario'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  curtirPublicacao(int idPublicacao) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/publicacoes/curtidas/$idPublicacao'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  descurtirPublicacao(int idPublicacao) async {
    return await http.delete(
      getURI('${EventhubSingleton().getHost()}/publicacoes/curtidas/$idPublicacao'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  buscarUsuariosQueCurtiram(int idPublicacao) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/publicacoes/curtidas/$idPublicacao'),
      headers: getHeader(),
    );
  }

  buscarFeedPublicacao(int page) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/publicacoes?page=$page'),
      headers: getHeader(),
    );
  }

  buscarSalasBatePapo() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/mensagens/salas'),
      headers: getHeader(),
    );
  }

  enviarMensagem(int id, Mensagem mensagem) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/mensagens/$id'),
      headers: getHeader(),
      body: jsonEncode(
        mensagem.toJson(),
      ),
    );
  }

  buscarMensagens(int id) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/mensagens/$id'),
      headers: getHeader(),
    );
  }

  buscarMensagensRecebidasENaoLidas(int id) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/mensagens/$id/novas'),
      headers: getHeader(),
    );
  }

  consultarCep(String cep) async {
    return await http.get(
      getURI('https://viacep.com.br/ws/$cep/json/'),
      headers: getHeader(),
    );
  }

  buscarTodasCategorias() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/categorias'),
      headers: getHeader(),
    );
  }

  criarEvento(Evento evento) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/eventos'),
      headers: getHeader(),
      body: jsonEncode(
        evento.toJson(),
      ),
    );
  }

  alterarEvento(int idEvento, Evento evento) async {
    return await http.put(
      getURI('${EventhubSingleton().getHost()}/eventos/$idEvento'),
      headers: getHeader(),
      body: jsonEncode(
        evento.toJson(),
      ),
    );
  }

  excluirEvento(int idEvento) async {
    return await http.delete(
      getURI('${EventhubSingleton().getHost()}/eventos/$idEvento'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  buscarMeusEventosConcluidos() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/eventos/concluidos'),
      headers: getHeader(),
    );
  }

  buscarMeusEventosPendentes() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/eventos/pendentes'),
      headers: getHeader(),
    );
  }

  buscarIndicadoresEvento(int idEvento) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/eventos/$idEvento/indicadores'),
      headers: getHeader(),
    );
  }

  buscarIngressosVendidosEvento(int idEvento) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/eventos/$idEvento/indicadores/participantes'),
      headers: getHeader(),
    );
  }

  buscarNumeroMensagensNaoLidas() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/mensagens/nao-lidas'),
      headers: getHeader(),
    );
  }

  buscarCategoriasPopulares() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/categorias/populares'),
      headers: getHeader(),
    );
  }

  buscarEventos(
    double latitude,
    double longitude,
    String idsCategorias,
    String nome,
    double raio,
    String data,
    double valorInicial,
    double valorFinal,
    int page,
  ) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/eventos?latitude=$latitude&longitude=$longitude&categorias=$idsCategorias&nome=$nome&raio=$raio&data=$data&valorInicial=$valorInicial&valorFinal=$valorFinal&page=$page'),
      headers: getHeader(),
    );
  }

  buscarEvento(int idEvento) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/eventos/$idEvento'),
      headers: getHeader(),
    );
  }

  demonstrarInteresse(int idEvento) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/eventos/interesses/$idEvento'),
      headers: getHeader(),
    );
  }

  removerInteresse(int idEvento) async {
    return await http.delete(
      getURI('${EventhubSingleton().getHost()}/eventos/interesses/$idEvento'),
      headers: getHeader(),
    );
  }

  registrarVisualizacaoEvento(int idEvento) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/eventos/$idEvento/visualizacoes'),
      headers: getHeader(),
      body: jsonEncode(
        {},
      ),
    );
  }

  comprarIngresso(Ingresso ingresso) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/ingressos'),
      headers: getHeader(),
      body: jsonEncode(
        ingresso.toJson(),
      ),
    );
  }

  buscarFeedEventos(double latitude, double longitude) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/eventos/feed?latitude=$latitude&longitude=$longitude'),
      headers: getHeader(),
    );
  }

  buscarAmigos() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/amizades'),
      headers: getHeader(),
    );
  }

  compartilharEvento(int idEvento, int idUsuario) async {
    return await http.post(
      getURI('${EventhubSingleton().getHost()}/eventos/$idEvento/compartilhar/$idUsuario'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }

  buscarMeusIngressosPendentes() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/ingressos/pendentes'),
      headers: getHeader(),
    );
  }

  buscarMeusIngressosConcluidos() async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/ingressos/concluidos'),
      headers: getHeader(),
    );
  }

  buscarMapaCalor(double latitude, double longitude) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/eventos/mapa-calor?latitude=$latitude&longitude=$longitude'),
      headers: getHeader(),
    );
  }

  validarIngresso(String identificadorIngresso) async {
    return await http.get(
      getURI('${EventhubSingleton().getHost()}/ingressos/validacao?identificadorIngresso=$identificadorIngresso'),
      headers: getHeader(),
    );
  }

  utilizarIngresso(int idIngresso) async {
    return await http.put(
      getURI('${EventhubSingleton().getHost()}/ingressos/utilizacao/$idIngresso'),
      headers: getHeader(),
      body: jsonEncode({}),
    );
  }
}
