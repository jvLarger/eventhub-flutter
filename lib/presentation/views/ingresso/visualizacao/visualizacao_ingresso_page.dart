import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class VisualizacaoIngressoPage extends StatefulWidget {
  const VisualizacaoIngressoPage({super.key});

  @override
  State<VisualizacaoIngressoPage> createState() => _VisualizacaoIngressoPageState();
}

class _VisualizacaoIngressoPageState extends State<VisualizacaoIngressoPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: EventHubTopAppbar(
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
            SizedBox(
              height: defaultPadding,
            ),
            Container(
              padding: EdgeInsets.all(defaultPadding),
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
                  Text(
                    "Evento",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "DJ & Music Concert",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    "Data e Hora",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "24/12/2023 • 18.00 - 23.00",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    "Localização",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Centro 789, Caxias do Sul",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    "Organizador",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Mundo da Música",
                    style: TextStyle(
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
