import 'package:eventhub/main.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_text_form_field.dart';
import 'package:eventhub/presentation/components/eventhub_top_appbar.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/singleton.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class IpConfigPage extends StatefulWidget {
  const IpConfigPage({super.key});

  @override
  State<IpConfigPage> createState() => _IpConfigPageState();
}

class _IpConfigPageState extends State<IpConfigPage> {
  final TextEditingController _hostController = TextEditingController();

  atualizarAmbiente() {
    EventhubSingleton().setHost(_hostController.text.trim());
    Util.showSnackbarInfo(context, "Informações alteradas com sucesso");
    Util.goToAndOverride(
      context,
      const EventHubApp(),
    );
  }

  @override
  void initState() {
    super.initState();
    _hostController.text = EventhubSingleton().getHost();
  }

  @override
  Widget build(BuildContext context) {
    return EventHubBody(
      topWidget: const EventHubTopAppbar(
        title: "Configurações de Ambiente",
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventHubTextFormField(
              label: "Host",
              controller: _hostController,
              prefixIcon: const Icon(
                Ionicons.git_network,
                size: 15,
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            ElevatedButton(
              onPressed: () {
                atualizarAmbiente();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Salvar"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
