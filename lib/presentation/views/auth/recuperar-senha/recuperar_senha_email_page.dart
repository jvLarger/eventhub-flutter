import 'dart:io';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/token/token.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/auth/recuperar-senha/recuperar_senha_codigo_page.dart';
import 'package:eventhub/presentation/views/ipconfig/ipconfig_page.dart';
import 'package:eventhub/services/token/token_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class RecuperarSenhaEmailPage extends StatefulWidget {
  const RecuperarSenhaEmailPage({super.key});

  @override
  State<RecuperarSenhaEmailPage> createState() => _RecuperarSenhaEmailPageState();
}

class _RecuperarSenhaEmailPageState extends State<RecuperarSenhaEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  enviarTokenRecuperacao() async {
    try {
      Util.showLoading(context);
      await TokenService().enviarTokenRecuperacao(
        Token(
          usuario: Usuario(
            email: _emailController.text,
          ),
        ),
      );
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Util.goTo(
        context,
        RecuperarSenhaCodigoPage(
          email: _emailController.text,
        ),
      );
    } on SocketException {
      Util.showSnackbarError(context, "Não foi possível se conectar com esse host");
      Util.goToAndOverride(context, const IpConfigPage());
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Recuperar Senha",
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
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
                        return 'E-mail não informada!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  enviarTokenRecuperacao();
                }
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
