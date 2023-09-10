import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
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
            topWidget: const EventHubTopAppbar(
              title: "Lista de Participantes",
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
      subtitle: Text(ingresso.documentoPrincipal != null
          ? ingresso.documentoPrincipal!.length == 11
              ? Util.aplicarMascara(ingresso.documentoPrincipal!, "###.###.###-##")
              : Util.aplicarMascara(ingresso.documentoPrincipal!, "##.###.###/####-##")
          : ""),
      trailing: SizedBox(
        child: Text(
          "R\$ ${Util.formatarReal(ingresso.valorFaturamento)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: colorBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
