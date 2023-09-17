import 'package:geolocator/geolocator.dart';

class EventhubSingleton {
  static final EventhubSingleton _singleton = EventhubSingleton._internal();

  factory EventhubSingleton() {
    return _singleton;
  }

  EventhubSingleton._internal();

  Position? positionUsuario;

  setPositionUsuario(Position position) {
    positionUsuario = position;
  }

  getPositionUsuario() {
    return positionUsuario;
  }
}
