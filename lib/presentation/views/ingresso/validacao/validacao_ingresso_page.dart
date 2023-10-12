import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/services/ingresso/ingresso_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ValidacaoIngressoPage extends StatefulWidget {
  final String identificadorIngresso;
  const ValidacaoIngressoPage({
    super.key,
    required this.identificadorIngresso,
  });

  @override
  State<ValidacaoIngressoPage> createState() => _ValidacaoIngressoPageState();
}

class _ValidacaoIngressoPageState extends State<ValidacaoIngressoPage> {
  bool _isLoading = true;
  bool _isIngressoValido = true;
  String mensagemErro = "";

  Ingresso _ingresso = Ingresso();

  utilizarIngresso() async {}

  validarIngresso() async {
    try {
      _ingresso = await IngressoSevice().validarIngresso(widget.identificadorIngresso);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isIngressoValido = true;
        });
      }
    } on EventHubException catch (err) {
      mensagemErro = err.cause;
      print(mensagemErro);
      if (mounted) {
        setState(
          () {
            _isLoading = false;
            _isIngressoValido = false;
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    validarIngresso();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : EventHubBody(
            topWidget: const EventHubTopAppbar(
              title: "Validação do Ingresso",
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  Visibility(
                    visible: _isIngressoValido,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/images/success.svg",
                          width: 100,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Este ingresso é valido!\nPara prosseguir com a sua utilização clique no botão abaixo. Lembre-se que você deve validar os demais dados do ingresso.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            utilizarIngresso();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Utilizar"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !_isIngressoValido,
                    child: Container(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/images/error.svg",
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
