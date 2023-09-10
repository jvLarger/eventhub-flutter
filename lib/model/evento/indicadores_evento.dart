import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/faturamento/faturamento.dart';
import 'package:eventhub/utils/util.dart';

class IndicadoresEvento {
  Evento? evento;
  Faturamento? faturamento;
  int? ingressosVendidos;

  IndicadoresEvento({
    this.evento,
    this.faturamento,
    this.ingressosVendidos,
  });

  factory IndicadoresEvento.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return IndicadoresEvento(
      evento: jsons['evento'] != null ? Evento.fromJson(jsons['evento']) : null,
      faturamento: jsons['faturamento'] != null ? Faturamento.fromJson(jsons['faturamento']) : null,
      ingressosVendidos: jsons['ingressosVendidos'],
    );
  }

  Map<String, dynamic> toJson() => {
        'evento': evento,
        'faturamento': faturamento,
        'ingressosVendidos': ingressosVendidos,
      };
}
