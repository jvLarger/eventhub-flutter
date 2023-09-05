import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/sala/sala_bate_papo.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/chat/salaprivada/sala_privada_page.dart';
import 'package:eventhub/services/mensagem/mensagem_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SalasBatePapoPage extends StatefulWidget {
  const SalasBatePapoPage({super.key});

  @override
  State<SalasBatePapoPage> createState() => _SalasBatePapoPageState();
}

class _SalasBatePapoPageState extends State<SalasBatePapoPage> {
  bool _isLoading = true;
  List<SalaBatePapo> _listaSalaBatePapo = [];
  final TextEditingController _nomeCompletoController = TextEditingController();

  buscarSalasDeBatePapo() async {
    try {
      _listaSalaBatePapo = await MensagemService().buscarSalasBatePapo();
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
        : EventHubBody(
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
      subtitle: salaBatePapo.mensagensNaoLidas! > 0 ? Text("${salaBatePapo.mensagensNaoLidas!} mensage${salaBatePapo.mensagensNaoLidas! == 1 ? 'm' : 'ns'} não lida${salaBatePapo.mensagensNaoLidas! == 1 ? '' : 's'}") : null,
      contentPadding: const EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        top: 8,
        bottom: 8,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Util.goTo(context, const SalaPrivadaPage());
      },
      title: Text(
        salaBatePapo.usuario!.nomeCompleto!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
