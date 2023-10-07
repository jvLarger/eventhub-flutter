import 'dart:async';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/mensagem/mensagem.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/chat/salas/salas_bate_papo_page.dart';
import 'package:eventhub/presentation/views/evento/visualizacao/evento_visualizacao_page.dart';
import 'package:eventhub/services/mensagem/mensagem_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SalaPrivadaPage extends StatefulWidget {
  final Usuario usuario;
  final UsuarioAutenticado usuarioAutenticado;
  final bool isGoBackDefault;
  const SalaPrivadaPage({
    super.key,
    required this.usuario,
    required this.usuarioAutenticado,
    required this.isGoBackDefault,
  });

  @override
  State<SalaPrivadaPage> createState() => _SalaPrivadaPageState();
}

class _SalaPrivadaPageState extends State<SalaPrivadaPage> {
  final TextEditingController _descricaoController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Mensagem> _listaMensagens = [];
  bool _isLoading = true;
  Timer? timer;
  enviarMensagem() async {
    if (_descricaoController.text.trim() != "") {
      try {
        Util.showLoading(context);
        Mensagem mensagem = await MensagemService().enviarMensagem(
          widget.usuario.id!,
          Mensagem(
            descricao: _descricaoController.text,
          ),
        );
        _descricaoController.text = "";
        _listaMensagens.add(mensagem);
        // ignore: use_build_context_synchronously
        Util.hideLoading(context);
        // ignore: use_build_context_synchronously
        setState(() {});
        _scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      } on EventHubException catch (err) {
        Util.hideLoading(context);
        Util.showSnackbarError(context, err.cause);
      }
    }
  }

  buscarMensagens() async {
    try {
      _listaMensagens = await MensagemService().buscarMensagens(
        widget.usuario.id!,
      );
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  buscarMensagensRecebidasENaoLidas() async {
    try {
      _listaMensagens.addAll(
        await MensagemService().buscarMensagensRecebidasENaoLidas(
          widget.usuario.id!,
        ),
      );
      if (mounted) {
        setState(() {});
        _scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarMensagens();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      buscarMensagensRecebidasENaoLidas();
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : WillPopScope(
            onWillPop: () async {
              if (!widget.isGoBackDefault) {
                Navigator.pop(context);
                Util.goToAndOverride(
                  context,
                  SalasBatePapoPage(
                    usuarioAutenticado: widget.usuarioAutenticado,
                    isGoBackDefault: false,
                  ),
                );
                return false;
              } else {
                return true;
              }
            },
            child: EventHubBody(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        Util.montarURlFotoByArquivo(widget.usuario.foto),
                      ),
                      radius: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(widget.usuario.nomeCompleto!)
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(245, 245, 245, 1),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(defaultPadding),
                  child: EventHubTextFormField(
                    label: "Escreva alguma mensagem...",
                    controller: _descricaoController,
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Ionicons.send,
                        color: colorBlue,
                        size: 15,
                      ),
                      onPressed: () {
                        enviarMensagem();
                      },
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return getMensagem(_listaMensagens[i]);
                      },
                      itemCount: _listaMensagens.length,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  getContainerMensagemRecebida(String mensagem, String hora, Mensagem mensagemObj) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: mensagemObj.evento == null ? 20 : 15, vertical: 12),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(244, 246, 249, 1),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: mensagemObj.evento != null
                ? getCardEvento(mensagemObj.evento!)
                : Text(
                    mensagem,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
          ),
          Visibility(
            visible: mensagemObj.evento == null,
            child: const SizedBox(
              width: defaultPadding,
            ),
          ),
          Visibility(
            visible: mensagemObj.evento == null,
            child: Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hora,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getContainerMensagemEnviada(String mensagem, String hora, Mensagem mensagemObj) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: mensagemObj.evento == null ? 20 : 10, vertical: 10),
      decoration: BoxDecoration(
        color: colorBlue.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          topLeft: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: mensagemObj.evento != null
                ? getCardEvento(mensagemObj.evento!)
                : Text(
                    mensagem,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
          ),
          Visibility(
            visible: mensagemObj.evento == null,
            child: const SizedBox(
              width: defaultPadding,
            ),
          ),
          Visibility(
            visible: mensagemObj.evento == null,
            child: Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hora,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCardEvento(Evento evento) {
    return GestureDetector(
      onTap: () {
        Util.goTo(
          context,
          EventoVisualizacaoPage(
            idEvento: evento.id!,
            usuarioAutenticado: widget.usuarioAutenticado,
            isGoBackDefault: true,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 60.0,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(
                0,
                4,
              ),
              spreadRadius: 4,
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      Util.montarURlFotoByArquivo(evento.arquivos![0].arquivo),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Text(
                              evento.nome!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        evento.dataEHoraFormatada!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: colorBlue,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Row(
                              children: [
                                const Icon(
                                  Ionicons.map_outline,
                                  color: colorBlue,
                                  size: 14,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    "${evento.bairro!}, ${evento.cidade!} / ${evento.estado!}",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getMensagem(Mensagem mensagem) {
    if (mensagem.usuarioOrigem!.id != widget.usuario.id) {
      return getContainerMensagemEnviada(mensagem.descricao!, Util.formatarDataOnlyHora(mensagem.dataMensagem), mensagem);
    } else {
      return getContainerMensagemRecebida(mensagem.descricao!, Util.formatarDataOnlyHora(mensagem.dataMensagem), mensagem);
    }
  }
}
