import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EventoIndicadoresPage extends StatefulWidget {
  const EventoIndicadoresPage({super.key});

  @override
  State<EventoIndicadoresPage> createState() => _EventoIndicadoresPageState();
}

class _EventoIndicadoresPageState extends State<EventoIndicadoresPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Indicadores",
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              iconColor: const Color.fromRGBO(33, 33, 33, 1),
              leading: const Icon(Ionicons.people_outline),
              trailing: const Icon(Ionicons.chevron_forward),
              title: const Text(
                "Lista de Participantes (44)",
                style: TextStyle(
                  color: Color.fromRGBO(33, 33, 33, 1),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: defaultPadding * 2,
            ),
            const Text(
              "R\$ 4587,23",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Faturamento",
              style: TextStyle(
                color: Color.fromRGBO(97, 97, 97, 1),
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
