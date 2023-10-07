import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/perfil/perfil.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/model/usuario/usuario_comentario.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/chat/salaprivada/sala_privada_page.dart';
import 'package:eventhub/presentation/views/perfil/publico/components/lista_comentarios_usuario.dart';
import 'package:eventhub/presentation/views/perfil/publico/components/lista_publicacaoes_resumidas.dart';
import 'package:eventhub/services/amizade/amizade_service.dart';
import 'package:eventhub/services/perfil/perfil_service.dart';
import 'package:eventhub/services/usuario/usuario_comentario_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PerfilPublicoPage extends StatefulWidget {
  final int idUsuario;
  final UsuarioAutenticado usuarioAutenticado;
  const PerfilPublicoPage({
    super.key,
    required this.idUsuario,
    required this.usuarioAutenticado,
  });

  @override
  State<PerfilPublicoPage> createState() => _PerfilPublicoPageState();
}

class _PerfilPublicoPageState extends State<PerfilPublicoPage> with TickerProviderStateMixin {
  bool _isLoading = true;
  Perfil _perfil = Perfil();
  TabController? _tabController;
  int _indexTabAtiva = 0;
  final TextEditingController _comentarioController = TextEditingController();

  buscarPerfil() async {
    try {
      _perfil = await PerfilService().buscarPerfil(widget.idUsuario);

      _isLoading = false;
      setState(() {});
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  enviarSolicitacaoComentario() async {
    try {
      Util.showLoading(context);

      if (_comentarioController.text.trim().isEmpty) {
        throw EventHubException("Comentário não informado!");
      }

      await UsuarioComentarioService().enviarSolicitacaoComentario(
        widget.idUsuario,
        UsuarioComentario(
          comentario: _comentarioController.text,
        ),
      );
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);

      _comentarioController.text = "";

      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Solicitação de comentário enviada com sucesso!");

      setState(() {});
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  removerComentario(usuarioComentario) async {
    try {
      Util.showLoading(context);

      await UsuarioComentarioService().removerComentario(usuarioComentario.id);

      buscarPerfil();

      // ignore: use_build_context_synchronously
      Util.hideLoading(context);

      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Comentário removido com sucesso!");

      setState(() {});
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  enviarSolicitacaoAmizade() async {
    try {
      Util.showLoading(context);
      await AmizadeService().enviarSolicitacaoAmizade(widget.idUsuario);
      _perfil.isSolicitacaoAmizadePendente = true;
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);

      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Solicitação enviada com sucesso!");

      setState(() {});
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  removerAmizade() async {
    try {
      Util.showLoading(context);
      await AmizadeService().removerAmizade(widget.idUsuario);
      _perfil.isSolicitacaoAmizadePendente = false;
      _perfil.isAmigo = false;
      _perfil.numeroAmigos = _perfil.numeroAmigos! - 1;
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);

      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Amizade removida com sucesso!");

      setState(() {});
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
    buscarPerfil();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : EventHubBody(
            topWidget: const EventHubTopAppbar(
              title: "",
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          Util.montarURlFotoByArquivo(_perfil.usuario!.foto),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    _perfil.usuario!.nomeCompleto!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromRGBO(221, 213, 213, 1),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                          child: Column(
                            children: [
                              Text(
                                _perfil.numeroEventos.toString(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Color.fromRGBO(33, 33, 33, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding / 2,
                              ),
                              const Text(
                                "Eventos",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(97, 97, 97, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 0.5,
                        color: const Color.fromRGBO(221, 213, 213, 1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              _perfil.numeroAmigos.toString(),
                              style: const TextStyle(
                                fontSize: 32,
                                color: Color.fromRGBO(33, 33, 33, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: defaultPadding / 2,
                            ),
                            const Text(
                              "Amigos",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(97, 97, 97, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromRGBO(221, 213, 213, 1),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Visibility(
                    visible: widget.idUsuario != widget.usuarioAutenticado.id,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _perfil.isSolicitacaoAmizadePendente != null && _perfil.isSolicitacaoAmizadePendente!
                                  ? const Text(
                                      "Solicitação Pendente...",
                                      style: TextStyle(
                                        color: colorBlue,
                                        letterSpacing: 0.4,
                                      ),
                                    )
                                  : _perfil.isAmigo!
                                      ? ElevatedButton(
                                          onPressed: () {
                                            removerAmizade();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Ionicons.person_remove,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Remover"),
                                            ],
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: () {
                                            enviarSolicitacaoAmizade();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Ionicons.person_add,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Adicionar"),
                                            ],
                                          ),
                                        ),
                            ),
                            const SizedBox(
                              width: defaultPadding,
                            ),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  if (_perfil.isAmigo!) {
                                    Util.goTo(
                                      context,
                                      SalaPrivadaPage(
                                        usuario: _perfil.usuario!,
                                        usuarioAutenticado: widget.usuarioAutenticado,
                                        isGoBackDefault: true,
                                      ),
                                    );
                                  } else {
                                    Util.showSnackbarError(context, "Somente é possível enviar mensagem para amigos!");
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.message_outlined,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Mensagem"),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Divider(
                          height: 1,
                          color: Color.fromRGBO(221, 213, 213, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TabBar(
                    unselectedLabelColor: Colors.black,
                    labelColor: colorBlue,
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Urbanist',
                    ),
                    onTap: (value) {
                      _indexTabAtiva = value;
                      setState(() {});
                    },
                    tabs: const [
                      Tab(
                        text: 'Publicações',
                      ),
                      Tab(
                        text: 'Comentários',
                      )
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 28,
                    ),
                    child: _indexTabAtiva == 0
                        ? ListaPublicacoesResumidas(
                            usuarioAutenticado: widget.usuarioAutenticado,
                            listaPublicacaoResumida: _perfil.publicacoes!,
                          )
                        : Column(
                            children: [
                              ListaComentariosUsuario(
                                listaComentarios: _perfil.comentarios!,
                                tratarRemocaoComentario: (UsuarioComentario usuarioComentario) {
                                  if (usuarioComentario.usuario!.id! == widget.usuarioAutenticado.id || usuarioComentario.usuarioOrigem!.id! == widget.usuarioAutenticado.id) {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Excluir Comentário',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: const SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text('Deseja realmente remover esse comentário?'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Confirmar',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onPressed: () {
                                                removerComentario(usuarioComentario);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              EventHubTextFormField(
                                label: "Escreva alguma coisa...",
                                controller: _comentarioController,
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Ionicons.send,
                                    color: colorBlue,
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    enviarSolicitacaoComentario();
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}
