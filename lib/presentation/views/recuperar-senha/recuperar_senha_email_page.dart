import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/recuperar-senha/recuperar_senha_codigo_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class RecuperarSenhaEmailPage extends StatefulWidget {
  const RecuperarSenhaEmailPage({super.key});

  @override
  State<RecuperarSenhaEmailPage> createState() =>
      _RecuperarSenhaEmailPageState();
}

class _RecuperarSenhaEmailPageState extends State<RecuperarSenhaEmailPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Recuperar Senha",
      ),
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            SvgPicture.asset(
              "assets/images/recuperar_senha.svg",
              width: 200,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Text(
              "Informe a seguir um e-mail para o qual possamos entrar em contato.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            EventHubTextFormField(
              label: "E-mail",
              prefixIcon: const Icon(
                Ionicons.mail_outline,
                size: 15,
              ),
              controller: _emailController,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            ElevatedButton(
              onPressed: () {
                Util.goTo(context, RecuperarSenhaCodigoPage());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
