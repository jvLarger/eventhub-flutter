import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/presentation/views/perfil/publico/perfil_publico_page.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class CardPessoa extends StatelessWidget {
  final Usuario usuario;
  const CardPessoa({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Util.goTo(
          context,
          PerfilPublicoPage(
            idUsuario: usuario.id!,
          ),
        );
      },
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          Util.montarURlFotoByArquivo(usuario.foto),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        left: 0,
        right: 0,
        bottom: 5,
        top: 5,
      ),
      trailing: usuario.isAmigo != null && !usuario.isAmigo!
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              child: const Text("Adicionar"),
            )
          : null,
      title: Text(
        usuario.nomeCompleto!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
