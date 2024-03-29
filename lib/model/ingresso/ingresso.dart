import 'package:eventhub/model/arquivo/arquivo.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/pagamento/pagamento.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';

class Ingresso {
  int? id;
  Evento? evento;
  String? email;
  String? nome;
  String? documentoPrincipal;
  String? telefone;
  DateTime? dataComemorativa;
  double? valorTotalIngresso;
  double? valorTaxa;
  double? valorFaturamento;
  String? identificadorTransacaoPagamento;
  Usuario? usuario;
  Pagamento? pagamento;
  Arquivo? qrcode;
  DateTime? dataUtilizacao;
  String? identificadorIngresso;

  Ingresso({
    this.id,
    this.evento,
    this.email,
    this.nome,
    this.documentoPrincipal,
    this.telefone,
    this.dataComemorativa,
    this.valorTotalIngresso,
    this.valorTaxa,
    this.valorFaturamento,
    this.identificadorTransacaoPagamento,
    this.usuario,
    this.pagamento,
    this.qrcode,
    this.dataUtilizacao,
    this.identificadorIngresso,
  });

  factory Ingresso.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Ingresso(
      id: jsons['id'],
      evento: jsons['evento'] != null ? Evento.fromJson(jsons['evento']) : null,
      email: jsons['email'],
      nome: jsons['nome'],
      documentoPrincipal: jsons['documentoPrincipal'],
      telefone: jsons['telefone'],
      dataComemorativa: jsons['dataComemorativa'] != null ? DateTime.parse(jsons['dataComemorativa']) : null,
      valorTotalIngresso: jsons['valorTotalIngresso'],
      valorTaxa: jsons['valorTaxa'],
      valorFaturamento: jsons['valorFaturamento'],
      identificadorTransacaoPagamento: jsons['identificadorTransacaoPagamento'],
      usuario: jsons['usuario'] != null ? Usuario.fromJson(jsons['usuario']) : null,
      pagamento: jsons['pagamento'] != null ? Pagamento.fromJson(jsons['pagamento']) : null,
      qrcode: jsons['qrcode'] != null ? Arquivo.fromJson(jsons['qrcode']) : null,
      dataUtilizacao: jsons['dataUtilizacao'] != null ? DateTime.parse(jsons['dataUtilizacao']) : null,
      identificadorIngresso: jsons['identificadorIngresso'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'evento': evento,
        'email': email,
        'nome': nome,
        'documentoPrincipal': documentoPrincipal,
        'telefone': telefone,
        'dataComemorativa': Util.formatarDataApiEng(dataComemorativa),
        'valorTotalIngresso': valorTotalIngresso,
        'valorTaxa': valorTaxa,
        'valorFaturamento': valorFaturamento,
        'identificadorTransacaoPagamento': identificadorTransacaoPagamento,
        'usuario': usuario,
        'pagamento': pagamento,
        'dataUtilizacao': dataUtilizacao,
        'identificadorIngresso': identificadorIngresso,
      };
}
