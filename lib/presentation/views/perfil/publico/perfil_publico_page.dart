import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PerfilPublicoPage extends StatefulWidget {
  const PerfilPublicoPage({super.key});

  @override
  State<PerfilPublicoPage> createState() => _PerfilPublicoPageState();
}

class _PerfilPublicoPageState extends State<PerfilPublicoPage> with TickerProviderStateMixin {
  TabController? _tabController;
  int _indexTabAtiva = 0;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthTela = MediaQuery.of(context).size.width;
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "",
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage("https://cdn0.br.psicologia-online.com/pt/posts/3/6/5/5_caracteristicas_de_uma_pessoa_boa_563_orig.jpg"),
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(
              "Josilei Flores",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Divider(
              height: 1,
              color: Color.fromRGBO(221, 213, 213, 1),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: const Column(
                      children: [
                        Text(
                          "12",
                          style: TextStyle(
                            fontSize: 32,
                            color: Color.fromRGBO(33, 33, 33, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Text(
                          "Eventos",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(97, 97, 97, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 0.5,
                  color: const Color.fromRGBO(221, 213, 213, 1),
                ),
                const Expanded(
                  child: Column(
                    children: [
                      Text(
                        "421",
                        style: TextStyle(
                          fontSize: 32,
                          color: Color.fromRGBO(33, 33, 33, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Text(
                        "Amigos",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(97, 97, 97, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              height: 1,
              color: Color.fromRGBO(221, 213, 213, 1),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Ionicons.person_add,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Adicionar"),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Mensagem"),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Divider(
              height: 1,
              color: Color.fromRGBO(221, 213, 213, 1),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: colorBlue,
              labelStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'Urbanist',
              ),
              onTap: (value) {
                _indexTabAtiva = value;
                setState(() {});
              },
              tabs: const [
                Tab(
                  text: 'Publicações',
                ),
                Tab(
                  text: 'Comentários',
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 28,
              ),
              child: _indexTabAtiva == 0 ? montarPublicacoes(widthTela) : montarComentarios(),
            ),
          ],
        ),
      ),
    );
  }

  Widget montarComentarios() {
    return Column(
      children: [
        montarCardComentario("Cameron Williamson", "20 de dezembro de 2022", "Uma ótima pessoa!", "https://www.cnnbrasil.com.br/wp-content/uploads/sites/12/2022/01/272659509_640826040498160_305754906527072885_n-e1643549776803.jpg?w=876&h=484&crop=1"),
        SizedBox(
          height: defaultPadding,
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
      ],
    );
  }

  Widget montarCardComentario(String nome, String data, String comentario, String linkFoto) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(221, 213, 213, 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CircleAvatar(
              backgroundImage: NetworkImage(linkFoto),
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  data,
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.2,
                    color: Color.fromRGBO(109, 117, 128, 1),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  comentario,
                  style: TextStyle(
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

  Widget montarPublicacoes(double widthTela) {
    return Column(
      children: [
        Row(
          children: [
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
            SizedBox(
              width: 15,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
            SizedBox(
              width: 15,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
            SizedBox(
              width: 15,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
            SizedBox(
              width: 15,
            ),
            montarCardFoto("https://media.istockphoto.com/id/1183921035/pt/vetorial/rock-sign-gesture-with-lightning-for-your-design.jpg?s=612x612&w=0&k=20&c=S4qUMiqM8azNm2VR71YLXxLnaHEw8hWM3nlRw9pePM4=", widthTela),
          ],
        )
      ],
    );
  }

  Widget montarCardFoto(String link, double widthTela) {
    double widthCard = (widthTela - (30 + defaultPadding * 2)) / 3;
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
