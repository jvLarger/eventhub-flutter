import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class InformacoesUsuario extends StatelessWidget {
  const InformacoesUsuario({
    super.key,
    required this.usuarioAutenticado,
  });

  final UsuarioAutenticado usuarioAutenticado;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: colorBlue,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bem-vindo!",
                  ),
                  Text(
                    usuarioAutenticado.nomeCompleto!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  )
                ],
              )
            ],
          ),
          GestureDetector(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color.fromRGBO(238, 238, 238, 1),
                  width: 1,
                ),
              ),
              child: const Icon(Icons.notifications_outlined),
            ),
          )
        ],
      ),
    );
  }
}
