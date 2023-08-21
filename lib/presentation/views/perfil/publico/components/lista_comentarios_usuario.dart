import 'package:eventhub/model/usuario/usuario_comentario.dart';
import 'package:eventhub/presentation/views/perfil/publico/components/card_comentario_usuario.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class ListaComentariosUsuario extends StatelessWidget {
  final List<UsuarioComentario> listaComentarios;
  const ListaComentariosUsuario({
    super.key,
    required this.listaComentarios,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: listaComentarios.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: listaComentarios.length - 1 == index ? 0 : defaultPadding),
          child: CardComentarioUsuario(
            usuarioComentario: listaComentarios[index],
          ),
        );
      },
    );
  }
}
