import 'package:eventhub/utils/util.dart';

class Pagamento {
  String? numero;
  String? nomeTitular;
  String? documentoPrincipal;
  String? validade;
  String? cvv;
  String? tipoCartao;

  Pagamento({
    this.numero,
    this.nomeTitular,
    this.documentoPrincipal,
    this.validade,
    this.cvv,
    this.tipoCartao,
  });

  factory Pagamento.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Pagamento(
      numero: jsons['numero'],
      nomeTitular: jsons['nomeTitular'],
      documentoPrincipal: jsons['documentoPrincipal'],
      validade: jsons['validade'],
      cvv: jsons['cvv'],
      tipoCartao: jsons['tipoCartao'],
    );
  }

  Map<String, dynamic> toJson() => {
        'numero': numero,
        'nomeTitular': nomeTitular,
        'documentoPrincipal': documentoPrincipal,
        'validade': validade,
        'cvv': cvv,
        'tipoCartao': tipoCartao,
      };
}
