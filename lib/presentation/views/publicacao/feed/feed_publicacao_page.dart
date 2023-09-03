import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/publicacao/page_publicacao.dart';
import 'package:eventhub/model/publicacao/publicacao.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/components/informacoes_usuario.dart';
import 'package:eventhub/presentation/views/perfil/publico/perfil_publico_page.dart';
import 'package:eventhub/presentation/views/publicacao/cadastro/publicacao_cadastro_page.dart';
import 'package:eventhub/presentation/views/publicacao/visualizacao/publicacao_visualizacao_page.dart';
import 'package:eventhub/services/publicacao/publicacao_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class FeedPublicacao extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const FeedPublicacao({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<FeedPublicacao> createState() => _FeedPublicacaoState();
}

class _FeedPublicacaoState extends State<FeedPublicacao> {
  final List<Publicacao> _listaPublicacoes = [];
  final ScrollController _scrollController = ScrollController();
  int _page = 0;
  bool _isExistisMoreData = true;

  curtirPublicacao(int index) async {
    try {
      Util.showLoading(context);

      await PublicacaoService().curtirPublicacao(_listaPublicacoes[index].id!);
      _listaPublicacoes[index].isCurti = true;
      _listaPublicacoes[index].curtidas = _listaPublicacoes[index].curtidas! + 1;
      setState(() {});
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  descurtirPublicacao(int index) async {
    try {
      Util.showLoading(context);

      await PublicacaoService().descurtirPublicacao(_listaPublicacoes[index].id!);
      _listaPublicacoes[index].isCurti = false;
      _listaPublicacoes[index].curtidas = _listaPublicacoes[index].curtidas! - 1;
      setState(() {});
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() async {
    try {
      if (_isExistisMoreData) {
        PagePublicacao pagePublicacao = await PublicacaoService().buscarFeedPublicacao(_page);
        _listaPublicacoes.addAll(pagePublicacao.content!);
        _page++;
        _isExistisMoreData = !pagePublicacao.last!;
        setState(() {});
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: EventHubBottomBar(
        indexRecursoAtivo: 1,
        usuarioAutenticado: widget.usuarioAutenticado,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(
                defaultPadding,
              ),
              child: InformacoesUsuario(
                usuarioAutenticado: widget.usuarioAutenticado,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ElevatedButton(
                onPressed: () {
                  Util.goTo(
                    context,
                    PublicacaoCadastroPage(
                      usuarioAutenticado: widget.usuarioAutenticado,
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nova Publicação"),
                  ],
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                if (i == _listaPublicacoes.length && _isExistisMoreData) {
                  return const CupertinoActivityIndicator();
                }

                if (_listaPublicacoes.length != i) {
                  return getCardPublicacao(_listaPublicacoes[i], i);
                } else {
                  return const SizedBox();
                }
              },
              itemCount: _listaPublicacoes.length + 1,
            )
          ],
        ),
      ),
    );
  }

  Widget getCardPublicacao(Publicacao publicacao, int index) {
    return GestureDetector(
      onTap: () {
        Util.goTo(
          context,
          PublicacaoVisualizacaoPage(
            idPublicacao: publicacao.id!,
            usuarioAutenticado: widget.usuarioAutenticado,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: defaultPadding,
          right: defaultPadding,
          bottom: defaultPadding,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
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
          border: Border.all(
            color: const Color.fromARGB(255, 234, 234, 234),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Util.goTo(
                            context,
                            PerfilPublicoPage(
                              idUsuario: publicacao.usuario!.id!,
                              usuarioAutenticado: widget.usuarioAutenticado,
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            Util.montarURlFotoByArquivo(
                              publicacao.usuario!.foto,
                            ),
                          ),
                          radius: 16,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        publicacao.usuario!.nomeCompleto!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              child: Image.network(
                Util.montarURlFotoByArquivo(publicacao.arquivos![0].arquivo),
                height: 150,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Text(
                      publicacao.descricao!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: publicacao.isCurti!,
                    child: Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          descurtirPublicacao(index);
                        },
                        icon: const Icon(
                          Ionicons.heart,
                          color: colorBlue,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !publicacao.isCurti!,
                    child: Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          curtirPublicacao(index);
                        },
                        icon: const Icon(
                          Ionicons.heart_outline,
                          color: colorBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Util.formatarDataComHora(publicacao.data),
                        style: const TextStyle(fontSize: 11, color: colorBlue),
                      ),
                    ],
                  ),
                  Text(
                    "${publicacao.curtidas!} Curtidas",
                    style: const TextStyle(
                      color: colorBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            const Divider(),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ver Completa",
                  style: TextStyle(
                    color: colorBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
