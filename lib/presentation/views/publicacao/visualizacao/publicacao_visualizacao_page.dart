import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/publicacao/publicacao.dart';
import 'package:eventhub/model/publicacao/publicacao_arquivo.dart';
import 'package:eventhub/model/publicacao/publicacao_comentario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/perfil/publico/perfil_publico_page.dart';
import 'package:eventhub/services/publicacao/publicacao_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PublicacaoVisualizacaoPage extends StatefulWidget {
  final int idPublicacao;
  final UsuarioAutenticado usuarioAutenticado;
  const PublicacaoVisualizacaoPage({
    super.key,
    required this.idPublicacao,
    required this.usuarioAutenticado,
  });

  @override
  State<PublicacaoVisualizacaoPage> createState() => _PublicacaoVisualizacaoPageState();
}

class _PublicacaoVisualizacaoPageState extends State<PublicacaoVisualizacaoPage> {
  bool _isLoading = true;
  Publicacao _publicacao = Publicacao();
  final TextEditingController _comentarioController = TextEditingController();

  buscarPublicacao() async {
    try {
      _publicacao = await PublicacaoService().buscarPublicacao(widget.idPublicacao);
      setState(() {
        _isLoading = false;
      });
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarPublicacao();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : EventHubBody(
            child: Column(
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      items: getImagensSliders(),
                      options: CarouselOptions(
                        height: 260.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(milliseconds: 3000),
                        viewportFraction: 1,
                      ),
                    ),
                    const Positioned(
                      top: defaultPadding,
                      left: defaultPadding / 2,
                      child: BackButton(),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Util.formatarDataComHora(_publicacao.data),
                            style: const TextStyle(
                              color: colorBlue,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "${_publicacao.curtidas} curtidas",
                            style: const TextStyle(
                              color: colorBlue,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _publicacao.usuario!.nomeCompleto!,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: _publicacao.isMinhaPublicacao!,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Ionicons.trash_outline,
                                    color: colorBlue,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _publicacao.isCurti!,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Ionicons.heart,
                                    color: colorBlue,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !_publicacao.isCurti!,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Ionicons.heart_outline,
                                    color: colorBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        _publicacao.descricao!,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      getListaComentarios(),
                      const SizedBox(
                        height: 20,
                      ),
                      EventHubTextFormField(
                        label: "Escreva alguma coisa...",
                        controller: _comentarioController,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Ionicons.send,
                            color: colorBlue,
                            size: 15,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget getContainerMensagemRecebida(PublicacaoComentario publicacaoComentario) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(244, 246, 249, 1),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    publicacaoComentario.usuario!.nomeCompleto!,
                    style: const TextStyle(
                      color: colorBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                  Text(
                    Util.formatarDataComHora(
                      publicacaoComentario.data!,
                    ),
                    style: const TextStyle(
                      color: colorBlue,
                      fontSize: 11,
                      letterSpacing: 0.4,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      publicacaoComentario.descricao!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                ],
              ),
            ],
          ),
        ),
        _publicacao.isMinhaPublicacao! || publicacaoComentario.usuario!.id == widget.usuarioAutenticado.id
            ? SizedBox(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Excluir",
                        style: TextStyle(
                          color: Colors.red,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(
                height: 20,
              ),
      ],
    );
  }

  List<Widget> getImagensSliders() {
    List<Widget> lista = [];

    for (PublicacaoArquivo publicacaoArquivo in _publicacao.arquivos!) {
      lista.add(
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                Util.montarURlFotoByArquivo(
                  publicacaoArquivo.arquivo,
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return lista;
  }

  Widget getListaComentarios() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: _publicacao.comentarios!.length,
      itemBuilder: (context, index) {
        return getComentario(
          _publicacao.comentarios![index],
        );
      },
    );
  }

  Widget getComentario(PublicacaoComentario publicacaoComentario) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Util.goTo(
                    context,
                    PerfilPublicoPage(
                      idUsuario: publicacaoComentario.usuario!.id!,
                      usuarioAutenticado: widget.usuarioAutenticado,
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    Util.montarURlFotoByArquivo(publicacaoComentario.usuario!.foto),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 8,
          child: Column(
            children: [
              getContainerMensagemRecebida(
                publicacaoComentario,
              ),
            ],
          ),
        )
      ],
    );
  }
}
