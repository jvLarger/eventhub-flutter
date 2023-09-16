import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/evento/indicadores_evento.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/evento/indicadores/evento_indicadores_participantes_page.dart';
import 'package:eventhub/services/evento/evento_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EventoIndicadoresPage extends StatefulWidget {
  final int idEvento;
  const EventoIndicadoresPage({
    super.key,
    required this.idEvento,
  });

  @override
  State<EventoIndicadoresPage> createState() => _EventoIndicadoresPageState();
}

class _EventoIndicadoresPageState extends State<EventoIndicadoresPage> {
  bool _isLoding = true;
  IndicadoresEvento _indicadoresEvento = IndicadoresEvento();
  buscarIndicadoresEvento() async {
    try {
      _indicadoresEvento = await EventoService().buscarIndicadoresEvento(widget.idEvento);
      if (mounted) {
        setState(() {
          _isLoding = false;
        });
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarIndicadoresEvento();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoding
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : EventHubBody(
            topWidget: const EventHubTopAppbar(
              title: "Indicadores",
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  getCardHeader(),
                  ListTile(
                    onTap: () {
                      Util.goTo(
                        context,
                        EventoIndicadoresParticipantesPage(
                          idEvento: widget.idEvento,
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    iconColor: const Color.fromRGBO(33, 33, 33, 1),
                    leading: const Icon(Ionicons.people_outline),
                    trailing: const Icon(Ionicons.chevron_forward),
                    title: Text(
                      "Lista de Participantes (${_indicadoresEvento.ingressosVendidos})",
                      style: const TextStyle(
                        color: Color.fromRGBO(33, 33, 33, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromRGBO(221, 213, 213, 1),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                          child: Column(
                            children: [
                              Text(
                                "R\$ ${Util.formatarReal(_indicadoresEvento.faturamento!.valorTotalFaturamento!)}",
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Color.fromRGBO(33, 33, 33, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding / 2,
                              ),
                              const Text(
                                "Faturamento",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(97, 97, 97, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 0.5,
                        color: const Color.fromRGBO(221, 213, 213, 1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              _indicadoresEvento.evento!.numeroVisualizacoes.toString(),
                              style: const TextStyle(
                                fontSize: 32,
                                color: Color.fromRGBO(33, 33, 33, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: defaultPadding / 2,
                            ),
                            const Text(
                              "Visualizações",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(97, 97, 97, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromRGBO(221, 213, 213, 1),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    "Foi descontado R\$ ${Util.formatarReal(_indicadoresEvento.faturamento!.valorTotalTaxas!)} em taxas referentes a taxa de utilização do aplicativo dos R\$ ${Util.formatarReal(_indicadoresEvento.faturamento!.valorTotalIngressos!)} obtidos com a venda de ingressos.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget getCardHeader() {
    return Container(
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    Util.montarURlFotoByArquivo(_indicadoresEvento.evento!.arquivos![0].arquivo),
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Text(
                            _indicadoresEvento.evento!.nome!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      _indicadoresEvento.evento!.dataEHoraFormatada!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: colorBlue,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Row(
                            children: [
                              const Icon(
                                Ionicons.map_outline,
                                color: colorBlue,
                                size: 14,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "${_indicadoresEvento.evento!.bairro!}, ${_indicadoresEvento.evento!.cidade!} / ${_indicadoresEvento.evento!.estado!}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
