import 'package:eventhub/model/faturamento/faturamento.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/evento/indicadores/evento_indicadores_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListagemFaturamentosPage extends StatefulWidget {
  final String tituloPage;
  final List<Faturamento> faturamentos;
  const ListagemFaturamentosPage({
    super.key,
    required this.faturamentos,
    required this.tituloPage,
  });

  @override
  State<ListagemFaturamentosPage> createState() => _ListagemFaturamentosPageState();
}

class _ListagemFaturamentosPageState extends State<ListagemFaturamentosPage> {
  bool _isLoading = true;
  double _valorTotal = 0.0;

  void totalizarLista() {
    for (Faturamento faturamento in widget.faturamentos) {
      _valorTotal += faturamento.valorTotalFaturamento!;
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    totalizarLista();
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
            topWidget: EventHubTopAppbar(
              title: widget.tituloPage,
            ),
            child: Column(
              children: [
                widget.faturamentos.isEmpty
                    ? Column(
                        children: [
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          SvgPicture.asset(
                            "assets/images/empty.svg",
                            width: 250,
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          const Text(
                            "Nada Encontrado",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Você ainda não possui registros a serem exibidos aqui.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Text(
                            "R\$ ${Util.formatarReal(_valorTotal)}",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.tituloPage,
                            style: const TextStyle(
                              color: Color.fromRGBO(97, 97, 97, 1),
                              fontSize: 16,
                              letterSpacing: 0.2,
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: widget.faturamentos.length,
                            itemBuilder: (context, index) {
                              return getCardFaturamento(widget.faturamentos[index]);
                            },
                          ),
                        ],
                      )
              ],
            ),
          );
  }

  Widget getCardFaturamento(Faturamento faturamento) {
    return ListTile(
      onTap: () {
        Util.goTo(
          context,
          EventoIndicadoresPage(
            idEvento: faturamento.evento!.id!,
          ),
        );
      },
      contentPadding: const EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faturamento.evento!.nome!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          faturamento.dataPagamento != null
              ? Text(
                  "Pago em ${Util.formatarDataComHora(faturamento.dataPagamento)}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              : Text(
                  "Liberado em ${Util.formatarDataComHora(faturamento.dataLiberacao)}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "R\$ ${Util.formatarReal(faturamento.valorTotalFaturamento)}",
          ),
        ],
      ),
    );
  }
}
