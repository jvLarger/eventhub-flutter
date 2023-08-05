import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EventoIndicadoresParticipantesPage extends StatefulWidget {
  const EventoIndicadoresParticipantesPage({super.key});

  @override
  State<EventoIndicadoresParticipantesPage> createState() => _EventoIndicadoresParticipantesPageState();
}

class _EventoIndicadoresParticipantesPageState extends State<EventoIndicadoresParticipantesPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Lista de Participantes",
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
            getParticipante("Tanner Stafford", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS23r-RPu2dhP9HrI3bUSdkZ3duFe7CVNJ49Q&usqp=CAU"),
            getParticipante("Leatrice Handler", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWMsksaZD0YS_walS4Nk_P98cEdals3D_vVQ&usqp=CAU"),
            getParticipante("Chantal Shelburne", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0y7IMZdn0mMlGwIQ2o31Lo6jD6YGxfq6pWA&usqp=CAU"),
            getParticipante("Maryland Winkles", "https://cajamar.sp.gov.br/noticias/wp-content/uploads/sites/2/2021/07/site-vacinacao-33-anos.png"),
          ],
        ),
      ),
    );
  }

  getParticipante(String nome, String caminhoImagem) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(caminhoImagem),
      ),
      contentPadding: EdgeInsets.only(
        left: 0,
        right: 0,
        bottom: defaultPadding,
        top: 0,
      ),
      title: Text(
        nome,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
