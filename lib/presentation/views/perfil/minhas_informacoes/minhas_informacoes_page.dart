import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/services/usuario/usuario_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';

class MinhasInformacoesPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const MinhasInformacoesPage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<MinhasInformacoesPage> createState() => _MinhasInformacoesPageState();
}

class _MinhasInformacoesPageState extends State<MinhasInformacoesPage> {
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _dataComemorativaController = TextEditingController();
  final MaskedTextController _documentoPrincipalController = MaskedTextController(mask: '000.000.000-00');
  final MaskedTextController _telefoneController = MaskedTextController(mask: '00 0 0000-0000');

  buscarUsuarioLogado() async {
    try {
      Usuario usuario = await UsuarioService().buscarUsuarioLogado();

      _nomeCompletoController.text = usuario.nomeCompleto!;
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
    buscarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Minhas Informações",
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: widget.usuarioAutenticado.foto != null ? NetworkImage("${Api.baseURL}/publico/imagens/${widget.usuarioAutenticado.foto!.nomeAbsoluto!}") : const NetworkImage(""),
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding * 1.5,
            ),
            Form(
              child: Column(
                children: [
                  EventHubTextFormField(
                    label: "Nome Completo",
                    prefixIcon: const Icon(
                      Ionicons.person,
                      size: 15,
                    ),
                    controller: _nomeCompletoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome Completo não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Data de Nascimento",
                    prefixIcon: const Icon(
                      Ionicons.calendar,
                      size: 15,
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        String dataFormatada = DateFormat('dd/MM/yyyy').format(pickedDate);
                        _dataComemorativaController.text = dataFormatada;
                      }
                    },
                    controller: _dataComemorativaController,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "CPF ou CNPJ",
                    prefixIcon: const Icon(
                      Ionicons.card_outline,
                      size: 15,
                    ),
                    controller: _documentoPrincipalController,
                    onchange: (value) {
                      if (mounted) {
                        setState(() {
                          if (Util.getSomenteNumeros(value).length < 11) {
                            _documentoPrincipalController.updateMask('000.000.000-00');
                          } else {
                            _documentoPrincipalController.updateMask('00.000.000/0000-00');
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Telefone",
                    prefixIcon: const Icon(
                      Ionicons.phone_portrait_outline,
                      size: 15,
                    ),
                    controller: _telefoneController,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
