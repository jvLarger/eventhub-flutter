import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/services/amizade/amizade_service.dart';
import 'package:eventhub/services/evento/evento_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EventoCompartilhamentoPage extends StatefulWidget {
  final int idEvento;
  const EventoCompartilhamentoPage({
    super.key,
    required this.idEvento,
  });

  @override
  State<EventoCompartilhamentoPage> createState() => _EventoCompartilhamentoPageState();
}

class _EventoCompartilhamentoPageState extends State<EventoCompartilhamentoPage> {
  bool _isLoding = true;
  List<Usuario> _listaUsuarioBkp = [];
  List<Usuario> _listaUsuario = [];

  int getIndexListaUsuariosNaoFiltrada(Usuario usuario) {
    int index = 0;
    for (Usuario usuarioAux in _listaUsuarioBkp) {
      if (usuarioAux.id == usuario.id) {
        break;
      }
      index++;
    }
    return index;
  }

  compartilharEventoComOUsuario(Usuario usuario, int indexListaFiltrada) async {
    try {
      Util.showLoading(context);
      await EventoService().compartilharEvento(widget.idEvento, usuario.id!);

      int indexListaUsuariosNaoFiltrada = getIndexListaUsuariosNaoFiltrada(usuario);

      _listaUsuarioBkp[indexListaUsuariosNaoFiltrada].isSolicitacaoAmizadePendente = true;
      _listaUsuario[indexListaFiltrada].isSolicitacaoAmizadePendente = true;

      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
      setState(() {});
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  filtrarUsuarios(String nome) {
    List<Usuario> listaUsuarioFiltrado = [];

    for (Usuario usuario in _listaUsuarioBkp) {
      if (usuario.nomeCompleto!.toLowerCase().contains(nome.toLowerCase())) {
        listaUsuarioFiltrado.add(usuario);
      }
    }

    setState(() {
      _listaUsuario = listaUsuarioFiltrado;
    });
  }

  buscarAmigosUsuario() async {
    try {
      _listaUsuarioBkp = await AmizadeService().buscarAmigos();
      _listaUsuario.addAll(_listaUsuarioBkp);
      if (mounted) {
        setState(() {
          _isLoding = false;
        });
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarAmigosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoding
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : EventHubBody(
            topWidget: const EventHubTopAppbar(
              title: "Enviar para Amigos",
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  EventHubTextFormField(
                    label: "Pesquise pelo nome",
                    onchange: (nome) {
                      filtrarUsuarios(nome);
                    },
                    prefixIcon: const Icon(
                      Ionicons.search,
                      size: 15,
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _listaUsuario.length,
                    itemBuilder: (context, index) {
                      return getAmigo(_listaUsuario[index], index);
                    },
                  ),
                ],
              ),
            ),
          );
  }

  Widget getAmigo(Usuario usuario, int indexListaFiltrada) {
    return ListTile(
      onTap: () {},
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          Util.montarURlFotoByArquivo(usuario.foto),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        left: 0,
        right: 0,
        bottom: 5,
        top: 5,
      ),
      trailing: usuario.isSolicitacaoAmizadePendente != null && usuario.isSolicitacaoAmizadePendente!
          ? const Text(
              "Enviado...",
              style: TextStyle(
                color: colorBlue,
                letterSpacing: 0.4,
              ),
            )
          : ElevatedButton(
              onPressed: () {
                compartilharEventoComOUsuario(usuario, indexListaFiltrada);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              child: const Text("Enviar"),
            ),
      title: Text(
        usuario.nomeCompleto!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
