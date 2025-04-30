import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:programa_profe/res/colors/app_color.dart';

import '../../data/response/status.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import '../../res/components/internet_exceptions_widget.dart';
import '../../res/fonts/app_fonts.dart';
import '../../view_models/controller/home/home_view_models.dart';
import 'detalle_view.dart';

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
          CameraPosition(target: _initialPosition!, zoom: 16.5),
        ),
      );
    }
  }

  void _moverMapa(LatLng destino) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: destino, zoom: 16.5),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return homeController.error.value == 'No internet'
        ? InterNetExceptionWidget(onPress: homeController.refreshAll)
        : GeneralExceptionWidget(onPress: homeController.refreshAll);
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
        body: Center(
          child: Container(
            color: Colors.black45,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Obteniendo tu ubicación…',
                    style: TextStyle(
                      fontFamily: AppFonts.mina,
                      color: AppColor.whiteColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Obx(() {
        switch (homeController.eventosStatus.value) {
          case Status.LOADING:
            return _buildLoadingCarousel();
          case Status.ERROR:
            return _buildErrorWidget();
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
                                  customIcon ?? BitmapDescriptor.defaultMarker,
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
                            double.parse(sedes[index].sedeLongitud.toString()),
                          ),
                        );
                      },
                      itemBuilder: (context, index) {
                        final sede = sedes[index];
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
                                child: Image.network(
                                  "${AppUrl.baseImage}/storage/sede_imagen/${sede.sedeImagen}",
                                  width: 120,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                                fontFamily: AppFonts.mina,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.info_outline,
                                              size: 22,
                                              color: Colors.blueGrey,
                                            ),
                                            tooltip: "Ver detalles",
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => SedeDetallesScreen(
                                                        sede: sede,
                                                      ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              sede.sedeContacto1.toString(),
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: AppFonts.mina,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              sede.sedeHorario!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: AppFonts.mina,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              sede.sedeEstado == "activo"
                                                  ? Colors.green[50]
                                                  : Colors.red[50],
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          sede.sedeEstado == "activo"
                                              ? "🟢 Abierto"
                                              : "🔴 Cerrado",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: AppFonts.mina,
                                            color:
                                                sede.sedeEstado == "activo"
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
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
        }
      }),
    );
  }
}
