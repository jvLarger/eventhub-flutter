import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/evento/indicadores/evento_indicadores_participantes_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
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
            getCardHeader(),
            ListTile(
              onTap: () {
                Util.goTo(
                  context,
                  EventoIndicadoresParticipantesPage(),
                );
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              iconColor: const Color.fromRGBO(33, 33, 33, 1),
              leading: const Icon(Ionicons.people_outline),
              trailing: const Icon(Ionicons.chevron_forward),
              title: const Text(
                "Lista de Participantes (44)",
                style: TextStyle(
                  color: Color.fromRGBO(33, 33, 33, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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

  Widget getCardHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: defaultPadding),
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
                    "https://images.unsplash.com/photo-1565035010268-a3816f98589a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=388&q=80",
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
                        const Expanded(
                          flex: 8,
                          child: Text(
                            "DJ & Music Concert Concert Concert",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
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
                    const Text(
                      "Qui, Dez 30 • 18.00 - 22.00",
                      style: TextStyle(
                        fontSize: 14,
                        color: colorBlue,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Row(
                            children: [
                              Icon(
                                Ionicons.map_outline,
                                color: colorBlue,
                                size: 14,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "Centro, Caxias do Sul RS",
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
