import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class EncontrarPessoasPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const EncontrarPessoasPage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<EncontrarPessoasPage> createState() => _EncontrarPessoasPageState();
}

class _EncontrarPessoasPageState extends State<EncontrarPessoasPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      bottomNavigationBar: EventHubBottomBar(
        indexRecursoAtivo: 2,
        usuarioAutenticado: widget.usuarioAutenticado,
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/logo_eventhub.svg",
                  width: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Usuários",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            EventHubTextFormField(
              label: "Pesquise por alguém",
              prefixIcon: const Icon(
                Ionicons.search,
                size: 15,
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            getParticipante("Tanner Stafford", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS23r-RPu2dhP9HrI3bUSdkZ3duFe7CVNJ49Q&usqp=CAU", false),
            getParticipante("Leatrice Handler", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWMsksaZD0YS_walS4Nk_P98cEdals3D_vVQ&usqp=CAU", false),
            getParticipante("Chantal Shelburne", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0y7IMZdn0mMlGwIQ2o31Lo6jD6YGxfq6pWA&usqp=CAU", true),
            getParticipante("Maryland Winkles", "https://cajamar.sp.gov.br/noticias/wp-content/uploads/sites/2/2021/07/site-vacinacao-33-anos.png", true),
          ],
        ),
      ),
    );
  }

  getParticipante(String nome, String caminhoImagem, bool isAdicionar) {
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
      trailing: isAdicionar
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              child: Text("Adicionar"),
            )
          : null,
      title: Text(
        nome,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
