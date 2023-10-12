import 'dart:async';

import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/evento/feed_evento.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/views/evento/visualizacao/evento_visualizacao_page.dart';
import 'package:eventhub/services/evento/evento_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/singleton.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

class MapaCalorPage extends StatefulWidget {
  final UsuarioAutenticado usuarioAutenticado;
  const MapaCalorPage({
    super.key,
    required this.usuarioAutenticado,
  });

  @override
  State<MapaCalorPage> createState() => _MapaCalorPageState();
}

class _MapaCalorPageState extends State<MapaCalorPage> {
  Position? _position;
  bool _isLoading = true;
  List<Evento> _listaEventos = [];
  CameraPosition? _kLake;
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor markerBlue = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconMinhaLocalizacao = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerRed = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerOrange = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerYellow = BitmapDescriptor.defaultMarker;

  getLocalInicial() {
    return CameraPosition(
      target: LatLng(
        _position!.latitude,
        _position!.longitude,
      ),
      zoom: 13.5,
    );
  }

  getCoordenadasGeograficas() async {
    if (EventhubSingleton().getPositionUsuario() == null) {
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition();

      EventhubSingleton().setPositionUsuario(position);
    }

    _position = EventhubSingleton().getPositionUsuario();
  }

  buscarConfiguracoesIniciais() async {
    await getCoordenadasGeograficas();

    try {
      _listaEventos = await EventoService().buscarMapaCalor(_position!.latitude, _position!.longitude);
      setState(() {
        _isLoading = false;
        _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(
            _position!.latitude,
            _position!.longitude,
          ),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414,
        );
      });
    } on EventHubException catch (err) {
      // ignore: use_build_context_synchronously
      Util.showSnackbarError(context, err.cause);
    }
  }

  Marker montarMarkerMeuLocal() {
    return Marker(
      position: LatLng(
        _position!.latitude,
        _position!.longitude,
      ),
      icon: markerIconMinhaLocalizacao,
      infoWindow: const InfoWindow(
        title: "Minha Localização",
      ),
      markerId: const MarkerId("minha_localizacao"),
    );
  }

  getLocais() {
    List<Marker> listaMarcadores = [];

    listaMarcadores.add(montarMarkerMeuLocal());

    for (Evento evento in _listaEventos) {
      Marker marker = Marker(
        position: LatLng(
          evento.latitude!,
          evento.longitude!,
        ),
        icon: getMarker(evento.grupoRelevancia!),
        infoWindow: InfoWindow(
            title: evento.nome!,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getCard(evento),
                      ],
                    ),
                  );
                },
              );
            }),
        markerId: MarkerId(evento.id.toString()),
      );

      listaMarcadores.add(marker);
    }
    return listaMarcadores.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8),
            ),
            Text(
              'Mapa dos Eventos',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Eventos próximos a minha localização",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: getLocalInicial(),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.setMapStyle("""[
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]""");
              },
              markers: getLocais(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorBlue,
        onPressed: _goToTheLake,
        label: const Text('Minha Localização'),
        icon: const Icon(Icons.home),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_kLake!),
    );
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/marker_evento.png",
    ).then(
      (icon) {
        setState(() {
          markerBlue = icon;
        });
      },
    );

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/pin_orange.png",
    ).then(
      (icon) {
        setState(() {
          markerOrange = icon;
        });
      },
    );

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/pin_red.png",
    ).then(
      (icon) {
        setState(() {
          markerRed = icon;
        });
      },
    );

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/pin_yellow.png",
    ).then(
      (icon) {
        setState(() {
          markerYellow = icon;
        });
      },
    );

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/marker_minha_localizacao.png",
    ).then(
      (icon) {
        setState(() {
          markerIconMinhaLocalizacao = icon;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    buscarConfiguracoesIniciais();
    addCustomIcon();
  }

  getCard(Evento evento) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 60.0,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(
              0,
              4,
            ),
            spreadRadius: 4,
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    Util.montarURlFotoByArquivo(evento.arquivos![0].arquivo),
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Text(
                            evento.nome!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      evento.dataEHoraFormatada!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: colorBlue,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Row(
                            children: [
                              const Icon(
                                Ionicons.map_outline,
                                color: colorBlue,
                                size: 14,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "${evento.bairro!}, ${evento.cidade!} / ${evento.estado!}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onPressed: () {
                    Util.goTo(
                      context,
                      EventoVisualizacaoPage(
                        idEvento: evento.id!,
                        isGoBackDefault: true,
                        usuarioAutenticado: widget.usuarioAutenticado,
                      ),
                    );
                  },
                  child: const Text("Ver Evento"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  BitmapDescriptor getMarker(int grupo) {
    if (grupo == 1) {
      return markerRed;
    } else if (grupo == 2) {
      return markerOrange;
    } else if (grupo == 3) {
      return markerYellow;
    } else {
      return markerBlue;
    }
  }
}
