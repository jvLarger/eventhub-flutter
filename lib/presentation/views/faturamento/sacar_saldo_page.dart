import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class SacarSaldoPage extends StatefulWidget {
  const SacarSaldoPage({super.key});

  @override
  State<SacarSaldoPage> createState() => _SacarSaldoPageState();
}

class _SacarSaldoPageState extends State<SacarSaldoPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Sacar Saldo",
      ),
      bottomNavigationBar: EventHubBottomButton(
        label: "Sacar",
        onTap: () {},
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Text(
              "R\$ 4587,23",
              style: TextStyle(
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
            Form(
              child: Column(
                children: [
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  EventHubTextFormField(
                    label: "Titular da Conta Bancária",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Titular não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "CPF do titular da conta",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CPF não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Número do Banco",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Número do Banco não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Número da Agência",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Número da Agência não informada!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Número da Conta",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Número da Conta não informada!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
