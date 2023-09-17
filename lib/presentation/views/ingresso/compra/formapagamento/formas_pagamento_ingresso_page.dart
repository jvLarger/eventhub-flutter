import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/ingresso/compra/cartao/pagamento_cartao_ingresso_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class FormasPagamentoIngressoPage extends StatefulWidget {
  final Ingresso ingresso;
  final UsuarioAutenticado usuarioAutenticado;
  const FormasPagamentoIngressoPage({
    super.key,
    required this.ingresso,
    required this.usuarioAutenticado,
  });

  @override
  State<FormasPagamentoIngressoPage> createState() => _FormasPagamentoIngressoPageState();
}

class _FormasPagamentoIngressoPageState extends State<FormasPagamentoIngressoPage> {
  String formaPagamento = "CC";
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Forma de Pagamento",
      ),
      bottomNavigationBar: EventHubBottomButton(
        label: "Continuar - R\$ ${Util.formatarReal(widget.ingresso.evento!.valor)}",
        onTap: () {
          Util.goTo(
            context,
            PagamentoCartaoIngressoPage(
              ingresso: widget.ingresso,
              usuarioAutenticado: widget.usuarioAutenticado,
            ),
          );
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selecione o método de pagamento desejado"),
            const SizedBox(
              height: defaultPadding,
            ),
            GestureDetector(
              onTap: () {
                setState(
                  () {
                    formaPagamento = "CC";
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: defaultPadding),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 60.0,
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(
                        0,
                        4,
                      ),
                      spreadRadius: 4,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Cartão de Crédito",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                        fontSize: 16,
                      ),
                    ),
                    Radio(
                      value: "CC",
                      activeColor: colorBlue,
                      groupValue: formaPagamento,
                      onChanged: (value) {
                        setState(
                          () {
                            formaPagamento = value!;
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
