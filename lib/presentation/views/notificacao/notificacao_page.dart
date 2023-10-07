import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/notificacao/notificacao.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/eventos_destaque_page.dart';
import 'package:eventhub/services/amizade/amizade_service.dart';
import 'package:eventhub/services/notificacao/notificacao_service.dart';
import 'package:eventhub/services/usuario/usuario_comentario_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class NotificacaoPage extends StatefulWidget {
  final List<Notificacao> listaNotificacao;
  final UsuarioAutenticado usuarioAutenticado;
  const NotificacaoPage({
    super.key,
    required this.listaNotificacao,
    required this.usuarioAutenticado,
  });

  @override
  State<NotificacaoPage> createState() => _NotificacaoPageState();
}

class _NotificacaoPageState extends State<NotificacaoPage> {
  marcarComoLida(Notificacao notificacao, index) async {
    try {
      Util.showLoading(context);
      await NotificacaoService().marcarComoLida(notificacao.id!);
      widget.listaNotificacao.removeAt(index);
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      setState(() {});
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  aceitarSolicitacaoAmizade(Notificacao notificacao, int index) async {
    try {
      Util.showLoading(context);
      await AmizadeService().aceitarSolicitacaoAmizade(notificacao.id!);
      widget.listaNotificacao.removeAt(index);
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);

      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Solicitação de amizade aceita com sucesso!");

      setState(() {});
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  aceitarSolicitacaoComentario(Notificacao notificacao, int index) async {
    try {
      Util.showLoading(context);
      await UsuarioComentarioService().aceitarSolicitacaoComentario(notificacao.id!);
      widget.listaNotificacao.removeAt(index);
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);

      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Solicitação de comentário para perfil público aceita com sucesso!");

      setState(() {});
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Util.goToAndOverride(
          context,
          EventosDestaquePage(
            usuarioAutenticado: widget.usuarioAutenticado,
          ),
        );
        return false;
      },
      child: EventHubBody(
        topWidget: const EventHubTopAppbar(
          title: "Notificações",
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          child: Column(
            children: [
              widget.listaNotificacao.isEmpty
                  ? Column(
                      children: [
                        const SizedBox(
                          height: defaultPadding * 3,
                        ),
                        SvgPicture.asset(
                          "assets/images/empty.svg",
                          width: 250,
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Text(
                          "Nenhuma notificação encontrada!",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.listaNotificacao.length,
                      itemBuilder: (context, index) {
                        return getCadNotificacao(widget.listaNotificacao[index], index);
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget getCadNotificacao(Notificacao notificacao, int index) {
    if (notificacao.tipo == "SOLICITACAO_AMIZADE") {
      return getCardNotificacaoSolicitacaoAmizade(notificacao, index);
    } else if (notificacao.tipo == "SOLICITACAO_COMENTARIO_PUBLICO") {
      return getCardNotificacaoSolicitacaoComentarioPublico(notificacao, index);
    } else if (notificacao.tipo == "COMPRA_INGRESSO_SUCESSO") {
      return getCardNotificacaoCompraIngressoSucesso(notificacao, index);
    } else if (notificacao.tipo == "COMPRA_INGRESSO_ERRO") {
      return getCardNotificacaoCompraIngressoErro(notificacao, index);
    } else {
      return Text(notificacao.descricao!);
    }
  }

  Widget getCardNotificacaoCompraIngressoErro(Notificacao notificacao, int index) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: defaultPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(247, 85, 85, 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Ionicons.ticket_outline,
                    color: Color.fromRGBO(247, 85, 85, 1),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Erro ao processar o pagamento",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      notificacao.descricao!,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      Util.formatarDataComHora(notificacao.dataNotificacao),
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  marcarComoLida(notificacao, index);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Marcar como Lido"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getCardNotificacaoSolicitacaoAmizade(Notificacao notificacao, int index) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: defaultPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(76, 175, 80, 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Ionicons.heart,
                    color: Color.fromRGBO(76, 175, 80, 1),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notificacao.descricao!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      Util.formatarDataComHora(notificacao.dataNotificacao),
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    aceitarSolicitacaoAmizade(notificacao, index);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Aceitar"),
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
                    marcarComoLida(notificacao, index);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Recusar"),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getCardNotificacaoSolicitacaoComentarioPublico(Notificacao notificacao, int index) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: defaultPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorBlue.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.message_outlined,
                    color: colorBlue,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${notificacao.usuarioOrigem!.nomeCompleto!} deseja comentar em seu perfil",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      notificacao.descricao!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      Util.formatarDataComHora(notificacao.dataNotificacao),
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    aceitarSolicitacaoComentario(notificacao, index);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Aceitar"),
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
                    marcarComoLida(notificacao, index);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Recusar"),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getCardNotificacaoCompraIngressoSucesso(Notificacao notificacao, int index) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: defaultPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(84, 75, 195, 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Ionicons.ticket_outline,
                    color: colorBlue,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pagamento recebido com sucesso",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      notificacao.descricao!,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      Util.formatarDataComHora(notificacao.dataNotificacao),
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  marcarComoLida(notificacao, index);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Marcar como Lido"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
