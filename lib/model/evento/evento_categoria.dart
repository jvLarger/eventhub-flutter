import 'package:eventhub/model/categoria/categoria.dart';
import 'package:eventhub/utils/util.dart';

class EventoCategoria {
  int? id;
  Categoria? categoria;

  EventoCategoria({
    this.id,
    this.categoria,
  });

  factory EventoCategoria.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return EventoCategoria(
      id: jsons['id'],
      categoria: jsons['categoria'] != null ? Categoria.fromJson(jsons['categoria']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoria': categoria,
      };
}
