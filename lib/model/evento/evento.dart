import 'package:eventhub/model/evento/evento_arquivo.dart';
import 'package:eventhub/model/evento/evento_categoria.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/model/usuario/usuario.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';

class Evento {
  int? id;
  Usuario? usuario;
  String? nome;
  DateTime? data;
  TimeOfDay? horaInicio;
  double? valor;
  String? descricao;
  String? cep;
  String? cidade;
  String? estado;
  String? logradouro;
  String? bairro;
  String? complemento;
  String? numero;
  double? latitude;
  double? longitude;
  bool? restrito;
  List<EventoArquivo>? arquivos;
  List<EventoCategoria>? categorias;
  String? dataEHoraFormatada;
  int? ingressosVendidos;
  List<Ingresso>? ultimosIngressoVendidos;
  bool? demonstreiInteresse;
  int? numeroMaximoIngressos;
  int? numeroVisualizacoes;
  bool? visivel;

  Evento({
    this.id,
    this.usuario,
    this.nome,
    this.data,
    this.horaInicio,
    this.valor,
    this.descricao,
    this.cep,
    this.cidade,
    this.estado,
    this.logradouro,
    this.bairro,
    this.complemento,
    this.numero,
    this.latitude,
    this.longitude,
    this.restrito,
    this.arquivos,
    this.categorias,
    this.dataEHoraFormatada,
    this.ingressosVendidos,
    this.ultimosIngressoVendidos,
    this.demonstreiInteresse,
    this.numeroMaximoIngressos,
    this.numeroVisualizacoes,
    this.visivel,
  });

  factory Evento.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);

    List<EventoArquivo> arquivos = List.empty();

    if (jsons['arquivos'] != null) {
      arquivos = (jsons['arquivos'] as List).map((model) => EventoArquivo.fromJson(model)).toList();
    }

    List<EventoCategoria> categorias = List.empty();

    if (jsons['categorias'] != null) {
      categorias = (jsons['categorias'] as List).map((model) => EventoCategoria.fromJson(model)).toList();
    }

    List<Ingresso> ultimosIngressoVendidos = List.empty();

    if (jsons['ultimosIngressoVendidos'] != null) {
      ultimosIngressoVendidos = (jsons['ultimosIngressoVendidos'] as List).map((model) => Ingresso.fromJson(model)).toList();
    }

    return Evento(
      id: jsons['id'],
      usuario: jsons['usuario'] != null ? Usuario.fromJson(jsons['usuario']) : null,
      nome: jsons['nome'],
      data: jsons['data'] != null ? DateTime.parse(jsons['data']) : null,
      horaInicio: jsons['horaInicio'] != null ? Util.parseStringToTimeOfDay(jsons['horaInicio']) : null,
      valor: jsons['valor'],
      descricao: jsons['descricao'],
      cep: jsons['cep'],
      cidade: jsons['cidade'],
      estado: jsons['estado'],
      logradouro: jsons['logradouro'],
      bairro: jsons['bairro'],
      complemento: jsons['complemento'],
      numero: jsons['numero'],
      latitude: jsons['latitude'],
      longitude: jsons['longitude'],
      restrito: jsons['restrito'],
      arquivos: arquivos,
      categorias: categorias,
      ultimosIngressoVendidos: ultimosIngressoVendidos,
      ingressosVendidos: jsons['ingressosVendidos'],
      dataEHoraFormatada: jsons['dataEHoraFormatada'],
      demonstreiInteresse: jsons['demonstreiInteresse'],
      numeroMaximoIngressos: jsons['numeroMaximoIngressos'],
      numeroVisualizacoes: jsons['numeroVisualizacoes'],
      visivel: jsons['visivel'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuario': usuario,
        'nome': nome,
        'data': Util.formatarDataApiEng(data),
        'horaInicio': Util.formatarHoraApi(horaInicio),
        'valor': valor,
        'descricao': descricao,
        'cep': cep,
        'cidade': cidade,
        'estado': estado,
        'logradouro': logradouro,
        'bairro': bairro,
        'complemento': complemento,
        'numero': numero,
        'latitude': latitude,
        'longitude': longitude,
        'restrito': restrito,
        'arquivos': arquivos,
        'categorias': categorias,
        'dataEHoraFormatada': dataEHoraFormatada,
        'ingressosVendidos': ingressosVendidos,
        'ultimosIngressoVendidos': ultimosIngressoVendidos,
        'demonstreiInteresse': demonstreiInteresse,
        'numeroMaximoIngressos': numeroMaximoIngressos,
        'numeroVisualizacoes': numeroVisualizacoes,
        'visivel': visivel,
      };
}
