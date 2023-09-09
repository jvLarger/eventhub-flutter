import 'package:eventhub/utils/util.dart';

class ViaCep {
  String? cep;
  String? logradouro;
  String? complemento;
  String? bairro;
  String? localidade;
  String? uf;
  String? ibge;
  String? gia;
  String? ddd;
  String? siafi;
  bool? erro;

  ViaCep({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
    this.erro,
  });

  factory ViaCep.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return ViaCep(
      cep: jsons['cep'],
      logradouro: jsons['logradouro'],
      complemento: jsons['complemento'],
      bairro: jsons['bairro'],
      localidade: jsons['localidade'],
      uf: jsons['uf'],
      ibge: jsons['ibge'],
      gia: jsons['gia'],
      ddd: jsons['ddd'],
      siafi: jsons['siafi'],
      erro: jsons['erro'] == 'true',
    );
  }

  Map<String, dynamic> toJson() => {
        'cep': cep,
        'logradouro': logradouro,
        'complemento': complemento,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
        'ibge': ibge,
        'gia': gia,
        'ddd': ddd,
        'siafi': siafi,
        'erro': erro,
      };
}
