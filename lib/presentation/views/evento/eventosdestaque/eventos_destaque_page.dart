import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/components/informacoes_usuario.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class EventosDestaquePage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const EventosDestaquePage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<EventosDestaquePage> createState() => _EventosDestaquePageState();
}

class _EventosDestaquePageState extends State<EventosDestaquePage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      bottomNavigationBar: EventHubBottomBar(
        indexRecursoAtivo: 0,
        usuarioAutenticado: widget.usuarioAutenticado,
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            InformacoesUsuario(
              usuarioAutenticado: widget.usuarioAutenticado,
            ),
          ],
        ),
      ),
    );
  }
}
