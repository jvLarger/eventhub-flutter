import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PublicacaoCadastroPage extends StatefulWidget {
  const PublicacaoCadastroPage({super.key});

  @override
  State<PublicacaoCadastroPage> createState() => _PublicacaoCadastroPageState();
}

class _PublicacaoCadastroPageState extends State<PublicacaoCadastroPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: EventHubTopAppbar(
        title: "Nova Publicação",
      ),
      bottomNavigationBar: EventHubBottomButton(
        label: "Publicar",
        onTap: () {},
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  EventHubTextFormField(
                    label: "Descrição",
                    minLines: 4,
                    maxLines: 40,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Descrição não informada!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  montarGaleria(MediaQuery.of(context).size.width),
                ],
              ),
            ),
          ],
        ),
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
        SizedBox(
          height: 15,
        ),
        montarCardNovaFoto(widthTela),
      ],
    );
  }

  Widget montarCardNovaFoto(double widthTela) {
    double widthCard = (widthTela - (10 + defaultPadding * 2)) / 3;
    return Container(
      height: widthCard,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(242, 242, 242, 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Ionicons.add,
            color: colorBlue,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Adicionar Mais Fotos",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(109, 117, 128, 1),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
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
