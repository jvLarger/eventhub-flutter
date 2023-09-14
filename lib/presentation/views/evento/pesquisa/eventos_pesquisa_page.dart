import 'package:brasil_fields/brasil_fields.dart';
import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/categoria/categoria.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/evento/cadastro/components/selecao_categorias.dart';
import 'package:eventhub/presentation/views/evento/visualizacao/evento_visualizacao_page.dart';
import 'package:eventhub/services/categoria/categoria_service.dart';
import 'package:eventhub/services/evento/evento_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class EventosPesquisaPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const EventosPesquisaPage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<EventosPesquisaPage> createState() => _EventosPesquisaPageState();
}

class _EventosPesquisaPageState extends State<EventosPesquisaPage> {
  bool _isLoading = true;
  bool _isExistisMoreData = false;
  List<Categoria> _listaCategoriasPopulares = [];
  List<Categoria> _listaCategoriasFiltro = [];
  List<Evento> _listaEventos = [];
  final Map<int, Categoria> _mapaCategoriasSelecionadas = {};
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataFiltroController = TextEditingController();
  final TextEditingController _valorInicialFiltroController = TextEditingController();
  final TextEditingController _valorFinalFiltroController = TextEditingController();
  final TextEditingController _categoriasControllerFiltroController = TextEditingController();
  final TextEditingController _raioFiltroController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  double _raio = 50;
  double _valorInicial = 0;
  double _valorFinal = 1000;
  String _data = "";
  Position? _position;

  int _page = 0;

  Future<void> getCoordenadasGeograficas() async {
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

    _position = position;
  }

