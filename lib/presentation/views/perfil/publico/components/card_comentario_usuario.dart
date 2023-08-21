import 'package:eventhub/model/usuario/usuario_comentario.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class CardComentarioUsuario extends StatelessWidget {
  final UsuarioComentario usuarioComentario;
  const CardComentarioUsuario({
    super.key,
    required this.usuarioComentario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(221, 213, 213, 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                Util.montarURlFotoByArquivo(usuarioComentario.usuarioOrigem!.foto),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuarioComentario.usuarioOrigem!.nomeCompleto!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  Util.formatarDataComHora(usuarioComentario.dataComentario),
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.2,
                    color: Color.fromRGBO(109, 117, 128, 1),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  usuarioComentario.comentario!,
                  style: const TextStyle(
                    fontSize: 15,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
