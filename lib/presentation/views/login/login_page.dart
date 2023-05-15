import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/recuperar-senha/recuperar_senha_email_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isManterConectado = true;
  bool _isSenhaVisivel = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      child: Container(
        padding: const EdgeInsets.all(
          defaultPadding,
        ),
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/logo_eventhub.svg"),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Entre na sua conta",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const SizedBox(
              height: 50,
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
            EventHubTextFormField(
              label: "Senha",
              obscureText: !_isSenhaVisivel,
              prefixIcon: const Icon(
                Ionicons.lock_closed_outline,
                size: 15,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  !_isSenhaVisivel
                      ? Ionicons.eye_outline
                      : Ionicons.eye_off_outline,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    _isSenhaVisivel = !_isSenhaVisivel;
                  });
                },
              ),
              controller: _senhaController,
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  checkColor: colorBlue,
                  value: _isManterConectado,
                  onChanged: (newValue) {
                    setState(() {
                      _isManterConectado = !_isManterConectado;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isManterConectado = !_isManterConectado;
                    });
                  },
                  child: const Text(
                    "Manter Conectado",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Acessar"),
                ],
              ),
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            TextButton(
              child: const Text(
                "Esqueceu a senha?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              onPressed: () {
                Util.goTo(
                  context,
                  const RecuperarSenhaEmailPage(),
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Não possui uma conta?",
                ),
                TextButton(
                  child: const Text(
                    "Crie uma agora!",
                    style: TextStyle(
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
