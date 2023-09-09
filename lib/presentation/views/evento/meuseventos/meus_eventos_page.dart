import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/evento/cadastro/evento_cadastro_page.dart';
import 'package:eventhub/presentation/views/evento/indicadores/evento_indicadores_page.dart';
import 'package:eventhub/services/evento/evento_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class MeusEventosPage extends StatefulWidget {
  const MeusEventosPage({super.key});

  @override
  State<MeusEventosPage> createState() => _MeusEventosPageState();
}

class _MeusEventosPageState extends State<MeusEventosPage> with TickerProviderStateMixin {
  TabController? _tabController;
  int _indexTabAtiva = 0;
  bool _isLoading = true;
  List<Evento> _listaEventosPendentes = [];
  List<Evento> _listaEventosConcluidos = [];

  buscarMeusEventos() async {
    try {
      _listaEventosPendentes = await EventoService().buscarMeusEventosPendentes();
      _listaEventosConcluidos = await EventoService().buscarMeusEventosConcluidos();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
    buscarMeusEventos();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : EventHubBody(
            topWidget: const EventHubTopAppbar(
              title: "Meus Eventos",
            ),
            bottomNavigationBar: EventHubBottomButton(
              label: "Novo Evento",
              onTap: () {
                Util.goTo(
                  context,
                  const EventoCadastroPage(),
                );
              },
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: defaultPadding,
                right: defaultPadding,
                left: defaultPadding,
              ),
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
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: _listaEventosConcluidos.length,
      itemBuilder: (context, index) {
        return getCardConcluido(_listaEventosConcluidos[index]);
      },
    );
  }

  Widget montarListaPendentes() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: _listaEventosPendentes.length,
      itemBuilder: (context, index) {
        return getCardPendente(_listaEventosPendentes[index]);
      },
    );
  }

  getCardPendente(Evento evento) {
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
                      Util.montarURlFotoByArquivo(evento.arquivos![0].arquivo),
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
                              evento.nome!,
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
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              child: const Icon(
                                Icons.send_outlined,
                                size: 18,
                                color: colorBlue,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        evento.dataEHoraFormatada!,
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
                                    "${evento.bairro!}, ${evento.cidade!} / ${evento.estado!}",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
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
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onPressed: () {
                      Util.goTo(
                        context,
                        EventoIndicadoresPage(
                          idEvento: evento.id!,
                        ),
                      );
                    },
                    child: const Text("Ver indicadores"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onPressed: () {
                      Util.goTo(
                        context,
                        EventoCadastroPage(
                          evento: evento,
                        ),
                      );
                    },
                    child: const Text("Alterar"),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  getCardConcluido(Evento evento) {
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
                      Util.montarURlFotoByArquivo(evento.arquivos![0].arquivo),
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
                              evento.nome!,
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
                        evento.dataEHoraFormatada!,
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
                                    "${evento.bairro!}, ${evento.cidade!} / ${evento.estado!}",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
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
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onPressed: () {
                      Util.goTo(
                        context,
                        EventoIndicadoresPage(
                          idEvento: evento.id!,
                        ),
                      );
                    },
                    child: const Text("Ver indicadores"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ));
  }
}
