import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/categoria/categoria.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class CategoriaService {
  Future<List<Categoria>> buscarTodasCategorias() async {
    final response = await Api.buscarTodasCategorias();

    if (response.statusCode == 200) {
      return (jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List)
          .map((model) => Categoria.fromJson(model))
          .toList();
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
