import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
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
    return const EventHubBody(
      child: Column(),
    );
  }
}
