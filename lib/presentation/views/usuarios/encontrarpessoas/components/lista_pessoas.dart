import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/presentation/views/usuarios/encontrarpessoas/components/card_pessoa.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListaPessoas extends StatelessWidget {
  final List<Usuario> listaUsuario;
  final Function(Usuario, int) enviarSolicitacaoAmizade;
  const ListaPessoas({
    super.key,
    required this.enviarSolicitacaoAmizade,
    required this.listaUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return listaUsuario.isEmpty
        ? Column(
            children: [
              const SizedBox(
                height: defaultPadding,
              ),
              SvgPicture.asset(
                "assets/images/empty.svg",
                width: 250,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text(
                "Nada Encontrado",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Desculpe, o filtro que você informou não pode ser encontrando. Por favor, verifique novamente o conteúdo informado e tente novamente.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: listaUsuario.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: listaUsuario.length - 1 == index ? 0 : defaultPadding),
                child: CardPessoa(
                  index: index,
                  enviarSolicitacaoAmizade: enviarSolicitacaoAmizade,
                  usuario: listaUsuario[index],
                ),
              );
            },
          );
  }
}
