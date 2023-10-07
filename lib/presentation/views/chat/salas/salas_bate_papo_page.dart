import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/mensagem/mensagem.dart';
import 'package:eventhub/model/sala/sala_bate_papo.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/chat/salaprivada/sala_privada_page.dart';
import 'package:eventhub/presentation/views/perfil/meuperfil/meu_perfil_page.dart';
import 'package:eventhub/services/mensagem/mensagem_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SalasBatePapoPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  final bool isGoBackDefault;
  const SalasBatePapoPage({
    super.key,
    required this.usuarioAutenticado,
    required this.isGoBackDefault,
  });

  @override
  State<SalasBatePapoPage> createState() => _SalasBatePapoPageState();
}

class _SalasBatePapoPageState extends State<SalasBatePapoPage> {
  bool _isLoading = true;
  List<SalaBatePapo> _listaSalaBatePapoBkp = [];
  List<SalaBatePapo> _listaSalaBatePapo = [];
  final TextEditingController _nomeCompletoController = TextEditingController();

  filtrarSalasBatePapo(String nome) {
    List<SalaBatePapo> listaSalaBatePapoFiltrado = [];

    for (SalaBatePapo salaBatePapo in _listaSalaBatePapoBkp) {
      if (salaBatePapo.usuario!.nomeCompleto!.toLowerCase().contains(nome.toLowerCase())) {
        listaSalaBatePapoFiltrado.add(salaBatePapo);
      }
    }

    setState(() {
      _listaSalaBatePapo = listaSalaBatePapoFiltrado;
    });
  }

  buscarSalasDeBatePapo() async {
    try {
      _listaSalaBatePapoBkp = await MensagemService().buscarSalasBatePapo();
      _listaSalaBatePapo.addAll(_listaSalaBatePapoBkp);
      _isLoading = false;
      setState(() {});
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarSalasDeBatePapo();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : WillPopScope(
            onWillPop: () async {
              if (!widget.isGoBackDefault) {
                Util.goToAndOverride(
                  context,
                  MeuPerfilPage(
                    usuarioAutenticado: widget.usuarioAutenticado,
                  ),
                );
                return false;
              } else {
                return true;
              }
            },
            child: EventHubBody(
              topWidget: const EventHubTopAppbar(
                title: "Bate Papo",
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: defaultPadding,
                      left: defaultPadding,
                      right: defaultPadding,
                    ),
                    child: EventHubTextFormField(
                      label: "Pesquise pelo nome",
                      controller: _nomeCompletoController,
                      onchange: (String nome) {
                        filtrarSalasBatePapo(nome);
                      },
                      prefixIcon: const Icon(
                        Ionicons.search,
                        size: 15,
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return getParticipante(_listaSalaBatePapo[i]);
                    },
                    itemCount: _listaSalaBatePapo.length,
                  ),
                ],
              ),
            ),
          );
  }

  getParticipante(SalaBatePapo salaBatePapo) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          Util.montarURlFotoByArquivo(
            salaBatePapo.usuario!.foto,
          ),
        ),
      ),
      subtitle: salaBatePapo.mensagensNaoLidas! > 0
          ? Text("${salaBatePapo.mensagensNaoLidas!} mensage${salaBatePapo.mensagensNaoLidas! == 1 ? 'm' : 'ns'} não lida${salaBatePapo.mensagensNaoLidas! == 1 ? '' : 's'}")
          : salaBatePapo.ultimaMensagem != null
              ? getWidgetUltimaMensagem(salaBatePapo.ultimaMensagem!)
              : null,
      contentPadding: const EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        top: 8,
        bottom: 8,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Util.goTo(
          context,
          SalaPrivadaPage(
            usuario: salaBatePapo.usuario!,
            usuarioAutenticado: widget.usuarioAutenticado,
            isGoBackDefault: false,
          ),
        );
      },
      title: Text(
        salaBatePapo.usuario!.nomeCompleto!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getWidgetUltimaMensagem(Mensagem ultimaMensagem) {
    return Text(
      ultimaMensagem.usuarioOrigem!.id == widget.usuarioAutenticado.id ? "Eu: ${ultimaMensagem.descricao!}" : "Ele: ${ultimaMensagem.descricao!}",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
