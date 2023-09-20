import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/utils/util.dart';

class FeedEvento {
  List<Evento>? eventosQueMeusAmigosGostaram;
  List<Evento>? eventosPopulares;

  FeedEvento({
    this.eventosQueMeusAmigosGostaram,
    this.eventosPopulares,
  });

  factory FeedEvento.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);

    List<Evento> eventosQueMeusAmigosGostaram = List.empty();

    if (jsons['eventosQueMeusAmigosGostaram'] != null) {
      eventosQueMeusAmigosGostaram = (jsons['eventosQueMeusAmigosGostaram'] as List).map((model) => Evento.fromJson(model)).toList();
    }

    List<Evento> eventosPopulares = List.empty();

    if (jsons['eventosPopulares'] != null) {
      eventosPopulares = (jsons['eventosPopulares'] as List).map((model) => Evento.fromJson(model)).toList();
    }
    return FeedEvento(
      eventosQueMeusAmigosGostaram: eventosQueMeusAmigosGostaram,
      eventosPopulares: eventosPopulares,
    );
  }

  Map<String, dynamic> toJson() => {
        'eventosQueMeusAmigosGostaram': eventosQueMeusAmigosGostaram,
        'eventosPopulares': eventosPopulares,
      };
}
