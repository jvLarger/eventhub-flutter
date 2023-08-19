import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/auth/recuperar-senha/recuperar_senha_nova_senha_page.dart';
import 'package:eventhub/services/token/token_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class RecuperarSenhaCodigoPage extends StatefulWidget {
  final String email;
  const RecuperarSenhaCodigoPage({
    super.key,
    required this.email,
  });

  @override
  State<RecuperarSenhaCodigoPage> createState() => _RecuperarSenhaCodigoPageState();
}

class _RecuperarSenhaCodigoPageState extends State<RecuperarSenhaCodigoPage> {
  final TextEditingController _digitoUmController = TextEditingController();
  final TextEditingController _digitoDoisController = TextEditingController();
  final TextEditingController _digitoTresController = TextEditingController();
  final TextEditingController _digitoQuatroController = TextEditingController();
  final FocusNode _digitoUmFocus = FocusNode();
  final FocusNode _digitoDoisFocus = FocusNode();
  final FocusNode _digitoTresFocus = FocusNode();
  final FocusNode _digitoQuatroFocus = FocusNode();
  final FocusNode _verificarFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  validarTokenInformado() async {
    try {
      String codigoString = _digitoUmController.text + _digitoDoisController.text + _digitoTresController.text + _digitoQuatroController.text;
      int codigo = int.parse(codigoString);
      await TokenService().validarTokenInformado(codigo, widget.email);
      // ignore: use_build_context_synchronously
      Util.goTo(
        context,
        RecuperarSenhaNovaSenhaPage(
          codigo: codigo,
          email: widget.email,
        ),
      );
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Código de Verificação",
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Text(
              "Informe o código  que foi enviado para o e-mail informado caso exista uma conta cadastrada.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: EventHubTextFormField(
                      controller: _digitoUmController,
                      focusNode: _digitoUmFocus,
                      textInputType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        return null;
                      },
                      onchange: (value) {
                        putFocus(value, 1);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: EventHubTextFormField(
                      controller: _digitoDoisController,
                      focusNode: _digitoDoisFocus,
                      textInputType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        return null;
                      },
                      onchange: (value) {
                        putFocus(value, 2);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: EventHubTextFormField(
                      controller: _digitoTresController,
                      focusNode: _digitoTresFocus,
                      textInputType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        return null;
                      },
                      onchange: (value) {
                        putFocus(value, 3);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: EventHubTextFormField(
                      controller: _digitoQuatroController,
                      focusNode: _digitoQuatroFocus,
                      textInputType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        return null;
                      },
                      onchange: (value) {
                        putFocus(value, 4);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            ElevatedButton(
              focusNode: _verificarFocus,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  validarTokenInformado();
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Verificar"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void putFocus(String value, int nrInputAtual) {
    if (value.isEmpty) {
      if (nrInputAtual == 2) {
        _digitoUmFocus.requestFocus();
      } else if (nrInputAtual == 3) {
        _digitoDoisFocus.requestFocus();
      } else if (nrInputAtual == 4) {
        _digitoTresFocus.requestFocus();
      }
    } else {
      if (nrInputAtual == 1) {
        _digitoDoisFocus.requestFocus();
      } else if (nrInputAtual == 2) {
        _digitoTresFocus.requestFocus();
      } else if (nrInputAtual == 3) {
        _digitoQuatroFocus.requestFocus();
      }
    }
  }
}
