import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/eventos_destaque_page.dart';
import 'package:eventhub/presentation/views/ingresso/meusingressos/meus_ingressos_page.dart';
import 'package:eventhub/presentation/views/perfil/meuperfil/meu_perfil_page.dart';
import 'package:eventhub/presentation/views/publicacao/feed/feed_publicacao_page.dart';
import 'package:eventhub/presentation/views/usuarios/encontrarpessoas/encontrar_pessoas_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EventHubBottomBar extends StatefulWidget {
  final int indexRecursoAtivo;
  final UsuarioAutenticado usuarioAutenticado;

  const EventHubBottomBar({
    super.key,
    required this.indexRecursoAtivo,
    required this.usuarioAutenticado,
  });

  @override
  State<EventHubBottomBar> createState() => _EventHubBottomBarState();
}

class _EventHubBottomBarState extends State<EventHubBottomBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                navegarPara(
                  context,
                  EventosDestaquePage(
                    usuarioAutenticado: widget.usuarioAutenticado,
                  ),
                  0,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.home_outline,
                    color: getColor(0),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Eventos",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: getColor(0),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                navegarPara(
                  context,
                  FeedPublicacao(
                    usuarioAutenticado: widget.usuarioAutenticado,
                  ),
                  1,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.compass_outline,
                    color: getColor(1),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Feed",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: getColor(1),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                navegarPara(
                  context,
                  EncontrarPessoasPage(
                    usuarioAutenticado: widget.usuarioAutenticado,
                  ),
                  2,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.heart_outline,
                    color: getColor(2),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Amigos",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: getColor(2),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                navegarPara(
                  context,
                  MeusIngressosPage(
                    usuarioAutenticado: widget.usuarioAutenticado,
                  ),
                  3,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.ticket_outline,
                    color: getColor(3),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Ingressos",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: getColor(3),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                navegarPara(
                  context,
                  MeuPerfilPage(
                    usuarioAutenticado: widget.usuarioAutenticado,
                  ),
                  4,
                );
              },
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.person_outline,
                        color: getColor(4),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Meu Perfil",
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1,
                          color: getColor(4),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Visibility(
                      visible: false,
                      child: Container(
                        height: 13,
                        width: 13,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(int index) {
    if (widget.indexRecursoAtivo == index) {
      return colorBlue;
    } else {
      return const Color.fromRGBO(158, 158, 158, 1);
    }
  }

  void navegarPara(BuildContext context, Widget page, index) {
    if (widget.indexRecursoAtivo != index) {
      Util.goToAndOverride(context, page);
    }
  }
}
