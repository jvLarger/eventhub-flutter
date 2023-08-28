import 'package:eventhub/model/usuario/usuario_comentario.dart';
import 'package:eventhub/presentation/views/perfil/publico/components/card_comentario_usuario.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListaComentariosUsuario extends StatelessWidget {
  final List<UsuarioComentario> listaComentarios;
  final Function(UsuarioComentario) tratarRemocaoComentario;
  const ListaComentariosUsuario({
    super.key,
    required this.listaComentarios,
    required this.tratarRemocaoComentario,
  });

  @override
  Widget build(BuildContext context) {
    return listaComentarios.isEmpty
        ? Column(
            children: [
              SvgPicture.asset(
                "assets/images/empty.svg",
                width: 250,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text(
                "Nenhum Comentário Encontrado",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: listaComentarios.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: listaComentarios.length - 1 == index ? 0 : defaultPadding),
                child: CardComentarioUsuario(
                  tratarRemocaoComentario: tratarRemocaoComentario,
                  usuarioComentario: listaComentarios[index],
                ),
              );
            },
          );
  }
}
