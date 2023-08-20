import 'dart:convert';
import 'dart:io';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/db/usuario_db.dart';
import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/perfil/meuperfil/meu_perfil_page.dart';
import 'package:eventhub/services/arquivo/arquivo_service.dart';
import 'package:eventhub/services/usuario/usuario_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';

class MinhasInformacoesPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const MinhasInformacoesPage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<MinhasInformacoesPage> createState() => _MinhasInformacoesPageState();
}

class _MinhasInformacoesPageState extends State<MinhasInformacoesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _dataComemorativaController = TextEditingController();
  final MaskedTextController _documentoPrincipalController = MaskedTextController(mask: '000.000.000-00');
  final MaskedTextController _telefoneController = MaskedTextController(mask: '00 0 0000-0000');
  final imagePicker = ImagePicker();

  alterarInformacoesUsuario() async {
    try {
      Util.showLoading(context);
      await UsuarioService().alterarInformacoesUsuario(
        Usuario(
          nomeCompleto: _nomeCompletoController.text,
          dataComemorativa: Util.converterDataPtBrParaEngl(_dataComemorativaController.text),
          documentoPrincipal: Util.getSomenteNumeros(_documentoPrincipalController.text),
          telefone: Util.getSomenteNumeros(_telefoneController.text),
        ),
      );
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Informações salvas com sucesso!");
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  buscarUsuarioLogado() async {
    try {
      Usuario usuario = await UsuarioService().buscarUsuarioLogado();
      _nomeCompletoController.text = usuario.nomeCompleto!;
      _dataComemorativaController.text = usuario.dataComemorativa != null ? Util.dateEngToPtBr(usuario.dataComemorativa!) : "";
      _telefoneController.text = usuario.telefone != null ? Util.aplicarMascara(usuario.telefone!, "## # ####-####") : "";
      _documentoPrincipalController.text = usuario.documentoPrincipal != null
          ? usuario.documentoPrincipal!.length == 11
              ? Util.aplicarMascara(usuario.documentoPrincipal!, "###.###.###-##")
              : Util.aplicarMascara(usuario.documentoPrincipal!, "##.###.###/####-##")
          : "";

      if (mounted) {
        setState(() {});
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  pick(ImageSource source) async {
    try {
      final pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        File file = File(pickedFile.path);

        List<int> bytes = file.readAsBytesSync();

        String base64String = base64Encode(bytes);
        // ignore: use_build_context_synchronously
        Util.showLoading(context);
        Arquivo arquivo = await ArquivoService().uploadArquivoBase64(base64String);

        await UsuarioService().alterarImagemPerfilUsuario(arquivo.id!);
        // ignore: use_build_context_synchronously
        UsuarioDB().alterarFoto(arquivo);
        widget.usuarioAutenticado.foto = arquivo;

        setState(() {});

        // ignore: use_build_context_synchronously
        Util.hideLoading(context);
      }
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Util.goToAndOverride(
          context,
          MeuPerfilPage(
            usuarioAutenticado: widget.usuarioAutenticado,
          ),
        );
        return false;
      },
      child: EventHubBody(
        topWidget: const EventHubTopAppbar(
          title: "Minhas Informações",
        ),
        bottomNavigationBar: EventHubBottomButton(
          label: "Alterar Informações",
          onTap: () {
            if (_formKey.currentState!.validate()) {
              alterarInformacoesUsuario();
            }
          },
        ),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: widget.usuarioAutenticado.foto != null ? NetworkImage("${Api.baseURL}/publico/imagens/${widget.usuarioAutenticado.foto!.nomeAbsoluto!}") : const NetworkImage(""),
                        child: IconButton(
                          onPressed: _showOpcoesBottomSheet,
                          icon: Icon(
                            Ionicons.pencil,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: defaultPadding * 1.5,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    EventHubTextFormField(
                      label: "Nome Completo",
                      prefixIcon: const Icon(
                        Ionicons.person,
                        size: 15,
                      ),
                      controller: _nomeCompletoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome Completo não informado!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    EventHubTextFormField(
                      label: "Data de Nascimento",
                      prefixIcon: const Icon(
                        Ionicons.calendar,
                        size: 15,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _dataComemorativaController.text.isEmpty
                              ? DateTime.now()
                              : DateTime.now().copyWith(
                                  day: int.parse(_dataComemorativaController.text.split("/")[0]),
                                  month: int.parse(_dataComemorativaController.text.split("/")[1]),
                                  year: int.parse(_dataComemorativaController.text.split("/")[2]),
                                ),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          String dataFormatada = DateFormat('dd/MM/yyyy').format(pickedDate);
                          _dataComemorativaController.text = dataFormatada;
                        }
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          _dataComemorativaController.text = "";
                        },
                        icon: const Icon(
                          Ionicons.trash,
                          size: 15,
                        ),
                      ),
                      controller: _dataComemorativaController,
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    EventHubTextFormField(
                      label: "CPF ou CNPJ",
                      prefixIcon: const Icon(
                        Ionicons.card_outline,
                        size: 15,
                      ),
                      controller: _documentoPrincipalController,
                      onchange: (value) {
                        if (mounted) {
                          setState(() {
                            if (Util.getSomenteNumeros(value).length < 11) {
                              _documentoPrincipalController.updateMask('000.000.000-00');
                            } else {
                              _documentoPrincipalController.updateMask('00.000.000/0000-00');
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    EventHubTextFormField(
                      label: "Telefone",
                      prefixIcon: const Icon(
                        Ionicons.phone_portrait_outline,
                        size: 15,
                      ),
                      controller: _telefoneController,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Ionicons.image,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Buscar imagem da galeria
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Ionicons.camera,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Fazer foto da câmera
                  pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Ionicons.trash,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  UsuarioService().alterarImagemPerfilUsuario(null);
                  widget.usuarioAutenticado.foto = null;
                  setState(() {});
                  UsuarioDB().alterarFoto(null);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
