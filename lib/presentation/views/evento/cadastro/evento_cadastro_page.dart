import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EventoCadastroPage extends StatefulWidget {
  const EventoCadastroPage({super.key});

  @override
  State<EventoCadastroPage> createState() => _EventoCadastroPageState();
}

class _EventoCadastroPageState extends State<EventoCadastroPage> {
  bool _isApenasConvidados = false;
  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: EventHubTopAppbar(
        title: "Dados do Evento",
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Ionicons.trash_outline,
              color: colorBlue,
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  EventHubTextFormField(
                    label: "Nome do Evento",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Data do Evento",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Data do Evento não informada!';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(
                      Ionicons.calendar,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Hora de Início",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hora de Início não informada!';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(
                      Ionicons.time,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Valor do Ingresso",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Valor do Ingresso não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Categorias",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Categorias não informadas!';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(
                      Ionicons.add_circle_outline,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
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
                  EventHubTextFormField(
                    label: "CEP",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CEP não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Cidade",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cidade não informada!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Estado",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estado não informada!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Logradouro (Ex: Av Pinheiro Machado)",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Logradouro não informada!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Bairro",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bairro não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Número",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Número não informado!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  EventHubTextFormField(
                    label: "Complemento",
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  montarGaleria(MediaQuery.of(context).size.width),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        checkColor: colorBlue,
                        value: _isApenasConvidados,
                        onChanged: (newValue) {
                          setState(() {
                            _isApenasConvidados = !_isApenasConvidados;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isApenasConvidados = !_isApenasConvidados;
                          });
                        },
                        child: const Text(
                          "Apenas Convidados",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Continuar"),
                      ],
                    ),
                  )
                ],
              ),
            )
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
            montarCardNovaFoto(widthTela),
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
          height: 10,
        ),
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
        )
      ],
    );
  }

  Widget montarCardNovaFoto(double widthTela) {
    double widthCard = (widthTela - (10 + defaultPadding * 2)) / 3;
    return Container(
      height: widthCard,
      width: widthCard,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(224, 220, 220, 1),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Icon(
          Ionicons.add_circle_outline,
          color: Color.fromRGBO(134, 131, 131, 1),
        ),
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
