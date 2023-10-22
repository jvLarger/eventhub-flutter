import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/faturamento/faturamento_pagamento.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/faturamento/listagem_faturamentos_page.dart';
import 'package:eventhub/services/faturamento/faturamento_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class SacarSaldoPage extends StatefulWidget {
  const SacarSaldoPage({super.key});

  @override
  State<SacarSaldoPage> createState() => _SacarSaldoPageState();
}

class _SacarSaldoPageState extends State<SacarSaldoPage> {
  FaturamentoPagamento _faturamentoPagamento = FaturamentoPagamento();
  bool _isLoading = true;

  desvincularContaStripe() async {
    try {
      Util.showLoading(context);

      await FaturamentoService().desvincularContaStripe();
      await buscarFaturamentos(false);
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Conta Stripe desvinculada do Event Hub com sucesso!");
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  pagarFaturameto() async {
    try {
      Util.showLoading(context);

      await FaturamentoService().pagarFaturameto();
      await buscarFaturamentos(false);
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Valores transferidos para a sua conta Stripe com sucesso!");
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  tratarTransferir() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Transferir Valores',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja realmente transferir esses valores para a sua conta Stripe?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Confirmar',
              ),
              onPressed: () {
                Navigator.of(context).pop();
                pagarFaturameto();
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  tratarDesvincularContaStripe() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Remover Vinculo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja realmente desvincular essa conta stripe da plataforma Event Hub?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                desvincularContaStripe();
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  buscarFaturamentos(isWithManualLoading) async {
    try {
      if (isWithManualLoading) {
        Util.showLoading(context);
      }

      _faturamentoPagamento = await FaturamentoService().buscarFauramentos();

      if (isWithManualLoading) {
        // ignore: use_build_context_synchronously
        Util.hideLoading(context);
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on EventHubException catch (err) {
      if (isWithManualLoading) {
        Util.hideLoading(context);
      }
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarFaturamentos(false);
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
              title: "Meu Resultado",
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  Visibility(
                    visible: _faturamentoPagamento.email != null && _faturamentoPagamento.email!.isNotEmpty,
                    child: Column(
                      children: [
                        Text(
                          "R\$ ${Util.formatarReal(_faturamentoPagamento.valorTotalFaturado)}",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "R\$ Disponível",
                          style: TextStyle(
                            color: Color.fromRGBO(97, 97, 97, 1),
                            fontSize: 16,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Text(
                          "E-mail da conta Stripe",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(97, 97, 97, 1),
                          ),
                        ),
                        Text(
                          _faturamentoPagamento.email ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Visibility(
                          visible: !_faturamentoPagamento.payoutsEnabled!,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: defaultPadding),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(247, 85, 85, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Sua conta Stripe está conectada ao Event Hub mas não está liberada para receber pagamentos. Por favor, acesse seu painel na Stripe e verifique o motivo.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          color: Color.fromRGBO(221, 213, 213, 1),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        ListTile(
                          onTap: () {
                            Util.goTo(
                              context,
                              ListagemFaturamentosPage(
                                faturamentos: _faturamentoPagamento.faturamentosLiberados!,
                                tituloPage: "Pagamentos Liberados",
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          iconColor: const Color.fromRGBO(97, 97, 97, 1),
                          leading: const Icon(Ionicons.checkmark_circle_outline),
                          trailing: const Icon(
                            Ionicons.chevron_forward,
                            size: 18,
                          ),
                          title: const Text(
                            "Pagamentos Liberados",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Util.goTo(
                              context,
                              ListagemFaturamentosPage(
                                faturamentos: _faturamentoPagamento.proximosFaturamentos!,
                                tituloPage: "Próximos Pagamentos",
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          iconColor: const Color.fromRGBO(97, 97, 97, 1),
                          leading: const Icon(Ionicons.alarm_outline),
                          trailing: const Icon(
                            Ionicons.chevron_forward,
                            size: 18,
                          ),
                          title: const Text(
                            "Próximos Pagamentos",
                            style: TextStyle(
                              color: Color.fromRGBO(33, 33, 33, 1),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Util.goTo(
                              context,
                              ListagemFaturamentosPage(
                                faturamentos: _faturamentoPagamento.faturamentosPagos!,
                                tituloPage: "Pagamentos Concluídos",
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          iconColor: const Color.fromRGBO(97, 97, 97, 1),
                          leading: const Icon(Ionicons.receipt_outline),
                          trailing: const Icon(
                            Ionicons.chevron_forward,
                            size: 18,
                          ),
                          title: const Text(
                            "Pagamentos Concluídos",
                            style: TextStyle(
                              color: Color.fromRGBO(33, 33, 33, 1),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            tratarDesvincularContaStripe();
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          iconColor: const Color.fromRGBO(247, 85, 85, 1),
                          leading: const Icon(Ionicons.trash_outline),
                          title: const Text(
                            "Desvincular conta Stripe",
                            style: TextStyle(
                              color: Color.fromRGBO(247, 85, 85, 1),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Divider(
                          height: 1,
                          color: Color.fromRGBO(221, 213, 213, 1),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Visibility(
                          visible: _faturamentoPagamento.payoutsEnabled != null && _faturamentoPagamento.payoutsEnabled! && _faturamentoPagamento.valorTotalFaturado! > 0.0,
                          child: ElevatedButton(
                            onPressed: () {
                              tratarTransferir();
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Transferir"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _faturamentoPagamento.email == null || _faturamentoPagamento.email!.isEmpty,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              "assets/images/stripe_logo.png",
                              width: 150,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("O Event Hub realiza as suas transações atráves de uma empresa intermediadora de pagamentos chamada Stripe."),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Para que você possa receber os pagamentos que se originaram no aplicativo é necessário que você crie ou conecte sua conta Stripe a nossa lista de parceiros, dessa forma será possível transferirir valores para sua conta. "),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Isso não significa que o Event Hub terá acesso a informações sensíveis ou acesso a sua conta!"),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Ao clicar no botão abaixo você será redirecionado para uma página sobre o domínio Stripe onde você poderá fazer o vinculo com o Event Hub"),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                if (!await launchUrl(
                                  Uri.parse(_faturamentoPagamento.linkConnectStripe!),
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  throw Exception('Could not launch ${_faturamentoPagamento.linkConnectStripe!}');
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Vincular Conta"),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Já vinculou sua conta?"),
                                TextButton(
                                  onPressed: () {
                                    buscarFaturamentos(true);
                                  },
                                  child: const Text("Atualizar a Página"),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
