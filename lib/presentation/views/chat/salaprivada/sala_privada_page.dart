import 'dart:async';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/mensagem/mensagem.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/services/mensagem/mensagem_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SalaPrivadaPage extends StatefulWidget {
  final Usuario usuario;
  const SalaPrivadaPage({
    super.key,
    required this.usuario,
  });

  @override
  State<SalaPrivadaPage> createState() => _SalaPrivadaPageState();
}

class _SalaPrivadaPageState extends State<SalaPrivadaPage> {
  final TextEditingController _descricaoController = TextEditingController();
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

        _listaMensagens.add(mensagem);
        // ignore: use_build_context_synchronously
        Util.hideLoading(context);
        // ignore: use_build_context_synchronously
        setState(() {});
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
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarMensagens();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        : EventHubBody(
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
            bottomNavigationBar: Container(
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
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  getMensagemRecebida(),
                  getMensagemEnviada(),
                ],
              ),
            ),
          );
  }

  Widget getMensagemRecebida() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  getContainerMensagemRecebida("Oii, tudo bem?", "10:00"),
                  getContainerMensagemRecebida("Você vai ir no show hoje a noite? Mal posso esperar!", "10:00"),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget getMensagemEnviada() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                children: [
                  getContainerMensagemEnviada("Simm, vou ir!", "10:00"),
                  getContainerMensagemEnviada("Mal posso esperar!", "10:00"),
                ],
              ),
            )
          ],
        )
      ],
    );
    ;
  }

  getContainerMensagemRecebida(String mensagem, String hora) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
          color: Color.fromRGBO(244, 246, 249, 1),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Text(
              mensagem,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hora,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getContainerMensagemEnviada(String mensagem, String hora) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
          color: colorBlue.withOpacity(0.8),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            topLeft: Radius.circular(12),
          )),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Text(
              mensagem,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hora,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
