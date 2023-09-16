import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/notificacao/notificacao.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/views/chat/salas/salas_bate_papo_page.dart';
import 'package:eventhub/presentation/views/notificacao/notificacao_page.dart';
import 'package:eventhub/services/mensagem/mensagem_service.dart';
import 'package:eventhub/services/notificacao/notificacao_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class InformacoesUsuario extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const InformacoesUsuario({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<InformacoesUsuario> createState() => _InformacoesUsuarioState();
}

class _InformacoesUsuarioState extends State<InformacoesUsuario> {
  List<Notificacao> _listaNotificacao = [];

  buscarNotificacoesPendentes() async {
    try {
      _listaNotificacao = await NotificacaoService().buscarNotificacoesPendentes();
      setState(() {});
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  int _numeroMensagensNaoLidas = 0;

  buscarNumeroMensagensNaoLidas() async {
    try {
      _numeroMensagensNaoLidas = await MensagemService().buscarNumeroMensagensNaoLidas();
      if (mounted) {
        setState(() {});
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarNotificacoesPendentes();
    buscarNumeroMensagensNaoLidas();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: colorBlue,
                backgroundImage: NetworkImage(
                  Util.montarURlFotoByArquivo(widget.usuarioAutenticado.foto),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bem-vindo!",
                  ),
                  Text(
                    widget.usuarioAutenticado.nomeCompleto!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      Util.goTo(
                        context,
                        SalasBatePapoPage(
                          usuarioAutenticado: widget.usuarioAutenticado,
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color.fromRGBO(238, 238, 238, 1),
                          width: 1,
                        ),
                      ),
                      child: const Icon(Icons.chat_outlined),
                    ),
                  ),
                  Visibility(
                    visible: _numeroMensagensNaoLidas > 0,
                    child: Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: 22,
                        width: 22,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _numeroMensagensNaoLidas.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      Util.goTo(
                        context,
                        NotificacaoPage(
                          usuarioAutenticado: widget.usuarioAutenticado,
                          listaNotificacao: _listaNotificacao,
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color.fromRGBO(238, 238, 238, 1),
                          width: 1,
                        ),
                      ),
                      child: const Icon(Icons.notifications_outlined),
                    ),
                  ),
                  Visibility(
                    visible: _listaNotificacao.isNotEmpty,
                    child: Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: 22,
                        width: 22,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _listaNotificacao.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
