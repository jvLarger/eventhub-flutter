import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/categoria/categoria.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/evento/evento_categoria.dart';
import 'package:eventhub/model/evento/feed_evento.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/components/informacoes_usuario.dart';
import 'package:eventhub/presentation/views/evento/mapacalor/mapa_calor_page.dart';
import 'package:eventhub/presentation/views/evento/pesquisa/eventos_pesquisa_page.dart';
import 'package:eventhub/presentation/views/evento/visualizacao/evento_visualizacao_page.dart';
import 'package:eventhub/services/evento/evento_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/singleton.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';

class EventosDestaquePage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const EventosDestaquePage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<EventosDestaquePage> createState() => _EventosDestaquePageState();
}

class _EventosDestaquePageState extends State<EventosDestaquePage> {
  Position? _position;
  bool _isLoading = true;
  FeedEvento _feedEvento = FeedEvento();
  final Map<int, Categoria> _mapaCategoriasSelecionadas = {};
  List<Categoria> _listaCategoria = [];
  List<Evento> _listaEventosPopularesFiltrados = [];

  refreshEVentosPopularesPorCategoriasSelecionadas() {
    List<Evento> listaEventosPopulares = [];

    for (Evento evento in _feedEvento.eventosPopulares!) {
      if (_mapaCategoriasSelecionadas.isEmpty) {
        listaEventosPopulares.add(evento);
      } else {
        for (EventoCategoria eventoCategoria in evento.categorias!) {
          if (_mapaCategoriasSelecionadas.containsKey(eventoCategoria.categoria!.id)) {
            listaEventosPopulares.add(evento);
            break;
          }
        }
      }
    }

    setState(() {
      _listaEventosPopularesFiltrados = listaEventosPopulares;
    });
  }

  getCoordenadasGeograficas() async {
    if (EventhubSingleton().getPositionUsuario() == null) {
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition();

      EventhubSingleton().setPositionUsuario(position);
    }

    _position = EventhubSingleton().getPositionUsuario();
  }

  buscarConfiguracoesIniciais() async {
    await getCoordenadasGeograficas();

    try {
      _feedEvento = await EventoService().buscarFeedEventos(_position!.latitude, _position!.longitude);

      _listaCategoria = getCategoriasDosMaisPopulares();
      _listaEventosPopularesFiltrados = _feedEvento.eventosPopulares!;
      setState(() {
        _isLoading = false;
      });
    } on EventHubException catch (err) {
      // ignore: use_build_context_synchronously
      Util.showSnackbarError(context, err.cause);
    }
  }

  List<Categoria> getCategoriasDosMaisPopulares() {
    Map<int, Categoria> mapaCategorias = {};

    for (Evento evento in _feedEvento.eventosPopulares!) {
      for (EventoCategoria eventoCategoria in evento.categorias!) {
        mapaCategorias.putIfAbsent(eventoCategoria.categoria!.id!, () => eventoCategoria.categoria!);
      }
    }

    return mapaCategorias.values.toList();
  }

  @override
  void initState() {
    super.initState();
    buscarConfiguracoesIniciais();
  }

