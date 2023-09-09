import 'dart:convert';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/viacep/viacep.dart';
import 'package:eventhub/network/api.dart';
import 'package:eventhub/utils/util.dart';

class ViaCepService {
  Future<ViaCep> consultarCep(String cep) async {
    final response = await Api.consultarCep(cep);

    if (response.statusCode == 200) {
      ViaCep viaCep = ViaCep.fromJson(
        jsonDecode(
          utf8.decode(response.bodyBytes),
        ),
      );

      return viaCep;
    } else {
      throw EventHubException(Util.getMensagemErro(response));
    }
  }
}
