import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/presentation/views/chat/salaprivada/sala_privada_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SalasBatePapoPage extends StatefulWidget {
  const SalasBatePapoPage({super.key});

  @override
  State<SalasBatePapoPage> createState() => _SalasBatePapoPageState();
}

class _SalasBatePapoPageState extends State<SalasBatePapoPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Bate Papo",
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            EventHubTextFormField(
              label: "Pesquise pelo nome",
              prefixIcon: const Icon(
                Ionicons.search,
                size: 15,
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            getParticipante("Tanner Stafford", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS23r-RPu2dhP9HrI3bUSdkZ3duFe7CVNJ49Q&usqp=CAU", "3 mensagens não lidas"),
            SizedBox(
              height: defaultPadding,
            ),
            getParticipante("Leatrice Handler", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWMsksaZD0YS_walS4Nk_P98cEdals3D_vVQ&usqp=CAU", null),
            SizedBox(
              height: defaultPadding,
            ),
            getParticipante("Chantal Shelburne", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0y7IMZdn0mMlGwIQ2o31Lo6jD6YGxfq6pWA&usqp=CAU", null),
            SizedBox(
              height: defaultPadding,
            ),
            getParticipante("Maryland Winkles", "https://cajamar.sp.gov.br/noticias/wp-content/uploads/sites/2/2021/07/site-vacinacao-33-anos.png", null),
          ],
        ),
      ),
    );
  }

  getParticipante(String nome, String caminhoImagem, String? subtitle) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(caminhoImagem),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      contentPadding: EdgeInsets.only(
        left: 0,
        right: 0,
        top: 0,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Util.goTo(context, SalaPrivadaPage());
      },
      title: Text(
        nome,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
