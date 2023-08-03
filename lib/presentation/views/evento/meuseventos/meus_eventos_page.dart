import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class MeusEventosPage extends StatefulWidget {
  const MeusEventosPage({super.key});

  @override
  State<MeusEventosPage> createState() => _MeusEventosPageState();
}

class _MeusEventosPageState extends State<MeusEventosPage> with TickerProviderStateMixin {
  TabController? _tabController;
  int _indexTabAtiva = 0;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Meus Eventos",
      ),
      bottomNavigationBar: EventHubBottomButton(
        label: "Novo Evento",
        onTap: () {},
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: colorBlue,
              labelStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'Urbanist',
              ),
              onTap: (value) {
                _indexTabAtiva = value;
                setState(() {});
              },
              tabs: const [
                Tab(
                  text: 'Pendentes',
                ),
                Tab(
                  text: 'Concluídos',
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 28,
              ),
              child: _indexTabAtiva == 0 ? montarListaPendentes() : montarListaConcluidos(),
            )
          ],
        ),
      ),
    );
  }

  Widget montarListaConcluidos() {
    return Column(
      children: [],
    );
  }

  Widget montarListaPendentes() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
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
              const Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DJ & Music Concert",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Qui, Dez 30 • 18.00 - 22.00",
                      style: TextStyle(
                        fontSize: 14,
                        color: colorBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
