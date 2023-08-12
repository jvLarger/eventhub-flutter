import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class EventosPesquisaPage extends StatefulWidget {
  const EventosPesquisaPage({super.key});

  @override
  State<EventosPesquisaPage> createState() => _EventosPesquisaPageState();
}

class _EventosPesquisaPageState extends State<EventosPesquisaPage> {
  final TextEditingController _dataEventoController = TextEditingController();
  RangeValues _currentRangeValues = RangeValues(40, 80);
  RangeValues _currentRangeValues2 = RangeValues(10, 30);

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      child: Padding(
        padding: EdgeInsets.all(
          defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: EventHubTextFormField(
                    label: "Qual tipo de evento você está procurando?",
                    prefixIcon: Icon(
                      Ionicons.search,
                      size: 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        openFiltrosPesquisa();
                      },
                      icon: Icon(
                        Ionicons.funnel_outline,
                        color: colorBlue,
                        size: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: defaultPadding,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  EventHubBadge(
                    color: colorBlue,
                    label: "Todas Categorias",
                    fontSize: 13,
                    filled: true,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  EventHubBadge(
                    color: colorBlue,
                    label: "Músicas",
                    fontSize: 13,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  EventHubBadge(
                    color: colorBlue,
                    label: "Fantasia",
                    fontSize: 13,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  EventHubBadge(
                    color: colorBlue,
                    label: "Negócios",
                    fontSize: 13,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  EventHubBadge(
                    color: colorBlue,
                    label: "Pijama",
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              "5 encontrados",
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
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              Divider(),
              SizedBox(
                height: defaultPadding / 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categorias',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Ver Todas",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    EventHubBadge(
                      color: colorBlue,
                      label: "Todas Categorias",
                      fontSize: 13,
                      filled: true,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    EventHubBadge(
                      color: colorBlue,
                      label: "Músicas",
                      fontSize: 13,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    EventHubBadge(
                      color: colorBlue,
                      label: "Fantasia",
                      fontSize: 13,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    EventHubBadge(
                      color: colorBlue,
                      label: "Negócios",
                      fontSize: 13,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    EventHubBadge(
                      color: colorBlue,
                      label: "Pijama",
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              const Text(
                'Preço do Ingresso',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RangeSlider(
                values: _currentRangeValues2,
                max: 100,
                divisions: 100,
                labels: RangeLabels(
                  _currentRangeValues2.start.round().toString(),
                  _currentRangeValues2.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues2 = values;
                  });
                },
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              const Text(
                'Distância',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RangeSlider(
                values: _currentRangeValues,
                max: 100,
                divisions: 100,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
              SizedBox(
                height: defaultPadding / 2,
              ),
              const Text(
                'Data do Evento',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
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
                    initialDate: _dataEventoController.text.isEmpty
                        ? DateTime.now()
                        : DateTime.now().copyWith(
                            day: int.parse(_dataEventoController.text.split("/")[0]),
                            month: int.parse(_dataEventoController.text.split("/")[1]),
                            year: int.parse(_dataEventoController.text.split("/")[2]),
                          ),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    String dataFormatada = DateFormat('dd/MM/yyyy').format(pickedDate);
                    _dataEventoController.text = dataFormatada;
                  }
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    _dataEventoController.text = "";
                  },
                  icon: const Icon(
                    Ionicons.trash,
                    size: 15,
                  ),
                ),
                controller: _dataEventoController,
              ),
              SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Limpar"),
                    ),
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
