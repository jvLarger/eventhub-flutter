import 'package:brasil_fields/brasil_fields.dart';
import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/evento/evento_arquivo.dart';
import 'package:eventhub/model/evento/evento_categoria.dart';
import 'package:eventhub/model/viacep/viacep.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/evento/cadastro/components/estados_brasileiros.dart';
import 'package:eventhub/presentation/views/evento/cadastro/components/evento_cadastro_galeria.dart';
import 'package:eventhub/presentation/views/evento/cadastro/components/selecao_categorias.dart';
import 'package:eventhub/services/viacep/viacep_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class EventoCadastroPage extends StatefulWidget {
  final Evento? evento;
  const EventoCadastroPage({
    super.key,
    this.evento,
  });

  @override
  State<EventoCadastroPage> createState() => _EventoCadastroPageState();
}

class _EventoCadastroPageState extends State<EventoCadastroPage> {
  List<EventoArquivo> _listaArquivos = [];
  List<EventoCategoria> _listaCategorias = [];
  bool _isApenasConvidados = false;
  String _estado = "";
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final FocusNode _numeroFocus = FocusNode();
  final FocusNode _logradouroFocus = FocusNode();

  void buscarCep(String cepComPontuacao) async {
    String cep = Util.getSomenteNumeros(cepComPontuacao);

    if (cep.length == 8) {
      try {
        Util.showLoading(context);
        ViaCep viaCep = await ViaCepService().consultarCep(cep);
        // ignore: use_build_context_synchronously
        Util.hideLoading(context);

        if (viaCep.erro != null && viaCep.erro!) {
          _cepController.text = "";
          // ignore: use_build_context_synchronously
          Util.showSnackbarError(context, "CEP inválido!");
        } else {
          _cidadeController.text = viaCep.localidade ?? "";
          _logradouroController.text = viaCep.logradouro ?? "";
          _bairroController.text = viaCep.bairro ?? "";
          _estado = viaCep.uf ?? "RS";
          setState(() {});
          if (_logradouroController.text == "") {
            _logradouroFocus.requestFocus();
          } else {
            _numeroFocus.requestFocus();
          }
        }
      } on EventHubException catch (err) {
        Util.hideLoading(context);
        Util.showSnackbarError(context, err.cause);
      }
    }
  }

  void tratarLoadInformacoesAoAlterarUmEvento() {
    if (widget.evento != null) {}
  }

  @override
  void initState() {
    super.initState();
    tratarLoadInformacoesAoAlterarUmEvento();
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: EventHubTopAppbar(
        title: "Dados do Evento",
        actions: [
          Visibility(
            visible: widget.evento != null,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Ionicons.trash_outline,
                color: colorBlue,
              ),
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  EventHubTextFormField(
                    label: "Nome do Evento",
                    controller: _nomeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: EventHubTextFormField(
                          label: "Data do Evento",
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
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 1000)),
                            );
                            if (pickedDate != null) {
                              String dataFormatada = DateFormat('dd/MM/yyyy').format(pickedDate);
                              _dataController.text = dataFormatada;
                            }
                          },
                          controller: _dataController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Data do Evento não informada!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: EventHubTextFormField(
                          label: "Hora de Início",
                          controller: _horaInicioController,
                          readOnly: true,
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _horaInicioController.text.isEmpty
                                  ? TimeOfDay.now()
                                  : TimeOfDay(
                                      hour: int.parse(_horaInicioController.text.split(":")[0]),
                                      minute: int.parse(_horaInicioController.text.split(":")[1]),
                                    ),
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              },
                            );

                            if (picked != null) {
                              _horaInicioController.text = "${picked.hour}:${picked.minute}";
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hora de Início não informada!';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(
                            Ionicons.time,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Valor do Ingresso",
                    controller: _valorController,
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Valor do Ingresso não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Descrição",
                    controller: _descricaoController,
                    minLines: 4,
                    maxLines: 40,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Descrição não informada!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Categorias",
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
                            listaCategoriasSelecionadas: [],
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
                  EventHubTextFormField(
                    label: "CEP",
                    controller: _cepController,
                    textInputType: TextInputType.number,
                    onchange: (String cep) {
                      buscarCep(cep);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CepInputFormatter(ponto: true),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CEP não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: EventHubTextFormField(
                          label: "Cidade",
                          controller: _cidadeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cidade não informada!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        flex: 3,
                        child: DropdownEstadosBrasileiros(
                          callbackSelectUf: (String estado) {
                            _estado = estado;
                            setState(() {});
                          },
                          value: _estado,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Logradouro (Ex: Av Pinheiro Machado)",
                    controller: _logradouroController,
                    focusNode: _logradouroFocus,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Logradouro não informada!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Bairro",
                    controller: _bairroController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bairro não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: EventHubTextFormField(
                          label: "Número",
                          textInputType: TextInputType.number,
                          controller: _numeroController,
                          focusNode: _numeroFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Número não informado!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: EventHubTextFormField(
                          label: "Complemento",
                          controller: _complementoController,
                        ),
                      ),
                    ],
                  ),
                  EventoCadastroGaleria(
                    listaEventoArquivo: _listaArquivos,
                    onRemove: (int index) {
                      _listaArquivos.removeAt(index);
                      setState(() {});
                    },
                    onUpload: (Arquivo arquivo) {
                      _listaArquivos.add(
                        EventoArquivo(
                          arquivo: arquivo,
                        ),
                      );
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        checkColor: colorBlue,
                        value: _isApenasConvidados,
                        onChanged: (newValue) {
                          setState(() {
                            _isApenasConvidados = !_isApenasConvidados;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isApenasConvidados = !_isApenasConvidados;
                          });
                        },
                        child: const Text(
                          "Apenas Convidados",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Continuar"),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget montarGaleria(double widthTela) {
    return Column(
      children: [
        Row(
          children: [
            montarCardNovaFoto(widthTela),
            SizedBox(
              width: 5,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
            SizedBox(
              width: 5,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
            SizedBox(
              width: 5,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
            SizedBox(
              width: 5,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
          ],
        )
      ],
    );
  }

  Widget montarCardNovaFoto(double widthTela) {
    double widthCard = (widthTela - (10 + defaultPadding * 2)) / 3;
    return Container(
      height: widthCard,
      width: widthCard,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(224, 220, 220, 1),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Icon(
          Ionicons.add_circle_outline,
          color: Color.fromRGBO(134, 131, 131, 1),
        ),
      ),
    );
  }

  Widget montarCardFoto(String link, double widthTela) {
    double widthCard = (widthTela - (10 + defaultPadding * 2)) / 3;
    return Container(
      height: widthCard,
      width: widthCard,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(224, 220, 220, 1),
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          link,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
