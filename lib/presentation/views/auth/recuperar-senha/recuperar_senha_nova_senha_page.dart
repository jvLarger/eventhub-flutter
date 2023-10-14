import 'dart:io';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/token/token.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/auth/login/login_page.dart';
import 'package:eventhub/presentation/views/ipconfig/ipconfig_page.dart';
import 'package:eventhub/services/token/token_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class RecuperarSenhaNovaSenhaPage extends StatefulWidget {
  final String email;
  final int codigo;
  const RecuperarSenhaNovaSenhaPage({
    super.key,
    required this.codigo,
    required this.email,
  });

  @override
  State<RecuperarSenhaNovaSenhaPage> createState() => _RecuperarSenhaNovaSenhaPageState();
}

class _RecuperarSenhaNovaSenhaPageState extends State<RecuperarSenhaNovaSenhaPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isNovaSenhaVisivel = false;
  bool _isRepitaNovaSenhaVisivel = false;
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _repitaNovaSenhaController = TextEditingController();

  alterarSenhaUsuario() async {
    try {
      if (_novaSenhaController.text != _repitaNovaSenhaController.text) {
        throw EventHubException("As senhas não coincidem!");
      }
      Util.showLoading(context);

      await TokenService().alterarSenhaUsuario(
        Token(
          codigo: widget.codigo,
          usuario: Usuario(
            email: widget.email,
            senha: _novaSenhaController.text,
          ),
        ),
        // ignore: use_build_context_synchronously
      );
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Util.goTo(
        context,
        const LoginPage(),
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  EventHubTextFormField(
                    label: "Nova Senha",
                    obscureText: !_isNovaSenhaVisivel,
                    prefixIcon: const Icon(
                      Ionicons.lock_closed_outline,
                      size: 15,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_isNovaSenhaVisivel ? Ionicons.eye_outline : Ionicons.eye_off_outline,
                        size: 15,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNovaSenhaVisivel = !_isNovaSenhaVisivel;
                        });
                      },
                    ),
                    controller: _novaSenhaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Senha não informada!';
                      }
                      return null;
                    },
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
                        !_isRepitaNovaSenhaVisivel ? Ionicons.eye_outline : Ionicons.eye_off_outline,
                        size: 15,
                      ),
                      onPressed: () {
                        setState(() {
                          _isRepitaNovaSenhaVisivel = !_isRepitaNovaSenhaVisivel;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirmação de Senha não informada!';
                      }
                      return null;
                    },
                    controller: _repitaNovaSenhaController,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            ElevatedButton(
              onPressed: () {
                alterarSenhaUsuario();
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
