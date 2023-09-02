import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/perfil/publico/perfil_publico_page.dart';
import 'package:eventhub/services/publicacao/publicacao_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class PublicacaoCurtidasPage extends StatefulWidget {
  final int idPublicacao;
  final UsuarioAutenticado usuarioAutenticado;
  const PublicacaoCurtidasPage({
    super.key,
    required this.idPublicacao,
    required this.usuarioAutenticado,
  });

  @override
  State<PublicacaoCurtidasPage> createState() => _PublicacaoCurtidasPageState();
}

class _PublicacaoCurtidasPageState extends State<PublicacaoCurtidasPage> {
  bool _isLoading = true;
  List<Usuario> _listaUsuarios = [];

  buscarPessoasQueCurtiram() async {
    try {
      _listaUsuarios = await PublicacaoService().buscarUsuariosQueCurtiram(widget.idPublicacao);
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
    buscarPessoasQueCurtiram();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : EventHubBody(
            topWidget: const EventHubTopAppbar(
              title: "Pessoas que Curtiram",
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _listaUsuarios.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Util.goTo(
                        context,
                        PerfilPublicoPage(
                          idUsuario: _listaUsuarios[index].id!,
                          usuarioAutenticado: widget.usuarioAutenticado,
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(Util.montarURlFotoByArquivo(_listaUsuarios[index].foto)),
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 0,
                      right: 0,
                      bottom: defaultPadding / 2,
                      top: defaultPadding / 2,
                    ),
                    title: Text(
                      _listaUsuarios[index].nomeCompleto!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
