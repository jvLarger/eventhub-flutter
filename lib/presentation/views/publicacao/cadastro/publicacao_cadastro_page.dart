import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/publicacao/publicacao.dart';
import 'package:eventhub/model/publicacao/publicacao_arquivo.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/publicacao/cadastro/components/publicacao_cadastro_galeria.dart';
import 'package:eventhub/presentation/views/publicacao/feed/feed_publicacao_page.dart';
import 'package:eventhub/services/publicacao/publicacao_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class PublicacaoCadastroPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const PublicacaoCadastroPage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<PublicacaoCadastroPage> createState() => _PublicacaoCadastroPageState();
}

class _PublicacaoCadastroPageState extends State<PublicacaoCadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();
  final List<PublicacaoArquivo> _listaPublicacaoArquivo = [];

  criarPublicacao() async {
    try {
      Util.showLoading(context);

      if (_listaPublicacaoArquivo.isEmpty) {
        throw EventHubException("É necessário adicionar pelo menos uma imagem!");
      }

      await PublicacaoService().criarPublicacao(
        Publicacao(
          descricao: _descricaoController.text,
          arquivos: _listaPublicacaoArquivo,
        ),
      );
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      // ignore: use_build_context_synchronously
      Util.showSnackbarSuccess(context, "Publicação criada com sucesso!");
      // ignore: use_build_context_synchronously
      Util.goToAndOverride(
        context,
        FeedPublicacao(usuarioAutenticado: widget.usuarioAutenticado),
      );
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Nova Publicação",
      ),
      bottomNavigationBar: EventHubBottomButton(
        label: "Publicar",
        onTap: () {
          if (_formKey.currentState!.validate()) {
            criarPublicacao();
          }
        },
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
                    label: "Descrição",
                    minLines: 4,
                    maxLines: 40,
                    controller: _descricaoController,
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
                  PublicacaoCadastroGaleria(
                    listaPublicacaoArquivo: _listaPublicacaoArquivo,
                    onUpload: (Arquivo arquivo) {
                      _listaPublicacaoArquivo.add(
                        PublicacaoArquivo(
                          arquivo: arquivo,
                        ),
                      );
                      setState(() {});
                    },
                    onRemove: (int index) {
                      _listaPublicacaoArquivo.removeAt(index);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
