import 'package:brasil_fields/brasil_fields.dart';
import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/categoria/categoria.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/evento/evento_arquivo.dart';
import 'package:eventhub/model/evento/evento_categoria.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/model/viacep/viacep.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/evento/cadastro/components/estados_brasileiros.dart';
import 'package:eventhub/presentation/views/evento/cadastro/components/evento_cadastro_galeria.dart';
import 'package:eventhub/presentation/views/evento/cadastro/components/selecao_categorias.dart';
import 'package:eventhub/presentation/views/evento/meuseventos/meus_eventos_page.dart';
import 'package:eventhub/services/evento/evento_service.dart';
import 'package:eventhub/services/viacep/viacep_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class EventoCadastroPage extends StatefulWidget {
  final Evento? evento;
  final UsuarioAutenticado usuarioAutenticado;
  const EventoCadastroPage({
    super.key,
    this.evento,
    required this.usuarioAutenticado,
  });

  @override
  State<EventoCadastroPage> createState() => _EventoCadastroPageState();
}

class _EventoCadastroPageState extends State<EventoCadastroPage> {
  final _formKey = GlobalKey<FormState>();
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
  final TextEditingController _numeroMaximoIngressosController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _categoriasController = TextEditingController();
  final FocusNode _numeroFocus = FocusNode();
  final FocusNode _logradouroFocus = FocusNode();
  bool _isVisivel = true;

  void salvarEvento() async {
    Evento evento = Evento(
      nome: _nomeController.text,
      data: DateTime.parse(Util.converterDataPtBrParaEngl(_dataController.text)),
      horaInicio: TimeOfDay(
        hour: int.parse(_horaInicioController.text.split(":")[0]),
        minute: int.parse(_horaInicioController.text.split(":")[1]),
      ),
      valor: Util.converterValorRealToDouble(_valorController.text),
      descricao: _descricaoController.text,
      categorias: _listaCategorias,
      arquivos: _listaArquivos,
      cep: _cepController.text,
      cidade: _cidadeController.text,
      estado: _estado,
      logradouro: _logradouroController.text,
      bairro: _bairroController.text,
      numero: _numeroController.text,
      complemento: _complementoController.text,
      restrito: _isApenasConvidados,
      visivel: _isVisivel,
      numeroMaximoIngressos: _numeroMaximoIngressosController.text.isNotEmpty ? int.parse(_numeroMaximoIngressosController.text) : null,
    );

    try {
      Util.showLoading(context);

      if (widget.evento == null) {
        await EventoService().criarEvento(evento);
      } else {
        await EventoService().alterarEvento(widget.evento!.id!, evento);
      }
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Util.goToAndOverride(
        context,
        MeusEventosPage(
          usuarioAutenticado: widget.usuarioAutenticado,
        ),
      );
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

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
    if (widget.evento != null) {
      _nomeController.text = widget.evento!.nome ?? "";
      _dataController.text = DateFormat('dd/MM/yyyy').format(widget.evento!.data!);
      _horaInicioController.text = "${Util.leftPad(widget.evento!.horaInicio!.hour.toString(), "0", 2)}:${Util.leftPad(widget.evento!.horaInicio!.minute.toString(), "0", 2)}";
      _valorController.text = "R\$ ${Util.formatarReal(widget.evento!.valor)}";
      _descricaoController.text = widget.evento!.descricao ?? "";
      _cepController.text = Util.aplicarMascara(widget.evento!.cep!, "##.###-###");
      _cidadeController.text = widget.evento!.cidade ?? "";
      _estado = widget.evento!.estado ?? "";
      _logradouroController.text = widget.evento!.logradouro ?? "";
      _bairroController.text = widget.evento!.bairro ?? "";
      _numeroController.text = widget.evento!.numero ?? "";
      _complementoController.text = widget.evento!.complemento ?? "";
      _numeroMaximoIngressosController.text = widget.evento!.numeroMaximoIngressos != null ? widget.evento!.numeroMaximoIngressos.toString() : "";
      _isApenasConvidados = widget.evento!.restrito!;
      _isVisivel = widget.evento!.visivel!;
      _listaArquivos = widget.evento!.arquivos!;
      _listaCategorias = widget.evento!.categorias!;
      setState(() {});
      popularInputCategoriasSelecionadas();
    }
  }

  excluirEvento() async {
    try {
      Util.showLoading(context);
      await EventoService().excluirEvento(widget.evento!.id!);
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Evento cancelado com sucesso!");
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Util.goToAndOverride(
        context,
        MeusEventosPage(
          usuarioAutenticado: widget.usuarioAutenticado,
        ),
      );
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  void showMessageExclusao() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Excluir Evento',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja realmente cancelar esse evento? Todos os ingressos vendidos serão estornados e você não receberá nenhum valor!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                excluirEvento();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              onPressed: () {
                showMessageExclusao();
              },
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
              key: _formKey,
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
                              _horaInicioController.text = "${Util.leftPad(picked.hour.toString(), "0", 2)}:${Util.leftPad(picked.minute.toString(), "0", 2)}";
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
                  Row(
                    children: [
                      Expanded(
                        child: EventHubTextFormField(
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
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: EventHubTextFormField(
                          label: "Ingressos Disponíveis",
                          controller: _numeroMaximoIngressosController,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Número máximo de ingressos não informado!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
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
                    controller: _categoriasController,
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
                            listaCategoriasSelecionadas: getListaCategoriasSelecionadasNoEvento(),
                            limiteSelecao: 3,
                            updateCategoriasSelecionadas: (List<Categoria> listaCategoriasSelecionadas) {
                              updateCategoriasSelecionadas(listaCategoriasSelecionadas);
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        checkColor: colorBlue,
                        value: _isVisivel,
                        onChanged: (newValue) {
                          setState(() {
                            _isVisivel = !_isVisivel;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isVisivel = !_isVisivel;
                          });
                        },
                        child: const Text(
                          "Exibir nas buscas",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        salvarEvento();
                      }
                    },
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

  List<Categoria> getListaCategoriasSelecionadasNoEvento() {
    List<Categoria> listaCategoriasSelecionadasNoEvento = [];

    for (EventoCategoria eventoCategoria in _listaCategorias) {
      listaCategoriasSelecionadasNoEvento.add(eventoCategoria.categoria!);
    }

    return listaCategoriasSelecionadasNoEvento;
  }

  void updateCategoriasSelecionadas(List<Categoria> listaCategoriasSelecionadas) {
    List<EventoCategoria> listaEventoCategoria = [];
    for (Categoria categoria in listaCategoriasSelecionadas) {
      listaEventoCategoria.add(
        EventoCategoria(
          id: getIdEventoCategoriaSelecionadaPorCategoria(categoria),
          categoria: categoria,
        ),
      );
    }
    _listaCategorias = listaEventoCategoria;
    setState(() {});
    popularInputCategoriasSelecionadas();
  }

  int? getIdEventoCategoriaSelecionadaPorCategoria(Categoria categoria) {
    int? idEventoCategoria;

    for (EventoCategoria eventoCategoria in _listaCategorias) {
      if (eventoCategoria.categoria!.id == categoria.id) {
        idEventoCategoria = eventoCategoria.id;
        break;
      }
    }

    return idEventoCategoria;
  }

  void popularInputCategoriasSelecionadas() {
    String categorias = "";
    int i = 0;
    for (EventoCategoria eventoCategoria in _listaCategorias) {
      categorias += eventoCategoria.categoria!.nome!;
      if (i < _listaCategorias.length - 1) {
        categorias += ", ";
      }
      i++;
    }

    _categoriasController.text = categorias;
  }
}
