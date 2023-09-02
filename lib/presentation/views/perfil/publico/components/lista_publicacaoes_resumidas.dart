import 'package:eventhub/model/publicacao/publicacao_resumida.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/views/perfil/publico/components/card_publicacao_resumida.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListaPublicacoesResumidas extends StatelessWidget {
  final List<PublicacaoResumida> listaPublicacaoResumida;
  final UsuarioAutenticado usuarioAutenticado;
  const ListaPublicacoesResumidas({
    super.key,
    required this.listaPublicacaoResumida,
    required this.usuarioAutenticado,
  });

  @override
  Widget build(BuildContext context) {
    return listaPublicacaoResumida.isEmpty
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
                "Nenhuma Publicação Encontrada",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        : Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: listaPublicacaoResumida.length,
                itemBuilder: (context, index) {
                  return index % 3 == 0
                      ? Row(
                          children: [
                            CardPublicacaoResumida(
                              usuarioAutenticado: usuarioAutenticado,
                              publicacaoResumida: listaPublicacaoResumida[index],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            (index + 1 <= listaPublicacaoResumida.length - 1
                                ? CardPublicacaoResumida(
                                    usuarioAutenticado: usuarioAutenticado,
                                    publicacaoResumida: listaPublicacaoResumida[index + 1],
                                  )
                                : const SizedBox()),
                            const SizedBox(
                              width: 15,
                            ),
                            (index + 2 <= listaPublicacaoResumida.length - 2
                                ? CardPublicacaoResumida(
                                    usuarioAutenticado: usuarioAutenticado,
                                    publicacaoResumida: listaPublicacaoResumida[index + 2],
                                  )
                                : const SizedBox()),
                          ],
                        )
                      : const SizedBox();
                },
              ),
            ],
          );
  }
}
