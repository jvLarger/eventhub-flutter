import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EventoVisualizacaoPage extends StatefulWidget {
  const EventoVisualizacaoPage({super.key});

  @override
  State<EventoVisualizacaoPage> createState() => _EventoVisualizacaoPageState();
}

class _EventoVisualizacaoPageState extends State<EventoVisualizacaoPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      bottomNavigationBar: EventHubBottomButton(
        label: "Comprar Ingresso",
        onTap: () {},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
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
                children: [
                  Row(
                    children: [
                      BackButton(),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rock in Rio",
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
                            Ionicons.heart_outline,
                            color: colorBlue,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.send_rounded,
                            color: colorBlue,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    EventHubBadge(
                      color: colorBlue,
                      label: "Música",
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          width: 140,
                          height: 40,
                        ),
                        Positioned(
                          left: 1 * 20,
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage("https://www.jacalculei.com.br/wp-content/uploads/2022/02/O-que-e%CC%81-Pessoa-Juri%CC%81dica-.png"),
                            radius: 20,
                          ),
                        ),
                        Positioned(
                          left: 2 * 20,
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage("https://www.jacalculei.com.br/wp-content/uploads/2022/02/O-que-e%CC%81-Pessoa-Juri%CC%81dica-.png"),
                            radius: 20,
                          ),
                        ),
                        Positioned(
                          left: 3 * 20,
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage("https://www.jacalculei.com.br/wp-content/uploads/2022/02/O-que-e%CC%81-Pessoa-Juri%CC%81dica-.png"),
                            radius: 20,
                          ),
                        ),
                        Positioned(
                          left: 4 * 20,
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage("https://www.jacalculei.com.br/wp-content/uploads/2022/02/O-que-e%CC%81-Pessoa-Juri%CC%81dica-.png"),
                            radius: 20,
                          ),
                        )
                      ],
                    ),
                    Text(
                      "+ 20.000 confirmados",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorBlue.withOpacity(
                            0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Ionicons.calendar_outline,
                            color: colorBlue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sáb, Dezembro 20, 2023",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("18.00 - 23.00"),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorBlue.withOpacity(
                            0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Ionicons.ticket_outline,
                            color: colorBlue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "R\$ 450,00",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Preço do Ingresso"),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorBlue.withOpacity(
                            0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Ionicons.map_outline,
                            color: colorBlue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Centro, Caxias do Sul / RS",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Av. Bento Gonçalves 478 - Centro - Caxias do Sul / RS"),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage("https://i1.sndcdn.com/avatars-000635832897-vphyre-t500x500.jpg"),
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mundo da Música",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Organizador"),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        ),
                        child: Text(
                          "Ver Perfil",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: defaultPadding / 1.5,
                ),
                Text(
                  "Sobre o Evento",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ",
                ),
                SizedBox(
                  height: defaultPadding / 1.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Galeria (Pré-Evento)",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Ver Tudo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                montarGaleria(MediaQuery.of(context).size.width),
                SizedBox(
                  height: defaultPadding / 1.5,
                ),
                Text(
                  "Localização",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Ionicons.map_outline,
                      color: colorBlue,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        "Av. Bento Gonçalves 478 - Centro - Caxias do Sul / RS",
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget montarGaleria(double widthTela) {
    return Column(
      children: [
        Row(
          children: [
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
            SizedBox(
              width: 5,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
            SizedBox(
              width: 5,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
          ],
        ),
      ],
    );
  }

  Widget montarCardFoto(String link, double widthTela) {
    double widthCard = (widthTela - (10 + defaultPadding * 2)) / 3;
    return Container(
      height: widthCard,
      width: widthCard,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(224, 220, 220, 1),
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          link,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
