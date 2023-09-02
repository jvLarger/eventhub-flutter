import 'package:eventhub/model/publicacao/publicacao_resumida.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/views/publicacao/visualizacao/publicacao_visualizacao_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class CardPublicacaoResumida extends StatelessWidget {
  final PublicacaoResumida publicacaoResumida;
  final UsuarioAutenticado usuarioAutenticado;
  const CardPublicacaoResumida({
    super.key,
    required this.publicacaoResumida,
    required this.usuarioAutenticado,
  });

  @override
  Widget build(BuildContext context) {
    double widthCard = (MediaQuery.of(context).size.width - (30 + defaultPadding * 2)) / 3;
    return GestureDetector(
      onTap: () {
        Util.goTo(
          context,
          PublicacaoVisualizacaoPage(
            usuarioAutenticado: usuarioAutenticado,
            idPublicacao: publicacaoResumida.id!,
          ),
        );
      },
      child: Container(
        height: widthCard,
        width: widthCard,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color.fromRGBO(224, 220, 220, 1),
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            Util.montarURlFoto(publicacaoResumida.fotoPrincipal!.nomeAbsoluto!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
