import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/views/ingresso/visualizacao/visualizacao_ingresso_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class MeusIngressosPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const MeusIngressosPage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<MeusIngressosPage> createState() => _MeusIngressosPageState();
}

class _MeusIngressosPageState extends State<MeusIngressosPage> with TickerProviderStateMixin {
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
      bottomNavigationBar: EventHubBottomBar(
        indexRecursoAtivo: 3,
        usuarioAutenticado: widget.usuarioAutenticado,
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/logo_eventhub.svg",
                  width: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Ingressos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: defaultPadding,
            ),
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
              padding: const EdgeInsets.only(
                top: 28,
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
      children: [
        getCardConcluido(),
        getCardConcluido(),
        getCardConcluido(),
      ],
    );
  }

  Widget montarListaPendentes() {
    return Column(
      children: [
        getCardPendente(),
        getCardPendente(),
        getCardPendente(),
      ],
    );
  }

  Widget getCardPendente() {
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
                            child: Text(
                              "DJ & Music Concert Concert Concert",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 5,
                            child: EventHubBadge(
                              label: "Pendente",
                              color: colorBlue,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onPressed: () {
                      Util.goTo(
                        context,
                        VisualizacaoIngressoPage(),
                      );
                    },
                    child: Text("Ver Ingresso"),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget getCardConcluido() {
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
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: EventHubBadge(
                            label: "Concluído",
                            color: Colors.green,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onPressed: () {
                    Util.goTo(context, VisualizacaoIngressoPage());
                  },
                  child: Text("Ver Ingresso"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
