import 'package:geolocator/geolocator.dart';

class EventhubSingleton {
  static final EventhubSingleton _singleton = EventhubSingleton._internal();

  factory EventhubSingleton() {
    return _singleton;
  }

  EventhubSingleton._internal();

  Position? positionUsuario;
  String? host;

  setPositionUsuario(Position position) {
    positionUsuario = position;
  }

  getPositionUsuario() {
    return positionUsuario;
  }

  setHost(String hostApi) {
    host = hostApi;
  }

  String getHost() {
    return host ?? "http://192.168.1.10:8080/api";
  }
}
