import 'package:brasil_fields/brasil_fields.dart';
import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/categoria/categoria.dart';
import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/evento/cadastro/components/selecao_categorias.dart';
import 'package:eventhub/presentation/views/evento/visualizacao/evento_visualizacao_page.dart';
import 'package:eventhub/services/categoria/categoria_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class EventosPesquisaPage extends StatefulWidget {
  const EventosPesquisaPage({super.key});

  @override
  State<EventosPesquisaPage> createState() => _EventosPesquisaPageState();
}

class _EventosPesquisaPageState extends State<EventosPesquisaPage> {
  bool _isLoading = true;
  List<Categoria> _listaCategoriasPopulares = [];
  List<Categoria> _listaCategoriasFiltro = [];
  Map<int, Categoria> _mapaCategoriasSelecionadas = Map();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _valorInicialFiltroController = TextEditingController();
  final TextEditingController _valorFinalFiltroController = TextEditingController();
  final TextEditingController _categoriasControllerFiltroController = TextEditingController();
  final TextEditingController _raioFiltroController = TextEditingController();

  Position? _position;

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

  buscarEventos() {}

  buscarMaisEventos() {}

  limparFiltros() {
    atualizarControllerCategoriasFiltro();
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

      setState(() {});
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  loadFiltrosPesquisa() {
    _listaCategoriasFiltro = _mapaCategoriasSelecionadas.values.toList();
    atualizarControllerCategoriasFiltro();
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
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    "5 Encontrados",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  getCardEvento(),
                  getCardEvento(),
                  getCardEvento(),
                  getCardEvento(),
                  getCardEvento(),
                ],
              ),
            ),
          );
  }

  Widget getCardEvento() {
    return GestureDetector(
      onTap: () {
        Util.goTo(context, EventoVisualizacaoPage());
      },
      child: Container(
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
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
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
                            flex: 2,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
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
                        initialDate: _dataController.text.isEmpty
                            ? DateTime.now()
                            : DateTime.now().copyWith(
                                day: int.parse(_dataController.text.split("/")[0]),
                                month: int.parse(_dataController.text.split("/")[1]),
                                year: int.parse(_dataController.text.split("/")[2]),
                              ),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        String dataFormatada = DateFormat('dd/MM/yyyy').format(pickedDate);
                        _dataController.text = dataFormatada;
                      }
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        _dataController.text = "";
                      },
                      icon: const Icon(
                        Ionicons.trash,
                        size: 15,
                      ),
                    ),
                    controller: _dataController,
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
                          child: Text("Limpar"),
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
