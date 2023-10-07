import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/views/evento/visualizacao/evento_visualizacao_page.dart';
import 'package:eventhub/presentation/views/ingresso/visualizacao/visualizacao_ingresso_page.dart';
import 'package:eventhub/services/ingresso/ingresso_service.dart';
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
  bool _isLoading = true;
  List<Ingresso> _listaIngressosPendentes = [];
  List<Ingresso> _listaIngressosConcluidos = [];

  TabController? _tabController;
  int _indexTabAtiva = 0;

  buscarIngressos() async {
    try {
      _listaIngressosPendentes = await IngressoSevice().buscarMeusIngressosPendentes();
      _listaIngressosConcluidos = await IngressoSevice().buscarMeusIngressosConcluidos();
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
    buscarIngressos();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : EventHubBody(
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
    return _listaIngressosConcluidos.isEmpty
        ? Column(
            children: [
              const SizedBox(
                height: defaultPadding,
              ),
              SvgPicture.asset(
                "assets/images/empty.svg",
                width: 250,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text(
                "Nada Encontrado",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Você ainda não possui registros a serem exibidos aqui.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _listaIngressosConcluidos.length,
            itemBuilder: (context, index) {
              return getCardConcluido(_listaIngressosConcluidos[index]);
            },
          );
  }

  Widget montarListaPendentes() {
    return _listaIngressosPendentes.isEmpty
        ? Column(
            children: [
              const SizedBox(
                height: defaultPadding,
              ),
              SvgPicture.asset(
                "assets/images/empty.svg",
                width: 250,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text(
                "Nada Encontrado",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Você ainda não possui registros a serem exibidos aqui.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _listaIngressosPendentes.length,
            itemBuilder: (context, index) {
              return getCardPendente(_listaIngressosPendentes[index]);
            },
          );
  }

  Widget getCardPendente(Ingresso ingresso) {
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
                child: GestureDetector(
                  onTap: () {
                    Util.goTo(
                      context,
                      EventoVisualizacaoPage(
                        idEvento: ingresso.evento!.id!,
                        isGoBackDefault: true,
                        usuarioAutenticado: widget.usuarioAutenticado,
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      Util.montarURlFotoByArquivo(ingresso.evento!.arquivos![0].arquivo),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
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
                          child: Text(
                            ingresso.evento!.nome!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
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
                    Text(
                      ingresso.evento!.dataEHoraFormatada!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: colorBlue,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      ingresso.nome!,
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
                                  "${ingresso.evento!.bairro!}, ${ingresso.evento!.cidade!} / ${ingresso.evento!.estado!}",
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onPressed: () {
                    Util.goTo(
                      context,
                      VisualizacaoIngressoPage(
                        ingresso: ingresso,
                      ),
                    );
                  },
                  child: const Text("Ver Ingresso"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getCardConcluido(Ingresso ingresso) {
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
                    Util.montarURlFotoByArquivo(ingresso.evento!.arquivos![0].arquivo),
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
                            ingresso.evento!.nome!,
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
                      ingresso.evento!.dataEHoraFormatada!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: colorBlue,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      ingresso.nome!,
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
                                  "${ingresso.evento!.bairro!}, ${ingresso.evento!.cidade!} / ${ingresso.evento!.estado!}",
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onPressed: () {
                    Util.goTo(
                      context,
                      VisualizacaoIngressoPage(
                        ingresso: ingresso,
                      ),
                    );
                  },
                  child: const Text("Ver Ingresso"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
