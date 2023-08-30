import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/auth/novousuario/novo_usuario_page.dart';
import 'package:eventhub/presentation/views/auth/recuperar-senha/recuperar_senha_email_page.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/eventos_destaque_page.dart';
import 'package:eventhub/services/usuario/usuario_service.dart';
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
  final _formKey = GlobalKey<FormState>();
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

  login() async {
    try {
      Usuario usuario = Usuario(
        email: _emailController.text,
        senha: _senhaController.text,
      );

      UsuarioAutenticado usuarioAutenticado = await UsuarioService().login(usuario, _isManterConectado);

      await UsuarioService().tratarIdentificadorNotificacao(usuarioAutenticado);

      // ignore: use_build_context_synchronously
      Util.goTo(
        context,
        EventosDestaquePage(
          usuarioAutenticado: usuarioAutenticado,
        ),
      );
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      child: Container(
        padding: const EdgeInsets.all(
          defaultPadding,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            SvgPicture.asset(
              "assets/images/logo_eventhub.svg",
              width: 100,
            ),
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  EventHubTextFormField(
                    label: "E-mail",
                    prefixIcon: const Icon(
                      Ionicons.mail_outline,
                      size: 15,
                    ),
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-mail não informado!';
                      }
                      return null;
                    },
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
                        !_isSenhaVisivel ? Ionicons.eye_outline : Ionicons.eye_off_outline,
                        size: 15,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSenhaVisivel = !_isSenhaVisivel;
                        });
                      },
                    ),
                    controller: _senhaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Senha não informada!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  login();
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  onPressed: () {
                    Util.goTo(
                      context,
                      const NovoUsuarioPage(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
