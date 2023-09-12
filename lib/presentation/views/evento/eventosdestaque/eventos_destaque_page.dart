import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottombar.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/views/evento/eventosdestaque/components/informacoes_usuario.dart';
import 'package:eventhub/presentation/views/evento/pesquisa/eventos_pesquisa_page.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EventosDestaquePage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const EventosDestaquePage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<EventosDestaquePage> createState() => _EventosDestaquePageState();
}

class _EventosDestaquePageState extends State<EventosDestaquePage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      bottomNavigationBar: EventHubBottomBar(
        indexRecursoAtivo: 0,
        usuarioAutenticado: widget.usuarioAutenticado,
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InformacoesUsuario(
              usuarioAutenticado: widget.usuarioAutenticado,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            EventHubTextFormField(
              readOnly: true,
              onTap: () {
                Util.goTo(
                  context,
                  EventosPesquisaPage(
                    usuarioAutenticado: widget.usuarioAutenticado,
                  ),
                );
              },
              label: "Qual tipo de evento você está procurando?",
              prefixIcon: Icon(
                Ionicons.search,
                size: 15,
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Meus amigos gostaram",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Mapa de Calor",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colorBlue,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: defaultPadding / 2,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  getCardEvento(
                    300,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  getCardEvento(
                    300,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  getCardEvento(
                    300,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  getCardEvento(
                    300,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              "Eventos Populares",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: defaultPadding / 2,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  EventHubBadge(
                    color: colorBlue,
                    label: "Todas Categorias",
                    fontSize: 13,
                    filled: true,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  EventHubBadge(
                    color: colorBlue,
                    label: "Músicas",
                    fontSize: 13,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  EventHubBadge(
                    color: colorBlue,
                    label: "Fantasia",
                    fontSize: 13,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  EventHubBadge(
                    color: colorBlue,
                    label: "Negócios",
                    fontSize: 13,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  EventHubBadge(
                    color: colorBlue,
                    label: "Pijama",
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding / 2,
            ),
            Row(
              children: [
                Expanded(
                  child: getCardEvento(null),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: getCardEvento(null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getCardEvento(double? width) {
    return Container(
      width: width ?? double.maxFinite,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 60.0,
            color: Colors.black.withOpacity(0.01),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              "https://images.unsplash.com/photo-1565035010268-a3816f98589a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=388&q=80",
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: 160,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "DJ & Music Concert Concert Concert",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: width == null ? 15 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Qui, Dez 30 • 18.00 - 22.00",
            style: TextStyle(
              fontSize: width == null ? 12 : 16,
              color: colorBlue,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Icon(
                      Ionicons.map_outline,
                      color: colorBlue,
                      size: 14,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        "Centro, Caxias do Sul RS",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: width == null ? 12 : 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Ionicons.heart_outline,
                    color: colorBlue,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
