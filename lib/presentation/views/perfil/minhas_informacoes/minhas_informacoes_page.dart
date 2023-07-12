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
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

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

  buscarUsuarioLogado() async {
    try {
      Usuario usuario = await UsuarioService().buscarUsuarioLogado();
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
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: widget.usuarioAutenticado.foto != null
                      ? NetworkImage(
                          "${Api.baseURL}/publico/imagens/${widget.usuarioAutenticado.foto!.nomeAbsoluto!}")
                      : const NetworkImage(""),
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding,
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
