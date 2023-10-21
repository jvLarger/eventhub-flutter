import 'package:eventhub/model/faturamento/faturamento.dart';
import 'package:eventhub/utils/util.dart';

class FaturamentoPagamento {
  double? valorTotalIngressos;
  double? valorTotalTaxas;
  double? valorTotalFaturado;
  double? valorTotalIngressosFuturo;
  double? valorTotalTaxasFuturo;
  double? valorTotalFaturadoFuturo;
  String? email;
  String? account;
  bool? payoutsEnabled;
  String? linkConnectStripe;
  List<Faturamento>? proximosFaturamentos;
  List<Faturamento>? faturamentosLiberados;
  List<Faturamento>? faturamentosPagos;

  FaturamentoPagamento({
    this.valorTotalIngressos,
    this.valorTotalTaxas,
    this.valorTotalFaturado,
    this.valorTotalIngressosFuturo,
    this.valorTotalTaxasFuturo,
    this.valorTotalFaturadoFuturo,
    this.email,
    this.account,
    this.payoutsEnabled,
    this.linkConnectStripe,
    this.proximosFaturamentos,
    this.faturamentosLiberados,
    this.faturamentosPagos,
  });

  factory FaturamentoPagamento.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);

    List<Faturamento> proximosFaturamentos = List.empty();

    if (jsons['proximosFaturamentos'] != null) {
      proximosFaturamentos = (jsons['proximosFaturamentos'] as List).map((model) => Faturamento.fromJson(model)).toList();
    }

    List<Faturamento> faturamentosLiberados = List.empty();

    if (jsons['faturamentosLiberados'] != null) {
      faturamentosLiberados = (jsons['faturamentosLiberados'] as List).map((model) => Faturamento.fromJson(model)).toList();
    }

    List<Faturamento> faturamentosPagos = List.empty();

    if (jsons['faturamentosPagos'] != null) {
      faturamentosPagos = (jsons['faturamentosPagos'] as List).map((model) => Faturamento.fromJson(model)).toList();
    }

    return FaturamentoPagamento(
      valorTotalIngressos: jsons['valorTotalIngressos'],
      valorTotalTaxas: jsons['valorTotalTaxas'],
      valorTotalFaturado: jsons['valorTotalFaturado'],
      valorTotalIngressosFuturo: jsons['valorTotalIngressosFuturo'],
      valorTotalTaxasFuturo: jsons['valorTotalTaxasFuturo'],
      valorTotalFaturadoFuturo: jsons['valorTotalFaturadoFuturo'],
      email: jsons['email'],
      account: jsons['account'],
      payoutsEnabled: jsons['payoutsEnabled'],
      linkConnectStripe: jsons['linkConnectStripe'],
      proximosFaturamentos: proximosFaturamentos,
      faturamentosLiberados: faturamentosLiberados,
      faturamentosPagos: faturamentosPagos,
    );
  }

  Map<String, dynamic> toJson() => {
        'valorTotalIngressos': valorTotalIngressos,
        'valorTotalTaxas': valorTotalTaxas,
        'valorTotalFaturado': valorTotalFaturado,
        'valorTotalIngressosFuturo': valorTotalIngressosFuturo,
        'valorTotalTaxasFuturo': valorTotalTaxasFuturo,
        'valorTotalFaturadoFuturo': valorTotalFaturadoFuturo,
        'email': email,
        'account': account,
        'payoutsEnabled': payoutsEnabled,
        'linkConnectStripe': linkConnectStripe,
        'proximosFaturamentos': proximosFaturamentos,
        'faturamentosLiberados': faturamentosLiberados,
        'faturamentosPagos': faturamentosPagos,
      };
}
