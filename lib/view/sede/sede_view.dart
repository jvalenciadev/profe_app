import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:programa_profe/res/colors/app_color.dart';

import '../../data/response/status.dart';
import '../../res/app_url/app_url.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/home/home_view_models.dart';

class SedesScreen extends StatefulWidget {
  const SedesScreen({super.key});

  @override
  _SedesScreenState createState() => _SedesScreenState();
}

class _SedesScreenState extends State<SedesScreen> {
  final homeController = Get.find<HomeController>();
  GoogleMapController? mapController;

  // Ahora nullable para distinguir entre sin obtener y obtenido
  LatLng? _initialPosition;
  BitmapDescriptor? customIcon;
  BitmapDescriptor? customUserIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _getLocation();
  }

  Future<void> _loadCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/gps1.png',
    );
    if (mounted) setState(() {});
  }

  Future<void> _getLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await location.requestService();

    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
    }

    if (permission == PermissionStatus.granted) {
      final locData = await location.getLocation();
      final pos = LatLng(locData.latitude!, locData.longitude!);
      _initialPosition = pos;

      // Si el mapa ya está creado, centramos
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: pos, zoom: 16.5),
          ),
        );
      }

      if (mounted) setState(() {});
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_initialPosition != null) {
      mapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _initialPosition!, zoom: 18),
        ),
      );
    }
  }

  void _moverMapa(LatLng destino) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: destino, zoom: 15)),
    );
  }

  Widget _buildLoadingCarousel() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: 3,
          itemBuilder:
              (context, index) => Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Loader hasta obtener ubicación
    if (_initialPosition == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
              color: AppColor.grey3Color,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        strokeWidth: 8,
                        color: AppColor.grey2Color,
                        valueColor: AlwaysStoppedAnimation(AppColor.grey2Color),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Obteniendo tu ubicación…',
                      style: TextStyle(
                        fontFamily: AppFonts.mina,
                        color: AppColor.greyColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          switch (homeController.eventosStatus.value) {
            case Status.LOADING:
              return _buildLoadingCarousel();
            case Status.ERROR:
              return buildErrorWidget(homeController.refreshAll);
            case Status.COMPLETED:
              final sedes = homeController.sedeList.value.respuesta!;
              return Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition!,
                      zoom: 16.5,
                    ),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    compassEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    trafficEnabled: true,
                    buildingsEnabled: true,
                    tiltGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    indoorViewEnabled: true,
                    markers:
                        sedes
                            .map(
                              (sede) => Marker(
                                markerId: MarkerId(sede.sedeNombre!),
                                position: LatLng(
                                  double.parse(sede.sedeLatitud.toString()),
                                  double.parse(sede.sedeLongitud.toString()),
                                ),
                                infoWindow: InfoWindow(
                                  title: sede.sedeNombre,
                                  snippet: sede.depNombre,
                                ),
                                icon:
                                    customIcon ??
                                    BitmapDescriptor.defaultMarker,
                              ),
                            )
                            .toSet(),
                  ),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: sedes.length,
                        controller: PageController(viewportFraction: 0.9),
                        onPageChanged: (index) {
                          _moverMapa(
                            LatLng(
                              double.parse(sedes[index].sedeLatitud.toString()),
                              double.parse(
                                sedes[index].sedeLongitud.toString(),
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, index) {
                          final sede = sedes[index];
                          final turnoList =
                              sede.sedeTurno
                                  ?.replaceFirst('Turnos: ', '')
                                  .split(' | ')
                                  .map((t) => t.trim())
                                  .toList();

                          final estaAbierto = sedeAbiertaAhora(
                            sede.sedeHorario ?? '',
                            sede.sedeTurno ?? '',
                          );

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 6,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${AppUrl.baseImage}/storage/sede_imagen/${sede.sedeImagen}",
                                    width: 120,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            color: AppColor.grey2Color,
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Center(
                                          child: Icon(
                                            FontAwesomeIcons.image,
                                            size: 50,
                                            color: AppColor.grey2Color,
                                          ),
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${sede.depNombre} - ${sede.sedeNombre}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColor.blackColor,
                                                  fontFamily: AppFonts.mina,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                FontAwesomeIcons.eye,
                                                size: 22,
                                                color: AppColor.primaryColor,
                                              ),
                                              tooltip: "Ver detalles",
                                              onPressed: () {
                                                Get.toNamed(
                                                  RouteName.sedeDetalle,
                                                  arguments: sede,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        if (turnoList != null)
                                          Container(
                                            width: 400,
                                            child: Wrap(
                                              spacing: 2,
                                              runSpacing: 2,
                                              children:
                                                  turnoList.map((turno) {
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppColor
                                                            .primaryColor
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const FaIcon(
                                                            FontAwesomeIcons
                                                                .clock,
                                                            size: 12,
                                                            color:
                                                                AppColor
                                                                    .primaryColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            turno,
                                                            style: const TextStyle(
                                                              fontFamily:
                                                                  AppFonts.mina,
                                                              fontSize: 11,
                                                              color:
                                                                  AppColor
                                                                      .primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                          ),

                                        // Row(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     const Icon(
                                        //       FontAwesomeIcons.clock,
                                        //       size: 14,
                                        //       color: AppColor.greyColor,
                                        //     ),
                                        //     const SizedBox(width: 6),
                                        //     Expanded(
                                        //       child: Text(
                                        //         sede.sedeHorario!
                                        //             .replaceAll('Días:', '')
                                        //             .split('|')
                                        //             .map((dia) => dia.trim())
                                        //             .join(
                                        //               ' · ',
                                        //             ), // Separador compacto
                                        //         style: const TextStyle(
                                        //           fontSize: 12,
                                        //           color: AppColor.greyColor,
                                        //           fontFamily: AppFonts.mina,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                estaAbierto
                                                    ? Colors.green[50]
                                                    : Colors.red[50],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                estaAbierto
                                                    ? "🟢 Abierto ahora"
                                                    : "🔴 Cerrado",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: AppFonts.mina,
                                                  color:
                                                      estaAbierto
                                                          ? Colors.green[700]
                                                          : Colors.red[700],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            case Status.IDLE:
              // TODO: Handle this case.
              throw UnimplementedError();
          }
        }),
      ),
    );
  }

  bool sedeAbiertaAhora(String sedeHorario, String sedeTurno) {
    final now = DateTime.now();
    final dias = sedeHorario
        .replaceAll('Días:', '')
        .split('|')
        .map((e) => e.trim().toLowerCase());

    final diasSemana = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];

    final hoy = diasSemana[now.weekday - 1];

    // Si hoy no está en los días de atención
    if (!dias.contains(hoy)) return false;

    // Extraer turnos y rangos
    final turnos = sedeTurno
        .replaceAll('Turnos:', '')
        .split('|')
        .map((e) => e.trim().toLowerCase());

    for (var turno in turnos) {
      final partes = turno.split(':');
      if (partes.length < 2) continue;

      final horas = partes[1].split('-').map((h) => h.trim()).toList();
      if (horas.length != 2) continue;

      final inicio = parseHora(horas[0]);
      final fin = parseHora(horas[1]);

      if (inicio != null &&
          fin != null &&
          now.isAfter(inicio) &&
          now.isBefore(fin)) {
        return true;
      }
    }

    return false;
  }

  DateTime? parseHora(String horaStr) {
    try {
      final partes = horaStr.split(':');
      final hour = int.parse(partes[0]);
      final minute = int.parse(partes[1]);
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }
}
