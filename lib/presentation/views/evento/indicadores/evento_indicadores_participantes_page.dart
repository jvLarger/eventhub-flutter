import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/ingresso/validacao/validacao_ingresso_page.dart';
import 'package:eventhub/presentation/views/qrcode/qrcode_scanner_page.dart';
import 'package:eventhub/services/evento/evento_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EventoIndicadoresParticipantesPage extends StatefulWidget {
  final int idEvento;
  const EventoIndicadoresParticipantesPage({
    super.key,
    required this.idEvento,
  });

  @override
  State<EventoIndicadoresParticipantesPage> createState() => _EventoIndicadoresParticipantesPageState();
}

class _EventoIndicadoresParticipantesPageState extends State<EventoIndicadoresParticipantesPage> {
  bool _isLoding = true;
  List<Ingresso> _listaIngressoBkp = [];
  List<Ingresso> _listaIngresso = [];

  filtrarIngressos(String nome) {
    List<Ingresso> listaIngressoFiltrado = [];

    for (Ingresso ingresso in _listaIngressoBkp) {
      if (ingresso.nome!.toLowerCase().contains(nome.toLowerCase())) {
        listaIngressoFiltrado.add(ingresso);
      }
    }

    setState(() {
      _listaIngresso = listaIngressoFiltrado;
    });
  }

  buscarIngressosVendidosEvento() async {
    try {
      _listaIngressoBkp = await EventoService().buscarIngressosVendidosEvento(widget.idEvento);
      _listaIngresso.addAll(_listaIngressoBkp);
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
    buscarIngressosVendidosEvento();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoding
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : EventHubBody(
            topWidget: EventHubTopAppbar(
              title: "Lista de Participantes",
              actions: [
                IconButton(
                  onPressed: () {
                    Util.goTo(
                      context,
                      const QrCodeLeituraPage(),
                    );
                  },
                  icon: const Icon(Icons.qr_code),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  EventHubTextFormField(
                    label: "Pesquise pelo nome",
                    onchange: (nome) {
                      filtrarIngressos(nome);
                    },
                    prefixIcon: const Icon(
                      Ionicons.search,
                      size: 15,
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _listaIngresso.length,
                    itemBuilder: (context, index) {
                      return getParticipante(_listaIngresso[index]);
                    },
                  ),
                ],
              ),
            ),
          );
  }

  getParticipante(Ingresso ingresso) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 0,
        right: 0,
        bottom: 5,
        top: 5,
      ),
      leading: const SizedBox(
        height: double.infinity,
        child: Icon(
          Ionicons.ticket_outline,
        ),
      ),
      title: Text(
        ingresso.nome!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ingresso.documentoPrincipal != null
              ? ingresso.documentoPrincipal!.length == 11
                  ? Util.aplicarMascara(ingresso.documentoPrincipal!, "###.###.###-##")
                  : Util.aplicarMascara(ingresso.documentoPrincipal!, "##.###.###/####-##")
              : ""),
          ingresso.dataUtilizacao != null
              ? const Text(
                  "Ingresso já utilizado",
                  style: TextStyle(
                    color: Color.fromRGBO(7, 189, 116, 1),
                  ),
                )
              : const Text(
                  "Ainda não utilizado",
                  style: TextStyle(
                    color: Color.fromRGBO(247, 85, 85, 1),
                  ),
                )
        ],
      ),
      trailing: SizedBox(
        child: ingresso.dataUtilizacao != null
            ? Text(
                "R\$ ${Util.formatarReal(ingresso.valorFaturamento)}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: colorBlue,
                  fontWeight: FontWeight.bold,
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  Util.goTo(
                    context,
                    ValidacaoIngressoPage(
                      identificadorIngresso: ingresso.identificadorIngresso!,
                      isGoBackDefault: true,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                ),
                child: const Text("Validar"),
              ),
      ),
    );
  }
}
