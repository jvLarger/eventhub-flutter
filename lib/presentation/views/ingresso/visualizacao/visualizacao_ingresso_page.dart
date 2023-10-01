import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class VisualizacaoIngressoPage extends StatefulWidget {
  final Ingresso ingresso;
  const VisualizacaoIngressoPage({
    super.key,
    required this.ingresso,
  });

  @override
  State<VisualizacaoIngressoPage> createState() => _VisualizacaoIngressoPageState();
}

class _VisualizacaoIngressoPageState extends State<VisualizacaoIngressoPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Ingresso",
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/QR_Code_Example.svg/1200px-QR_Code_Example.svg.png",
              height: 250,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              width: double.maxFinite,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pessoa",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.ingresso.nome!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Text(
                    "Evento",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.ingresso.evento!.nome!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Text(
                    "Data e Hora",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.ingresso.evento!.dataEHoraFormatada!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Text(
                    "Localização",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${widget.ingresso.evento!.logradouro!} ${widget.ingresso.evento!.numero!} ${widget.ingresso.evento!.complemento != null ? "( ${widget.ingresso.evento!.complemento} )" : ""} - ${widget.ingresso.evento!.bairro!} - ${widget.ingresso.evento!.cidade!} / ${widget.ingresso.evento!.estado!}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Text(
                    "Organizador",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.ingresso.evento!.usuario!.nomeCompleto!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
