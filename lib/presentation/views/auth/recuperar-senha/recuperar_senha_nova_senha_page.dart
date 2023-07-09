import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/auth/login/login_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class RecuperarSenhaNovaSenhaPage extends StatefulWidget {
  const RecuperarSenhaNovaSenhaPage({super.key});

  @override
  State<RecuperarSenhaNovaSenhaPage> createState() =>
      _RecuperarSenhaNovaSenhaPageState();
}

class _RecuperarSenhaNovaSenhaPageState
    extends State<RecuperarSenhaNovaSenhaPage> {
  bool _isNovaSenhaVisivel = false;
  bool _isRepitaNovaSenhaVisivel = false;
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _repitaNovaSenhaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Criar nova Senha",
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            SvgPicture.asset(
              "assets/images/nova_senha.svg",
              width: 200,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Text(
              "Crie sua nova senha para acessar o aplicativo.",
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            EventHubTextFormField(
              label: "Nova Senha",
              obscureText: !_isNovaSenhaVisivel,
              prefixIcon: const Icon(
                Ionicons.lock_closed_outline,
                size: 15,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  !_isNovaSenhaVisivel
                      ? Ionicons.eye_outline
                      : Ionicons.eye_off_outline,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    _isNovaSenhaVisivel = !_isNovaSenhaVisivel;
                  });
                },
              ),
              controller: _novaSenhaController,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            EventHubTextFormField(
              label: "Repita a Nova Senha",
              obscureText: !_isRepitaNovaSenhaVisivel,
              prefixIcon: const Icon(
                Ionicons.lock_closed_outline,
                size: 15,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  !_isRepitaNovaSenhaVisivel
                      ? Ionicons.eye_outline
                      : Ionicons.eye_off_outline,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    _isRepitaNovaSenhaVisivel = !_isRepitaNovaSenhaVisivel;
                  });
                },
              ),
              controller: _repitaNovaSenhaController,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            ElevatedButton(
              onPressed: () {
                Util.goTo(
                  context,
                  const LoginPage(),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Continuar"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