  void removerInteresse(Evento evento, int index, bool isListaMeusAmigosGostaram) async {
    try {
      Util.showLoading(context);

      await EventoService().removerInteresse(evento.id!);
      if (isListaMeusAmigosGostaram) {
        _feedEvento.eventosQueMeusAmigosGostaram![index].demonstreiInteresse = false;
        setState(() {});
      } else {
        int indexPopulares = getIndexPopularesPorIndexListaFiltrada(index);
        _feedEvento.eventosPopulares![indexPopulares].demonstreiInteresse = false;
        setState(() {});
        refreshEVentosPopularesPorCategoriasSelecionadas();
      }
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  void demonstrarInteresse(Evento evento, int index, bool isListaMeusAmigosGostaram) async {
    try {
      Util.showLoading(context);

      await EventoService().demonstrarInteresse(evento.id!);

      if (isListaMeusAmigosGostaram) {
        _feedEvento.eventosQueMeusAmigosGostaram![index].demonstreiInteresse = true;
        setState(() {});
      } else {
        int indexPopulares = getIndexPopularesPorIndexListaFiltrada(index);
        _feedEvento.eventosPopulares![indexPopulares].demonstreiInteresse = true;
        setState(() {});
        refreshEVentosPopularesPorCategoriasSelecionadas();
      }
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  int getIndexPopularesPorIndexListaFiltrada(int index) {
    Evento eventoMarcado = _listaEventosPopularesFiltrados[index];
    int indexPopulares = 0;
    int i = 0;
    for (Evento evento in _feedEvento.eventosPopulares!) {
      if (evento.id == eventoMarcado.id) {
        indexPopulares = i;
        break;
      }
      i++;
    }
    return indexPopulares;
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
              indexRecursoAtivo: 0,
              usuarioAutenticado: widget.usuarioAutenticado,
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InformacoesUsuario(
                    usuarioAutenticado: widget.usuarioAutenticado,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    readOnly: true,
                    onTap: () {
                      Util.goTo(
                        context,
                        EventosPesquisaPage(
                          usuarioAutenticado: widget.usuarioAutenticado,
                        ),
                      );
                    },
                    label: "Qual tipo de evento você está procurando?",
                    prefixIcon: const Icon(
                      Ionicons.search,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Meus amigos gostaram",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Util.goTo(
                            context,
                            MapaCalorPage(
                              usuarioAutenticado: widget.usuarioAutenticado,
                            ),
                          );
                        },
                        child: const Text(
                          "Mapa de Calor",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: colorBlue,
                          ),
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: _feedEvento.eventosQueMeusAmigosGostaram!.isNotEmpty,
                    child: const SizedBox(
                      height: defaultPadding / 2,
                    ),
                  ),
                  Visibility(
                    visible: _feedEvento.eventosQueMeusAmigosGostaram!.isNotEmpty,
                    child: SizedBox(
                      height: 320,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _feedEvento.eventosQueMeusAmigosGostaram!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 15,
                              ),
                              child: getCardEvento(
                                300,
                                _feedEvento.eventosQueMeusAmigosGostaram![index],
                                index,
                                true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _feedEvento.eventosQueMeusAmigosGostaram!.isEmpty,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: defaultPadding * 2,
                        ),
                        SvgPicture.asset(
                          "assets/images/empty.svg",
                          width: 150,
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Text(
                          "Nada Encontrado",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Desculpe, não foi possível localizar eventos que seus amigos tenham demonstrado interesse.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Eventos Populares",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Visibility(
                    visible: _feedEvento.eventosPopulares!.isNotEmpty,
                    child: getWidgetCategoriasPopulares(),
                  ),
                  Visibility(
                    visible: _feedEvento.eventosPopulares!.isNotEmpty,
                    child: const SizedBox(
                      height: defaultPadding / 2,
                    ),
                  ),
                  Visibility(
                    visible: _feedEvento.eventosPopulares!.isNotEmpty,
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: _listaEventosPopularesFiltrados.length,
                          itemBuilder: (context, index) {
                            return index % 2 == 0
                                ? Row(
                                    children: [
                                      getCardEvento(
                                        (MediaQuery.of(context).size.width - (2 * defaultPadding) - 15) / 2,
                                        _listaEventosPopularesFiltrados[index],
                                        index,
                                        false,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      (index + 1 <= _listaEventosPopularesFiltrados.length - 1
                                          ? getCardEvento(
                                              (MediaQuery.of(context).size.width - (2 * defaultPadding) - 15) / 2,
                                              _listaEventosPopularesFiltrados[index + 1],
                                              index + 1,
                                              false,
                                            )
                                          : const SizedBox()),
                                    ],
                                  )
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _feedEvento.eventosPopulares!.isEmpty,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: defaultPadding * 2,
                        ),
                        SvgPicture.asset(
                          "assets/images/empty.svg",
                          width: 150,
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const Text(
                          "Nada Encontrado",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Desculpe, não foi possível localizar eventos próximos a você.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget getCardEvento(double? width, Evento evento, int index, bool isListaMeusAmigosGostaram) {
    return GestureDetector(
      onTap: () {
        Util.goTo(
          context,
          EventoVisualizacaoPage(
            idEvento: evento.id!,
            usuarioAutenticado: widget.usuarioAutenticado,
            isGoBackDefault: true,
          ),
        );
      },
      child: Container(
        width: width ?? double.maxFinite,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 60.0,
              color: Colors.black.withOpacity(0.01),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                Util.montarURlFotoByArquivo(evento.arquivos![0].arquivo),
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: 160,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              evento.nome!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              evento.dataEHoraFormatada!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: colorBlue,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
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
                          style: TextStyle(
                            fontSize: width == null ? 12 : 15,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: evento.demonstreiInteresse!
                      ? IconButton(
                          onPressed: () {
                            removerInteresse(evento, index, isListaMeusAmigosGostaram);
                          },
                          icon: const Icon(
                            Ionicons.heart,
                            color: colorBlue,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            demonstrarInteresse(evento, index, isListaMeusAmigosGostaram);
                          },
                          icon: const Icon(
                            Ionicons.heart_outline,
                            color: colorBlue,
                          ),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getWidgetCategoriasPopulares() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          EventHubBadge(
            color: colorBlue,
            label: "Todas Categorias",
            fontSize: 13,
            filled: _mapaCategoriasSelecionadas.isEmpty,
            onTap: () {
              _mapaCategoriasSelecionadas.clear();
              setState(() {});
              refreshEVentosPopularesPorCategoriasSelecionadas();
            },
          ),
          const SizedBox(
            width: 15,
          ),
          SizedBox(
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _listaCategoria.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index != _listaCategoria.length - 1 ? 15 : 0,
                  ),
                  child: EventHubBadge(
                    color: colorBlue,
                    label: _listaCategoria[index].nome!,
                    filled: _mapaCategoriasSelecionadas.containsKey(_listaCategoria[index].id),
                    fontSize: 13,
                    onTap: () {
                      if (_mapaCategoriasSelecionadas.containsKey(_listaCategoria[index].id)) {
                        _mapaCategoriasSelecionadas.remove(_listaCategoria[index].id);
                      } else {
                        _mapaCategoriasSelecionadas.putIfAbsent(_listaCategoria[index].id!, () => _listaCategoria[index]);
                      }
                      setState(() {});
                      refreshEVentosPopularesPorCategoriasSelecionadas();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
