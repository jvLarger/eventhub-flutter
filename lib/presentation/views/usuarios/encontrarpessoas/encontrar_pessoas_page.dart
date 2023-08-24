import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/usuario/page_usuario.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/usuarios/encontrarpessoas/components/lista_pessoas.dart';
import 'package:eventhub/services/usuario/usuario_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class EncontrarPessoasPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const EncontrarPessoasPage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<EncontrarPessoasPage> createState() => _EncontrarPessoasPageState();
}

class _EncontrarPessoasPageState extends State<EncontrarPessoasPage> {
  int page = 0;
  List<Usuario> _listaUsuarios = [];
  buscarPorNome(String nomeCompleto) async {
    page = 0;
    _listaUsuarios = [];
    try {
      if (nomeCompleto.trim().isNotEmpty) {
        PageUsuario pageUsuario = await UsuarioService().encontrarPessoas(nomeCompleto, page);
        _listaUsuarios.addAll(pageUsuario.content!);
      }

      setState(() {});
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      bottomNavigationBar: EventHubBottomBar(
        indexRecursoAtivo: 2,
        usuarioAutenticado: widget.usuarioAutenticado,
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/logo_eventhub.svg",
                  width: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Usuários",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            EventHubTextFormField(
              label: "Pesquise por alguém",
              prefixIcon: const Icon(
                Ionicons.search,
                size: 15,
              ),
              onchange: (value) {
                buscarPorNome(value);
              },
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            ListaPessoas(
              listaUsuario: _listaUsuarios,
            ),
          ],
        ),
      ),
    );
  }
}
