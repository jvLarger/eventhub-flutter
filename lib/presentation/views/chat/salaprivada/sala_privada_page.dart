import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SalaPrivadaPage extends StatefulWidget {
  const SalaPrivadaPage({super.key});

  @override
  State<SalaPrivadaPage> createState() => _SalaPrivadaPageState();
}

class _SalaPrivadaPageState extends State<SalaPrivadaPage> {
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      appBar: AppBar(
        title: Text("Ashley Silva"),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(245, 245, 245, 1),
            ),
          ),
        ),
        padding: const EdgeInsets.all(defaultPadding),
        child: EventHubTextFormField(
          label: "Escreva alguma mensagem...",
          suffixIcon: IconButton(
            icon: Icon(
              Ionicons.send,
              color: colorBlue,
              size: 15,
            ),
            onPressed: () {},
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            getMensagemRecebida(),
            getMensagemEnviada(),
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
                  getContainerMensagemRecebida("Oii, tudo bem?", "10:00"),
                  getContainerMensagemRecebida("Você vai ir no show hoje a noite? Mal posso esperar!", "10:00"),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget getMensagemEnviada() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                children: [
                  getContainerMensagemEnviada("Simm, vou ir!", "10:00"),
                  getContainerMensagemEnviada("Mal posso esperar!", "10:00"),
                ],
              ),
            )
          ],
        )
      ],
    );
    ;
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

  Widget getContainerMensagemEnviada(String mensagem, String hora) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
          color: colorBlue.withOpacity(0.8),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            topLeft: Radius.circular(12),
          )),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Text(
              mensagem,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
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
                    color: Colors.white,
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
