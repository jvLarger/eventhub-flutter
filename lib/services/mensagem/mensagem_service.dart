import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/sala/sala_bate_papo.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class MensagemService {
  Future<List<SalaBatePapo>> buscarSalasBatePapo() async {
    final response = await Api.buscarSalasBatePapo();

    if (response.statusCode == 200) {
      return (jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as List)
          .map((model) => SalaBatePapo.fromJson(model))
          .toList();
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
