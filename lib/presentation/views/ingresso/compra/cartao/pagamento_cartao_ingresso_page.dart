import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';

class PagamentoCartaoIngressoPage extends StatefulWidget {
  const PagamentoCartaoIngressoPage({super.key});

  @override
  State<PagamentoCartaoIngressoPage> createState() => _PagamentoCartaoIngressoPageState();
}

class _PagamentoCartaoIngressoPageState extends State<PagamentoCartaoIngressoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _numeroCartaoController = TextEditingController();
  final MaskedTextController _documentoPrincipalController = MaskedTextController(mask: '000.000.000-00');
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Pagamento",
      ),
      bottomNavigationBar: EventHubBottomButton(
        label: "Pagar - R\$ 450,00",
        onTap: () {},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/images/credit.svg",
          ),
          Padding(
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              bottom: defaultPadding,
            ),
            child: Column(
              children: [
                EventHubTextFormField(
                  label: "Nome no Cartão",
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
                  label: "CPF ou CNPJ",
                  prefixIcon: const Icon(
                    Ionicons.id_card_outline,
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
                  label: "Número do Cartão",
                  prefixIcon: const Icon(
                    Ionicons.card_outline,
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
                Row(
                  children: [
                    Expanded(
                      child: EventHubTextFormField(
                        label: "Validade",
                        prefixIcon: const Icon(
                          Ionicons.calendar_outline,
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
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    Expanded(
                      child: EventHubTextFormField(
                        label: "CVV",
                        prefixIcon: const Icon(
                          Ionicons.key_outline,
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
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
