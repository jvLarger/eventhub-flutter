import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeuPerfilPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const MeuPerfilPage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<MeuPerfilPage> createState() => _MeuPerfilPageState();
}

class _MeuPerfilPageState extends State<MeuPerfilPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      bottomNavigationBar: EventHubBottomBar(
        indexRecursoAtivo: 4,
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
                  "Perfil",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage("${Api.baseURL}/publico/imagens/imagem.png"),
                  radius: 60,
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(
              widget.usuarioAutenticado.nomeCompleto!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Divider(
              height: 2,
            )
          ],
        ),
      ),
    );
  }
}
