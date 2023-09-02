import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/components/informacoes_usuario.dart';
import 'package:eventhub/presentation/views/publicacao/cadastro/publicacao_cadastro_page.dart';
import 'package:eventhub/presentation/views/publicacao/visualizacao/publicacao_visualizacao_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class FeedPublicacao extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const FeedPublicacao({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<FeedPublicacao> createState() => _FeedPublicacaoState();
}

class _FeedPublicacaoState extends State<FeedPublicacao> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      bottomNavigationBar: EventHubBottomBar(
        indexRecursoAtivo: 1,
        usuarioAutenticado: widget.usuarioAutenticado,
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            InformacoesUsuario(
              usuarioAutenticado: widget.usuarioAutenticado,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            ElevatedButton(
              onPressed: () {
                Util.goTo(
                    context,
                    PublicacaoCadastroPage(
                      usuarioAutenticado: widget.usuarioAutenticado,
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Nova Publicação"),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            getCardPublicacao(),
            SizedBox(
              height: defaultPadding,
            ),
            getCardPublicacao(),
          ],
        ),
      ),
    );
  }

  Widget getCardPublicacao() {
    return GestureDetector(
      onTap: () {
        Util.goTo(
          context,
          PublicacaoVisualizacaoPage(
            idPublicacao: 1,
            usuarioAutenticado: widget.usuarioAutenticado,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: defaultPadding),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 60.0,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(
                0,
                4,
              ),
              spreadRadius: 4,
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://www.cnnbrasil.com.br/wp-content/uploads/sites/12/2021/06/28111_E0F1D56D3B62CA0F.jpg?w=1024",
                height: 150,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Juliana Ribeiro",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      " - 22/12/2023",
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Text(
                  "15 Curtidas",
                  style: TextStyle(
                    color: colorBlue,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Text(
                    "Lorem ipsum dolor sit amet. Et tempore architecto ea accusantium consequatur est rerum laborum est deleniti libero qui provident quia vel modi maiores aut dolorem laborum.",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {},
                    color: colorBlue,
                    icon: Icon(Ionicons.heart_outline),
                  ),
                )
              ],
            ),
            SizedBox(
              height: defaultPadding / 2,
            ),
            Divider(),
            SizedBox(
              height: defaultPadding / 2,
            ),
            getMensagemRecebida(),
            SizedBox(
              height: defaultPadding / 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ver Mais",
                  style: TextStyle(
                    color: colorBlue,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget getMensagemRecebida() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqmPKaH4GXJy1UGNzYYsB6u8ZjGo1AVZwZtA&usqp=CAU",
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  getContainerMensagemRecebida("Legal!", "10:00"),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  getContainerMensagemRecebida(String mensagem, String hora) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
          color: Color.fromRGBO(244, 246, 249, 1),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Text(
              mensagem,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hora,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
