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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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

  comprarIngresso() async {
    try {
      Util.showLoading(context);
      String tokenCartaoCredito = await getTokenCartaoStripe();

      Ingresso ingresso = widget.ingresso;
      ingresso.pagamento = Pagamento(
        tipoCartao: "CC",
        token: tokenCartaoCredito,
      );

      await IngressoSevice().comprarIngresso(ingresso);
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MeusIngressosPage(
              usuarioAutenticado: widget.usuarioAutenticado,
            ),
          ),
          (Route<dynamic> route) => false);

      // ignore: use_build_context_synchronously
      Util.showSnackbarInfo(
        context,
        "Estamos processando seu pedido!",
      );
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    } on StripeException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, getStripeMessageByCode(err.error.stripeErrorCode!));
    } on StripeError catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, getStripeMessageByCode(err.code));
    }
  }

  getTokenCartaoStripe() async {
    final cardDetails = CardDetails(
      number: _numeroCartaoController.text,
      expirationMonth: int.parse(_validadeController.text.split("/")[0]),
      expirationYear: int.parse(_validadeController.text.split("/")[1]),
      cvc: _cvvController.text,
    );

    Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);

    BillingDetails billingDetails = BillingDetails(
      email: widget.ingresso.email,
      name: _nomeCompletoController.text,
    );

    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
      ),
    );

    return paymentMethod.id;
  }

  void showMessagePagamento() async {
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
                  color: colorBlue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                comprarIngresso();
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
          if (_validadeController.text.trim().length != 5) {
            Util.showSnackbarError(context, "A validade deve ser composta por mês/ano");
          } else if (_formKey.currentState!.validate()) {
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

  String getStripeMessageByCode(String stripeErrorCode) {
    if (stripeErrorCode == "incorrect_number") {
      return "O número do cartão está incorreto. Verifique o número do cartão ou use um cartão diferente.";
    } else if (stripeErrorCode == "invalid_expiry_month") {
      return "O mês de validade do cartão está incorreto. Verifique a data de validade ou use um cartão diferente.";
    } else if (stripeErrorCode == "invalid_expiry_year") {
      return "O ano de validade do cartão está incorreto. Verifique a data de validade ou use um cartão diferente.";
    } else if (stripeErrorCode == "invalid_cvc") {
      return "O código de segurança do cartão é inválido. Verifique o código de segurança do cartão ou use um cartão diferente.";
    } else {
      return "Erro $stripeErrorCode não mapeado";
    }
  }
}
