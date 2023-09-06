import 'package:eventhub/utils/util.dart';

class Evento {
  int? id;
  Evento({this.id});

  factory Evento.fromJson(Map<String, dynamic> jsons) {
    jsons = Util.getJsonWithValues(jsons);
    return Evento();
  }

  Map<String, dynamic> toJson() => {};
}