  Future<void> buscarCategoriasPopulares() async {
    try {
      _listaCategoriasPopulares = await CategoriaService().buscarCategoriasPopulares();
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  buscarEventos() async {
    try {
      _page = 0;
      List<Evento> listaEventosEncontrados = await EventoService().buscarEventos(
        _position!,
        _mapaCategoriasSelecionadas.values.toList(),
        _nomeController.text,
        _raio,
        _data,
        _valorInicial,
        _valorFinal,
        _page,
      );
      _listaEventos = listaEventosEncontrados;
      _page++;
      _isExistisMoreData = listaEventosEncontrados.isNotEmpty && listaEventosEncontrados.length >= 4;
      setState(() {});
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  limparFiltros() {
    _raio = 50;
    _valorInicial = 0;
    _valorFinal = 1000;
    _data = "";
    _mapaCategoriasSelecionadas.clear();
    _listaCategoriasFiltro.clear();
    atualizarControllerCategoriasFiltro();
    setState(() {});
    buscarEventos();
  }

  aplicarFiltrosPesquisa() {
    try {
      double valorInicialFiltro = Util.converterValorRealToDouble(_valorInicialFiltroController.text);
      double valorFinalFiltro = Util.converterValorRealToDouble(_valorFinalFiltroController.text);

      if (valorInicialFiltro > valorFinalFiltro) {
        throw EventHubException("O valor inicial não pode ser superior ao valor final!");
      }

      Navigator.of(context).pop();

      _mapaCategoriasSelecionadas.clear();
      for (Categoria categoria in _listaCategoriasFiltro) {
        _mapaCategoriasSelecionadas.putIfAbsent(categoria.id!, () => categoria);
      }

      _valorInicial = valorInicialFiltro;
      _valorFinal = valorFinalFiltro;
      _raio = Util.converterValorRealToDouble(_raioFiltroController.text);
      _data = _dataFiltroController.text;

      setState(() {});

      buscarEventos();
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  loadFiltrosPesquisa() {
    _listaCategoriasFiltro = _mapaCategoriasSelecionadas.values.toList();
    atualizarControllerCategoriasFiltro();
    _valorInicialFiltroController.text = "R\$ ${Util.formatarReal(_valorInicial)}";
    _valorFinalFiltroController.text = "R\$ ${Util.formatarReal(_valorFinal)}";
    _raioFiltroController.text = _raio.toInt().toString();
    _dataFiltroController.text = _data;
  }

  atualizarControllerCategoriasFiltro() {
    String categorias = "";
    int i = 0;
    for (Categoria categoria in _listaCategoriasFiltro) {
      categorias += categoria.nome!;
      if (i < _listaCategoriasFiltro.length - 1) {
        categorias += ", ";
      }
      i++;
    }

    _categoriasControllerFiltroController.text = categorias;
  }

  buscarConfiguracoesIniciais() async {
    await getCoordenadasGeograficas();
    await buscarCategoriasPopulares();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    limparFiltros();
  }

  @override
  void initState() {
    super.initState();
    buscarConfiguracoesIniciais();
    buscarMaisEventos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        buscarMaisEventos();
      }
    });
  }

  buscarMaisEventos() async {
    try {
      if (_isExistisMoreData) {
        List<Evento> listaEventosEncontrados = await EventoService().buscarEventos(
          _position!,
          _mapaCategoriasSelecionadas.values.toList(),
          _nomeController.text,
          _raio,
          _data,
          _valorInicial,
          _valorFinal,
          _page,
        );
        _listaEventos.addAll(listaEventosEncontrados);
        _page++;
        _isExistisMoreData = listaEventosEncontrados.isNotEmpty && listaEventosEncontrados.length >= 4;
        setState(() {});
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  void removerInteresse(Evento evento, int index) async {
    try {
      Util.showLoading(context);

      await EventoService().removerInteresse(evento.id!);
      _listaEventos[index].demonstreiInteresse = false;
      setState(() {});
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  void demonstrarInteresse(Evento evento, int index) async {
    try {
      Util.showLoading(context);

      await EventoService().demonstrarInteresse(evento.id!);
      _listaEventos[index].demonstreiInteresse = true;
      setState(() {});
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(
                  defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: EventHubTextFormField(
                            label: "Qual tipo de evento você está procurando?",
                            controller: _nomeController,
                            onchange: (String value) {
                              buscarEventos();
                            },
                            prefixIcon: const Icon(
                              Ionicons.search,
                              size: 15,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                openFiltrosPesquisa();
                              },
                              icon: const Icon(
                                Ionicons.funnel_outline,
                                color: colorBlue,
                                size: 15,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    getWidgetCategoriasPopulares(),
                    _listaEventos.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              if (i == _listaEventos.length && _isExistisMoreData) {
                                return const CupertinoActivityIndicator();
                              }

                              if (_listaEventos.length != i) {
                                return getCardEvento(_listaEventos[i], i);
                              } else {
                                return const SizedBox();
                              }
                            },
                            itemCount: _listaEventos.length + 1,
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                height: defaultPadding * 2,
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
                                "Desculpe, não foi possível localizar eventos com o filtro que você informou. Por favor, verifique novamente o conteúdo informado e tente novamente.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
          );
  }

  Widget getCardEvento(Evento evento, int index) {
    return GestureDetector(
      onTap: () {
        Util.goTo(
          context,
          EventoVisualizacaoPage(
            idEvento: evento.id!,
            usuarioAutenticado: widget.usuarioAutenticado,
          ),
        );
      },
      child: Container(
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
                        height: 10,
                      ),
                      Text(
                        evento.dataEHoraFormatada!,
                        style: const TextStyle(
                          fontSize: 14,
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
                                      removerInteresse(evento, index);
                                    },
                                    icon: const Icon(
                                      Ionicons.heart,
                                      color: colorBlue,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      demonstrarInteresse(evento, index);
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openFiltrosPesquisa() {
    loadFiltrosPesquisa();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height / 100 * 90,
          padding: const EdgeInsets.all(defaultPadding),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Filtros',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categorias',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  EventHubTextFormField(
                    label: "Categorias",
                    controller: _categoriasControllerFiltroController,
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return SelecaoCategoria(
                            listaCategoriasSelecionadas: _mapaCategoriasSelecionadas.values.toList(),
                            updateCategoriasSelecionadas: (List<Categoria> listaCategoriasSelecionadas) {
                              _listaCategoriasFiltro = listaCategoriasSelecionadas;
                              atualizarControllerCategoriasFiltro();
                            },
                          );
                        },
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Categorias não informadas!';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(
                      Ionicons.add_circle_outline,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Text(
                    'Preço do Ingresso',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: EventHubTextFormField(
                          label: "Valor Inicial",
                          controller: _valorInicialFiltroController,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: EventHubTextFormField(
                          label: "Valor Final",
                          controller: _valorFinalFiltroController,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Text(
                    'Distância Máxima (Em Km)',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: EventHubTextFormField(
                          label: "Distância em Km",
                          controller: _raioFiltroController,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      const Expanded(
                        child: SizedBox(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  const Text(
                    'Data do Evento',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EventHubTextFormField(
                    label: "Informe a data",
                    prefixIcon: const Icon(
                      Ionicons.calendar,
                      size: 15,
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dataFiltroController.text.isEmpty
                            ? DateTime.now()
                            : DateTime.now().copyWith(
                                day: int.parse(_dataFiltroController.text.split("/")[0]),
                                month: int.parse(_dataFiltroController.text.split("/")[1]),
                                year: int.parse(_dataFiltroController.text.split("/")[2]),
                              ),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now().add(const Duration(days: 1000)),
                      );
                      if (pickedDate != null) {
                        String dataFormatada = DateFormat('dd/MM/yyyy').format(pickedDate);
                        _dataFiltroController.text = dataFormatada;
                      }
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        _dataFiltroController.text = "";
                      },
                      icon: const Icon(
                        Ionicons.trash,
                        size: 15,
                      ),
                    ),
                    controller: _dataFiltroController,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            limparFiltros();
                            Navigator.of(context).pop();
                          },
                          child: const Text("Limpar"),
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            aplicarFiltrosPesquisa();
                          },
                          child: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
              buscarEventos();
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
              itemCount: _listaCategoriasPopulares.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index != _listaCategoriasPopulares.length - 1 ? 15 : 0,
                  ),
                  child: EventHubBadge(
                    color: colorBlue,
                    label: _listaCategoriasPopulares[index].nome!,
                    filled: _mapaCategoriasSelecionadas.containsKey(_listaCategoriasPopulares[index].id),
                    fontSize: 13,
                    onTap: () {
                      if (_mapaCategoriasSelecionadas.containsKey(_listaCategoriasPopulares[index].id)) {
                        _mapaCategoriasSelecionadas.remove(_listaCategoriasPopulares[index].id);
                      } else {
                        _mapaCategoriasSelecionadas.putIfAbsent(_listaCategoriasPopulares[index].id!, () => _listaCategoriasPopulares[index]);
                      }
                      setState(() {});
                      buscarEventos();
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
