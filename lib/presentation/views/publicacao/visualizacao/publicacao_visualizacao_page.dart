import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PublicacaoVisualizacaoPage extends StatefulWidget {
  const PublicacaoVisualizacaoPage({super.key});

  @override
  State<PublicacaoVisualizacaoPage> createState() => _PublicacaoVisualizacaoPageState();
}

class _PublicacaoVisualizacaoPageState extends State<PublicacaoVisualizacaoPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      child: Column(
        children: [
          Container(
            height: 360,
            width: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1632008649281-0846891f76bd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1625&q=80",
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                defaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [BackButton()],
              ),
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Row(
              children: [
                Text(
                  "22/12/2022 às 18:33",
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Juliana Ribeiro",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Ionicons.trash_outline,
                        color: colorBlue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Ionicons.heart_outline,
                        color: colorBlue,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Row(
              children: [
                Text(
                  "15 curtidas",
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Divider(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Text(
              "Lorem ipsum dolor sit amet. Et tempore architecto ea accusantium consequatur est rerum laborum est deleniti libero qui provident quia vel modi maiores aut dolorem laborum.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Column(
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
                ),
                EventHubTextFormField(
                  label: "Escreva alguma coisa...",
                  suffixIcon: IconButton(
                    icon: Icon(
                      Ionicons.send,
                      color: colorBlue,
                      size: 15,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
        ],
      ),
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
