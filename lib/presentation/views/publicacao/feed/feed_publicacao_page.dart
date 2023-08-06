import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/components/informacoes_usuario.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class FeedPublicacao extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const FeedPublicacao({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<FeedPublicacao> createState() => _FeedPublicacaoState();
}

class _FeedPublicacaoState extends State<FeedPublicacao> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      bottomNavigationBar: EventHubBottomBar(
        indexRecursoAtivo: 1,
        usuarioAutenticado: widget.usuarioAutenticado,
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            InformacoesUsuario(
              usuarioAutenticado: widget.usuarioAutenticado,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Nova Publicação"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
