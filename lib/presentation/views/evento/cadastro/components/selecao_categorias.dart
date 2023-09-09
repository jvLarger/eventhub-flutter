import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/categoria/categoria.dart';
import 'package:eventhub/services/categoria/categoria_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class SelecaoCategoria extends StatefulWidget {
  final List<Categoria> listaCategoriasSelecionadas;
  const SelecaoCategoria({
    super.key,
    required this.listaCategoriasSelecionadas,
  });

  @override
  State<SelecaoCategoria> createState() => _SelecaoCategoriaState();
}

class _SelecaoCategoriaState extends State<SelecaoCategoria> {
  bool _isLoading = true;
  List<Categoria> _listaTodasCategorias = [];
  final Map<int, Categoria> _mapaCategoriasMarcadas = <int, Categoria>{};

  popularMapaCategoriasMarcadasInicialmente() {
    for (Categoria categoria in widget.listaCategoriasSelecionadas) {
      _mapaCategoriasMarcadas.putIfAbsent(categoria.id!, () => categoria);
    }

    setState(() {});
  }

  buscarTodasCategorias() async {
    try {
      _listaTodasCategorias = await CategoriaService().buscarTodasCategorias();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    popularMapaCategoriasMarcadasInicialmente();
    buscarTodasCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: MediaQuery.of(context).size.height / 100 * 75,
            padding: const EdgeInsets.all(defaultPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Categorias',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _listaTodasCategorias.length,
                    itemBuilder: (context, index) {
                      return getCardCategoria(_listaTodasCategorias[index]);
                    },
                  )
                ],
              ),
            ),
          );
  }

  Widget getCardCategoria(Categoria categoria) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: CheckboxListTile(
          title: Text(categoria.nome!),
          fillColor: MaterialStateColor.resolveWith((states) => colorBlue),
          shape: const CircleBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
          value: _mapaCategoriasMarcadas.containsKey(categoria.id!),
          onChanged: (bool? value) {
            if (value!) {
              _mapaCategoriasMarcadas.putIfAbsent(categoria.id!, () => categoria);
            } else {
              _mapaCategoriasMarcadas.remove(categoria.id!);
            }

            setState(() {});
          },
        ));
  }
}
