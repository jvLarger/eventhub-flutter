import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/ingresso/compra/formapagamento/formas_pagamento_ingresso_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class TitularIngressoPage extends StatefulWidget {
  const TitularIngressoPage({super.key});

  @override
  State<TitularIngressoPage> createState() => _TitularIngressoPageState();
}

class _TitularIngressoPageState extends State<TitularIngressoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _dataComemorativaController = TextEditingController();
  final MaskedTextController _documentoPrincipalController = MaskedTextController(mask: '000.000.000-00');
  final MaskedTextController _telefoneController = MaskedTextController(mask: '00 0 0000-0000');
  bool _isLiOsTermos = false;
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Ingresso",
      ),
      bottomNavigationBar: EventHubBottomButton(
        label: "Continuar",
        onTap: () {
          Util.goTo(context, FormasPagamentoIngressoPage());
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Informações do titular do Ingresso"),
            SizedBox(
              height: 10,
            ),
            EventHubTextFormField(
              label: "Nome Completo",
              prefixIcon: const Icon(
                Ionicons.person,
                size: 15,
              ),
              controller: _nomeCompletoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nome Completo não informado!';
                }
                return null;
              },
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            EventHubTextFormField(
              label: "Data de Nascimento",
              prefixIcon: const Icon(
                Ionicons.calendar,
                size: 15,
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dataComemorativaController.text.isEmpty
                      ? DateTime.now()
                      : DateTime.now().copyWith(
                          day: int.parse(_dataComemorativaController.text.split("/")[0]),
                          month: int.parse(_dataComemorativaController.text.split("/")[1]),
                          year: int.parse(_dataComemorativaController.text.split("/")[2]),
                        ),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  String dataFormatada = DateFormat('dd/MM/yyyy').format(pickedDate);
                  _dataComemorativaController.text = dataFormatada;
                }
              },
              suffixIcon: IconButton(
                onPressed: () {
                  _dataComemorativaController.text = "";
                },
                icon: const Icon(
                  Ionicons.trash,
                  size: 15,
                ),
              ),
              controller: _dataComemorativaController,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            EventHubTextFormField(
              label: "CPF ou CNPJ",
              prefixIcon: const Icon(
                Ionicons.card_outline,
                size: 15,
              ),
              controller: _documentoPrincipalController,
              onchange: (value) {
                if (mounted) {
                  setState(() {
                    if (Util.getSomenteNumeros(value).length < 11) {
                      _documentoPrincipalController.updateMask('000.000.000-00');
                    } else {
                      _documentoPrincipalController.updateMask('00.000.000/0000-00');
                    }
                  });
                }
              },
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            EventHubTextFormField(
              label: "E-mail",
              prefixIcon: const Icon(
                Ionicons.mail_open,
                size: 15,
              ),
              controller: _nomeCompletoController,
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
              label: "Telefone",
              prefixIcon: const Icon(
                Ionicons.phone_portrait_outline,
                size: 15,
              ),
              controller: _telefoneController,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  checkColor: colorBlue,
                  value: _isLiOsTermos,
                  onChanged: (newValue) {
                    setState(() {
                      _isLiOsTermos = !_isLiOsTermos;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLiOsTermos = !_isLiOsTermos;
                    });
                  },
                  child: const Text(
                    "Declaro que li as informações do evento.",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
