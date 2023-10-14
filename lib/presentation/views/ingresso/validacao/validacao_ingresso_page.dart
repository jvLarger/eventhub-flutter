import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/qrcode/qrcode_scanner_page.dart';
import 'package:eventhub/services/ingresso/ingresso_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ValidacaoIngressoPage extends StatefulWidget {
  final String identificadorIngresso;
  final bool isGoBackDefault;
  const ValidacaoIngressoPage({
    super.key,
    required this.identificadorIngresso,
    required this.isGoBackDefault,
  });

  @override
  State<ValidacaoIngressoPage> createState() => _ValidacaoIngressoPageState();
}

class _ValidacaoIngressoPageState extends State<ValidacaoIngressoPage> {
  bool _isLoading = true;
  bool _isIngressoValido = true;
  String mensagemErro = "";

  Ingresso _ingresso = Ingresso();

  utilizarIngresso() async {
    try {
      Util.showLoading(context);

      await IngressoSevice().utilizarIngresso(_ingresso.id!);

      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Ingresso utilizado com sucesso!");
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Util.goTo(context, const QrCodeLeituraPage());
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

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
        : WillPopScope(
            onWillPop: () async {
              if (!widget.isGoBackDefault) {
                Navigator.pop(context);
                Util.goToAndOverride(
                  context,
                  const QrCodeLeituraPage(),
                );
                return false;
              } else {
                return true;
              }
            },
            child: EventHubBody(
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
                            width: 200,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            "Este ingresso é válido!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Para prosseguir com a sua utilização clique no botão abaixo. Lembre-se que você deve validar os demais dados do ingresso.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const Text(
                            "Evento",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(97, 97, 97, 1),
                            ),
                          ),
                          Text(
                            _ingresso.evento != null ? _ingresso.evento!.nome! : "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const Text(
                            "Pessoa",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(97, 97, 97, 1),
                            ),
                          ),
                          Text(
                            _ingresso.nome ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const Text(
                            "Documento",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(97, 97, 97, 1),
                            ),
                          ),
                          Text(
                            _ingresso.documentoPrincipal != null
                                ? _ingresso.documentoPrincipal!.length == 11
                                    ? Util.aplicarMascara(_ingresso.documentoPrincipal!, "###.###.###-##")
                                    : Util.aplicarMascara(_ingresso.documentoPrincipal!, "##.###.###/####-##")
                                : "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const Text(
                            "Data e Hora",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(97, 97, 97, 1),
                            ),
                          ),
                          Text(
                            _ingresso.evento != null ? _ingresso.evento!.dataEHoraFormatada! : "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                              width: 200,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            const Text(
                              "Esse ingresso não é válido!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              mensagemErro,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
