import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/perfil/perfil.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/perfil/publico/components/lista_comentarios_usuario.dart';
import 'package:eventhub/presentation/views/perfil/publico/components/lista_publicacaoes_resumidas.dart';
import 'package:eventhub/services/perfil/perfil_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PerfilPublicoPage extends StatefulWidget {
  final int idUsuario;
  const PerfilPublicoPage({
    super.key,
    required this.idUsuario,
  });

  @override
  State<PerfilPublicoPage> createState() => _PerfilPublicoPageState();
}

class _PerfilPublicoPageState extends State<PerfilPublicoPage> with TickerProviderStateMixin {
  bool _isLoading = true;
  Perfil _perfil = Perfil();
  TabController? _tabController;
  int _indexTabAtiva = 0;

  buscarPerfil() async {
    try {
      _perfil = await PerfilService().buscarPerfil(widget.idUsuario);

      _isLoading = false;
      setState(() {});
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
    buscarPerfil();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : EventHubBody(
            topWidget: const EventHubTopAppbar(
              title: "",
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          Util.montarURlFotoByArquivo(_perfil.usuario!.foto),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    _perfil.usuario!.nomeCompleto!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromRGBO(221, 213, 213, 1),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                          child: Column(
                            children: [
                              Text(
                                _perfil.numeroEventos.toString(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Color.fromRGBO(33, 33, 33, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding / 2,
                              ),
                              const Text(
                                "Eventos",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(97, 97, 97, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 0.5,
                        color: const Color.fromRGBO(221, 213, 213, 1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              _perfil.numeroAmigos.toString(),
                              style: const TextStyle(
                                fontSize: 32,
                                color: Color.fromRGBO(33, 33, 33, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: defaultPadding / 2,
                            ),
                            const Text(
                              "Amigos",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(97, 97, 97, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromRGBO(221, 213, 213, 1),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          ),
                          child: _perfil.isAmigo!
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Ionicons.person_remove,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Remover "),
                                  ],
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Ionicons.person_add,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Adicionar"),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message_outlined,
                                size: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Mensagem"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromRGBO(221, 213, 213, 1),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TabBar(
                    unselectedLabelColor: Colors.black,
                    labelColor: colorBlue,
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Urbanist',
                    ),
                    onTap: (value) {
                      _indexTabAtiva = value;
                      setState(() {});
                    },
                    tabs: const [
                      Tab(
                        text: 'Publicações',
                      ),
                      Tab(
                        text: 'Comentários',
                      )
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 28,
                    ),
                    child: _indexTabAtiva == 0
                        ? ListaPublicacoesResumidas(
                            listaPublicacaoResumida: _perfil.publicacoes!,
                          )
                        : Column(
                            children: [
                              ListaComentariosUsuario(
                                listaComentarios: _perfil.comentarios!,
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              EventHubTextFormField(
                                label: "Escreva alguma coisa...",
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
            ),
          );
  }
}
