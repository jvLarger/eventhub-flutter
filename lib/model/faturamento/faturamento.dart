import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/utils/util.dart';

class Faturamento {
  int? id;
  Evento? evento;
  double? valorTotalIngressos;
  double? valorTotalTaxas;
  double? valorTotalFaturamento;
  DateTime? dataLiberacao;
  DateTime? dataPagamento;

  Faturamento({
    this.id,
    this.evento,
    this.valorTotalIngressos,
    this.valorTotalTaxas,
    this.valorTotalFaturamento,
    this.dataLiberacao,
    this.dataPagamento,
  });

  factory Faturamento.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Faturamento(
      id: jsons['id'],
      evento: jsons['evento'] != null ? Evento.fromJson(jsons['evento']) : null,
      valorTotalIngressos: jsons['valorTotalIngressos'],
      valorTotalTaxas: jsons['valorTotalTaxas'],
      valorTotalFaturamento: jsons['valorTotalFaturamento'],
      dataLiberacao: jsons['dataLiberacao'] != null ? DateTime.parse(jsons['dataLiberacao']) : null,
      dataPagamento: jsons['dataPagamento'] != null ? DateTime.parse(jsons['dataPagamento']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'evento': evento,
        'valorTotalIngressos': valorTotalIngressos,
        'valorTotalTaxas': valorTotalTaxas,
        'valorTotalFaturamento': valorTotalFaturamento,
        'dataLiberacao': dataLiberacao,
        'dataPagamento': dataPagamento,
      };
}
