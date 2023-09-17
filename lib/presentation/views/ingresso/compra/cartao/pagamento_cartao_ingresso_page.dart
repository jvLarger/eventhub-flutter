import 'package:brasil_fields/brasil_fields.dart';
import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/model/pagamento/pagamento.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/ingresso/meusingressos/meus_ingressos_page.dart';
import 'package:eventhub/services/ingresso/ingresso_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';

class PagamentoCartaoIngressoPage extends StatefulWidget {
  final Ingresso ingresso;
  final UsuarioAutenticado usuarioAutenticado;
  const PagamentoCartaoIngressoPage({
    super.key,
    required this.ingresso,
    required this.usuarioAutenticado,
  });

  @override
  State<PagamentoCartaoIngressoPage> createState() => _PagamentoCartaoIngressoPageState();
}

class _PagamentoCartaoIngressoPageState extends State<PagamentoCartaoIngressoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _numeroCartaoController = TextEditingController();
  final TextEditingController _validadeController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final MaskedTextController _documentoPrincipalController = MaskedTextController(mask: '000.000.000-00');

  comprarIngresso() async {
    try {
      Ingresso ingresso = widget.ingresso;
      ingresso.pagamento = Pagamento(
        cvv: _cvvController.text,
        documentoPrincipal: _documentoPrincipalController.text,
        nomeTitular: _nomeCompletoController.text,
        numero: _numeroCartaoController.text,
        tipoCartao: "CC",
        validade: _validadeController.text,
      );

      await IngressoSevice().comprarIngresso(ingresso);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MeusIngressosPage(
              usuarioAutenticado: widget.usuarioAutenticado,
            ),
          ),
          (Route<dynamic> route) => false);

      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(
        context,
        "Ingresso adquirido com sucesso!",
      );
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  void showMessagePagamento() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Pagamento',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja realmente confirmar este pagamento?'),
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
                comprarIngresso();
                Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Pagamento",
      ),
      bottomNavigationBar: EventHubBottomButton(
        label: "Pagar - R\$ ${Util.formatarReal(widget.ingresso.evento!.valor)}",
        onTap: () {
          if (_formKey.currentState!.validate()) {
            showMessagePagamento();
          }
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/images/credit.svg",
          ),
          Padding(
              padding: const EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                bottom: defaultPadding,
              ),
              child: Form(
                key: _formKey,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Documento não informada!';
                        }
                        return null;
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
                      controller: _numeroCartaoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Número do cartão não informado!';
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
                            textInputType: TextInputType.number,
                            controller: _validadeController,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, ValidadeCartaoInputFormatter(maxLength: 4)],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Validade não informada!';
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
                            textInputType: TextInputType.number,
                            prefixIcon: const Icon(
                              Ionicons.key_outline,
                              size: 15,
                            ),
                            controller: _cvvController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'CVV não informado!';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
