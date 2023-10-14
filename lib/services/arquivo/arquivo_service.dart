import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class ArquivoService {
  Future<Arquivo> uploadArquivoBase64(String base64) async {
    final response = await Api().uploadFile(base64);
    if (response.statusCode == 201) {
      Arquivo arquivo = Arquivo.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return arquivo;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
