import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class IngressoSevice {
  Future<Ingresso> comprarIngresso(Ingresso ingresso) async {
    final response = await Api.comprarIngresso(ingresso);

    if (response.statusCode == 201) {
      Ingresso evento = Ingresso.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return evento;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}