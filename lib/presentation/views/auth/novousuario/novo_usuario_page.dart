import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:flutter/material.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class NovoUsuarioPage extends StatefulWidget {
  const NovoUsuarioPage({super.key});

  @override
  State<NovoUsuarioPage> createState() => _NovoUsuarioPageState();
}

class _NovoUsuarioPageState extends State<NovoUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _senhaRepetidaController =
      TextEditingController();
  bool _isSenhaVisivel = false;
  bool _isRepitaSenhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Crie sua Conta",
      ),
      child: Container(
        padding: const EdgeInsets.all(
          defaultPadding,
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/images/login.svg",
              width: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  EventHubTextFormField(
                    label: "Nome Completo",
                    prefixIcon: const Icon(
                      Ionicons.person,
                      size: 15,
                    ),
                    controller: _nomeCompletoController,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Nome de Usuário",
                    prefixIcon: const Icon(
                      Ionicons.heart,
                      size: 15,
                    ),
                    controller: _nomeUsuarioController,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "E-mail",
                    prefixIcon: const Icon(
                      Ionicons.mail,
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
                    controller: _senhaController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_isSenhaVisivel
                            ? Ionicons.eye_outline
                            : Ionicons.eye_off_outline,
                        size: 15,
                      ),
                      onPressed: () {
                        if (mounted) {
                          setState(
                            () {
                              _isSenhaVisivel = !_isSenhaVisivel;
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Repita a Senha",
                    obscureText: !_isRepitaSenhaVisivel,
                    prefixIcon: const Icon(
                      Ionicons.lock_closed_outline,
                      size: 15,
                    ),
                    controller: _senhaRepetidaController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_isRepitaSenhaVisivel
                            ? Ionicons.eye_outline
                            : Ionicons.eye_off_outline,
                        size: 15,
                      ),
                      onPressed: () {
                        if (mounted) {
                          setState(
                            () {
                              _isRepitaSenhaVisivel = !_isRepitaSenhaVisivel;
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Continuar"),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
