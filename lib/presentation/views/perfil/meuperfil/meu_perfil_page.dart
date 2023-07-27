import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/views/auth/login/login_page.dart';
import 'package:eventhub/presentation/views/perfil/minhas_informacoes/minhas_informacoes_page.dart';
import 'package:eventhub/services/usuario/usuario_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

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
              height: 1,
              color: Color.fromRGBO(221, 213, 213, 1),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: const Column(
                      children: [
                        Text(
                          "0",
                          style: TextStyle(
                            fontSize: 32,
                            color: Color.fromRGBO(33, 33, 33, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Text(
                          "Eventos",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(97, 97, 97, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 0.5,
                  color: const Color.fromRGBO(221, 213, 213, 1),
                ),
                const Expanded(
                  child: Column(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          fontSize: 32,
                          color: Color.fromRGBO(33, 33, 33, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Text(
                        "Amigos",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(97, 97, 97, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              height: 1,
              color: Color.fromRGBO(221, 213, 213, 1),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            getItemMenu(
              Ionicons.calendar_outline,
              "Gerenciar meus Eventos",
              () {},
              false,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            getItemMenu(
              Ionicons.chatbox_outline,
              "Chat",
              () {},
              false,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Divider(
              height: 1,
              color: Color.fromRGBO(221, 213, 213, 1),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            getItemMenu(
              Ionicons.person_outline,
              "Minhas Informações",
              () {
                Util.goTo(
                  context,
                  MinhasInformacoesPage(
                    usuarioAutenticado: widget.usuarioAutenticado,
                  ),
                );
              },
              false,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            getItemMenu(
              Ionicons.person_circle_outline,
              "Meu Perfil Público",
              () {},
              false,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            getItemMenu(
              Ionicons.people_outline,
              "Adicionar Amigos",
              () {},
              false,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            getItemMenu(
              Ionicons.bar_chart_outline,
              "Sacar Saldo",
              () {},
              false,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Divider(
              height: 1,
              color: Color.fromRGBO(221, 213, 213, 1),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            getItemMenu(
              Ionicons.log_out_outline,
              "Sair do Aplicativo",
              () {
                UsuarioService().logout();
                Util.goToAndOverride(
                  context,
                  const LoginPage(),
                );
              },
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget getItemMenu(
      IconData icone, String label, Function action, bool isDestaque) {
    return GestureDetector(
      onTap: () {
        action();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Icon(
                  icone,
                  color:
                      isDestaque ? const Color.fromRGBO(247, 85, 85, 1) : null,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color:
                      isDestaque ? const Color.fromRGBO(247, 85, 85, 1) : null),
            ),
          ),
          Visibility(
            visible: !isDestaque,
            child: Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.chevron_right,
                    color: isDestaque
                        ? const Color.fromRGBO(247, 85, 85, 1)
                        : null,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
