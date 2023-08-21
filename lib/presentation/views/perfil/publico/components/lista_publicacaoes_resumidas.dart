import 'package:eventhub/model/publicacao/publicacao_resumida.dart';
import 'package:eventhub/presentation/views/perfil/publico/components/card_publicacao_resumida.dart';
import 'package:flutter/material.dart';

class ListaPublicacoesResumidas extends StatelessWidget {
  final List<PublicacaoResumida> listaPublicacaoResumida;
  const ListaPublicacoesResumidas({
    super.key,
    required this.listaPublicacaoResumida,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        publicacaoResumida: listaPublicacaoResumida[index],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      (index + 1 <= listaPublicacaoResumida.length - 1
                          ? CardPublicacaoResumida(
                              publicacaoResumida: listaPublicacaoResumida[index + 1],
                            )
                          : const SizedBox()),
                      const SizedBox(
                        width: 15,
                      ),
                      (index + 2 <= listaPublicacaoResumida.length - 2
                          ? CardPublicacaoResumida(
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
