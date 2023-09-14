import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventhub/config/exceptions/eventhub_exception.dart';
import 'package:eventhub/model/evento/evento.dart';
import 'package:eventhub/model/evento/evento_arquivo.dart';
import 'package:eventhub/model/ingresso/ingresso.dart';
import 'package:eventhub/model/usuario/usuario_autenticado.dart';
import 'package:eventhub/presentation/components/eventhub_badge.dart';
import 'package:eventhub/presentation/components/eventhub_body.dart';
import 'package:eventhub/presentation/components/eventhub_bottom_button.dart';
import 'package:eventhub/presentation/views/evento/pesquisa/eventos_pesquisa_page.dart';
import 'package:eventhub/presentation/views/ingresso/compra/titular/titular_ingresso_page.dart';
import 'package:eventhub/presentation/views/perfil/publico/perfil_publico_page.dart';
import 'package:eventhub/services/evento/evento_service.dart';
import 'package:eventhub/utils/constants.dart';
import 'package:eventhub/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

class EventoVisualizacaoPage extends StatefulWidget {
  final int idEvento;
  final UsuarioAutenticado usuarioAutenticado;
  const EventoVisualizacaoPage({
    super.key,
    required this.idEvento,
    required this.usuarioAutenticado,
  });

  @override
  State<EventoVisualizacaoPage> createState() => _EventoVisualizacaoPageState();
}

class _EventoVisualizacaoPageState extends State<EventoVisualizacaoPage> {
  bool _isLoading = true;
  Evento _evento = Evento();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(1, 1),
    zoom: 14.4746,
  );

  void removerInteresse() async {
    try {
      Util.showLoading(context);

      await EventoService().removerInteresse(_evento.id!);
      _evento.demonstreiInteresse = false;
      setState(() {});
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  void demonstrarInteresse() async {
    try {
      Util.showLoading(context);

      await EventoService().demonstrarInteresse(_evento.id!);
      _evento.demonstreiInteresse = true;
      setState(() {});
      // ignore: use_build_context_synchronously
      Util.hideLoading(context);
    } on EventHubException catch (err) {
      Util.hideLoading(context);
      Util.showSnackbarError(context, err.cause);
    }
  }

  buscarEvento() async {
    try {
      Evento evento = await EventoService().buscarEvento(widget.idEvento);

      _kGooglePlex = CameraPosition(
        target: LatLng(evento.latitude!, evento.longitude!),
        zoom: 20,
      );

      Marker marker1 = Marker(
        markerId: const MarkerId('place_name1'),
        position: LatLng(evento.latitude!, evento.longitude!),
      );

      markers[const MarkerId('place_name1')] = marker1;

      if (mounted) {
        setState(() {
          _evento = evento;
          _isLoading = false;
        });
      }
    } on EventHubException catch (err) {
      Util.showSnackbarError(context, err.cause);
    }
  }

  @override
  void initState() {
    super.initState();
    buscarEvento();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              Util.goToAndOverride(
                context,
                EventosPesquisaPage(
                  usuarioAutenticado: widget.usuarioAutenticado,
                ),
              );
              return false;
            },
            child: EventHubBody(
              bottomNavigationBar: EventHubBottomButton(
                label: "Comprar Ingresso",
                onTap: () {
                  Util.goTo(context, const TitularIngressoPage());
                },
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CarouselSlider(
                        items: getImagensSliders(),
                        options: CarouselOptions(
                          height: 260.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: const Duration(milliseconds: 5000),
                          viewportFraction: 0.8,
                        ),
                      ),
                      const Positioned(
                        top: defaultPadding,
                        left: defaultPadding / 2,
                        child: BackButton(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _evento.nome!,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                _evento.demonstreiInteresse!
                                    ? IconButton(
                                        onPressed: () {
                                          removerInteresse();
                                        },
                                        icon: const Icon(
                                          Ionicons.heart,
                                          color: colorBlue,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          demonstrarInteresse();
                                        },
                                        icon: const Icon(
                                          Ionicons.heart_outline,
                                          color: colorBlue,
                                        ),
                                      ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: colorBlue,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            EventHubBadge(
                              color: colorBlue,
                              label: _evento.categorias![0].categoria!.nome!,
                            ),
                            Visibility(
                              visible: _evento.ultimosIngressoVendidos != null && _evento.ultimosIngressoVendidos!.isNotEmpty,
                              child: Stack(
                                children: getUltimasVendaIngressos(),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Visibility(
                              visible: _evento.ingressosVendidos != null && _evento.ingressosVendidos! > 0,
                              child: Text(
                                " ${_evento.ingressosVendidos} confirmados",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: colorBlue.withOpacity(
                                    0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Ionicons.calendar_outline,
                                    color: colorBlue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _evento.dataEHoraFormatada!.split(" • ")[0],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(_evento.dataEHoraFormatada!.split(" • ")[1]),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: colorBlue.withOpacity(
                                    0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Ionicons.ticket_outline,
                                    color: colorBlue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "R\$ ${Util.formatarReal(_evento.valor)}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text("Preço do Ingresso"),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: colorBlue.withOpacity(
                                    0.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Ionicons.map_outline,
                                    color: colorBlue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_evento.bairro!}, ${_evento.cidade!} / ${_evento.estado!}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("${_evento.logradouro!} ${_evento.numero!} ${_evento.complemento != null ? "( ${_evento.complemento} )" : ""} - ${_evento.bairro!} - ${_evento.cidade!} / ${_evento.estado!}"),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(
                                  Util.montarURlFotoByArquivo(_evento.usuario!.foto),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _evento.usuario!.nomeCompleto!,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text("Organizador"),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () {
                                  Util.goTo(
                                    context,
                                    PerfilPublicoPage(
                                      idUsuario: _evento.usuario!.id!,
                                      usuarioAutenticado: widget.usuarioAutenticado,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                ),
                                child: const Text(
                                  "Ver Perfil",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding / 1.5,
                        ),
                        const Text(
                          "Sobre o Evento",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          _evento.descricao!,
                        ),
                        const SizedBox(
                          height: defaultPadding / 1.5,
                        ),
                        const Text(
                          "Localização",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Ionicons.map_outline,
                              color: colorBlue,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                "${_evento.logradouro!} ${_evento.numero!} ${_evento.complemento != null ? "( ${_evento.complemento} )" : ""} - ${_evento.bairro!} - ${_evento.cidade!} / ${_evento.estado!}",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding / 1.5,
                        ),
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: _kGooglePlex,
                            markers: markers.values.toSet(),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController.complete(controller);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  List<Widget> getImagensSliders() {
    List<Widget> lista = [];

    for (EventoArquivo eventoArquivo in _evento.arquivos!) {
      lista.add(
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                Util.montarURlFotoByArquivo(
                  eventoArquivo.arquivo,
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return lista;
  }

  List<Widget> getUltimasVendaIngressos() {
    List<Widget> listaUltimasVendaIngressos = [];

    listaUltimasVendaIngressos.add(
      const SizedBox(
        width: 140,
        height: 40,
      ),
    );

    int count = 1;

    for (Ingresso ingresso in _evento.ultimosIngressoVendidos!) {
      listaUltimasVendaIngressos.add(
        Positioned(
          left: count * 20,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              Util.montarURlFotoByArquivo(
                ingresso.usuario!.foto,
              ),
            ),
            radius: 20,
          ),
        ),
      );
      count++;
    }

    return listaUltimasVendaIngressos;
  }
}
