import 'dart:convert';
import 'dart:io';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/publicacao/publicacao_arquivo.dart';
import 'package:eventhub/services/arquivo/arquivo_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

class PublicacaoCadastroGaleria extends StatefulWidget {
  final Function(Arquivo) onUpload;
  final Function(int) onRemove;
  final List<PublicacaoArquivo> listaPublicacaoArquivo;

  const PublicacaoCadastroGaleria({
    super.key,
    required this.listaPublicacaoArquivo,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  State<PublicacaoCadastroGaleria> createState() => _PublicacaoCadastroGaleriaState();
}

class _PublicacaoCadastroGaleriaState extends State<PublicacaoCadastroGaleria> {
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        montarCardNovaFoto(),
        montarListaImagens(),
      ],
    );
  }

  Widget montarCardNovaFoto() {
    double widthCard = (MediaQuery.of(context).size.width - (10 + defaultPadding * 2)) / 3;
    return GestureDetector(
      onTap: () {
        showPickImage();
      },
      child: Container(
        height: widthCard,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(242, 242, 242, 1),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Ionicons.add,
              color: colorBlue,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Adicionar Mais Fotos",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(109, 117, 128, 1),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget montarListaImagens() {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.listaPublicacaoArquivo.length,
          itemBuilder: (context, index) {
            return index % 3 == 0
                ? Row(
                    children: [
                      montarCardImagem(index),
                      const SizedBox(
                        width: 15,
                      ),
                      (index + 1 <= widget.listaPublicacaoArquivo.length - 1 ? montarCardImagem(index + 1) : const SizedBox()),
                      const SizedBox(
                        width: 15,
                      ),
                      (index + 2 <= widget.listaPublicacaoArquivo.length - 1 ? montarCardImagem(index + 2) : const SizedBox()),
                    ],
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }

  Widget montarCardImagem(int index) {
    double widthCard = (MediaQuery.of(context).size.width - (30 + defaultPadding * 2)) / 3;
    return Container(
      height: widthCard,
      width: widthCard,
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(224, 220, 220, 1),
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              Util.montarURlFotoByArquivo(widget.listaPublicacaoArquivo[index].arquivo!),
              fit: BoxFit.cover,
              width: widthCard,
              height: widthCard,
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {
                widget.onRemove(index);
              },
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  showPickImage() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Ionicons.image,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Buscar imagem da galeria
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Ionicons.camera,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Fazer foto da câmera
                  pick(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void pick(ImageSource source) async {
    try {
      final pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        File file = File(pickedFile.path);

        List<int> bytes = file.readAsBytesSync();

        String base64String = base64Encode(bytes);
        // ignore: use_build_context_synchronously
        Util.showLoading(context);
        Arquivo arquivo = await ArquivoService().uploadArquivoBase64(base64String);

        widget.onUpload(arquivo);

        // ignore: use_build_context_synchronously
        Util.hideLoading(context);
      }
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }
}
