import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../data/response/status.dart';
import '../../res/app_url/app_url.dart';
import '../../res/components/general_exception.dart';
import '../../res/components/internet_exceptions_widget.dart';
import '../../res/fonts/app_fonts.dart';
import '../../utils/preloader.dart';
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
  LatLng _initialPosition = const LatLng(
    -16.506371,
    -68.127681,
  ); // Santa Cruz (fallback)
  BitmapDescriptor? customIcon; // 👈 Aquí guardamos el ícono personalizado

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
    setState(() {}); // Actualizar para reflejar el nuevo icono
  }

  Future<void> _getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    if (_permissionGranted == PermissionStatus.granted) {
      LocationData _locationData = await location.getLocation();

      if (!mounted) return; // 👈 evita el error si el widget fue destruido

      setState(() {
        _initialPosition = LatLng(
          _locationData.latitude!,
          _locationData.longitude!,
        );
      });
    }
  }


  void _moverMapa(LatLng destino) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: destino,
          zoom: 16.5, // 👈 Puedes ajustar el zoom aquí (ej: 16, 17, 18...)
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (homeController.error.value == 'No internet') {
      return InterNetExceptionWidget(onPress: homeController.refreshApi);
    } else {
      return GeneralExceptionWidget(onPress: homeController.refreshApi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // ignore: unnecessary_null_comparison
          _initialPosition == null
              ? const Center(child: CircularProgressIndicator())
              : Obx(() {
                switch (homeController.rxRequestStatus.value) {
                  case Status.LOADING:
                    return LoadingContainer();
                  case Status.ERROR:
                    return _buildErrorWidget();
                  case Status.COMPLETED:
                    print(
                      "------------------------------${homeController.programaList.value.respuesta}",
                    );
                    return _buildCompletedState(_initialPosition);
                }
              }),
    );
  }

  Widget _buildCompletedState(LatLng initialPosition) {
    print(
      "------------------------------${homeController.sedeList.value.respuesta}",
    );
    if (homeController.sedeList.value.respuesta == null ||
        homeController.sedeList.value.respuesta!.isEmpty) {
      return Center(
        child: Text(
          "No hay sedes disponibles",
          style: TextStyle(fontFamily: AppFonts.mina),
        ),
      );
    }
    List sedesDatos = homeController.sedeList.value.respuesta!.toList();
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) => mapController = controller,
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 17,
          ),

          markers:
              sedesDatos.map((sede) {
                return Marker(
                  markerId: MarkerId(sede.sedeNombre),
                  position: LatLng(
                    double.parse(sede.sedeLatitud.toString()),
                    double.parse(sede.sedeLongitud.toString()),
                  ),
                  infoWindow: InfoWindow(title: sede.sedeNombre),
                  icon: customIcon ?? BitmapDescriptor.defaultMarker,
                );
              }).toSet(),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true, // 🧭 Mostrar brújula
          zoomControlsEnabled: false, // ➕➖ Mostrar botones de zoom
          mapToolbarEnabled:
              false, // 🛠️ Botón de Google Maps para abrir direcciones (Android)
          trafficEnabled: true, // 🚗 Mostrar tráfico en tiempo real
          buildingsEnabled: true, // 🏢 Mostrar edificios en 3D (si existen)
          tiltGesturesEnabled: true, // ✋ Habilitar inclinación con gestos
          rotateGesturesEnabled:
              true, // 🔄 Permitir rotar el mapa con dos dedos
          zoomGesturesEnabled: true, // 📏 Permitir hacer zoom con los dedos
          scrollGesturesEnabled: true, // 🖐️ Permitir mover el mapa
          indoorViewEnabled: true, // 🏠 Vista interior en edificios compatibles
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: sedesDatos.length,
              controller: PageController(viewportFraction: 0.9),
              onPageChanged: (index) {
                _moverMapa(
                  LatLng(
                    double.parse(sedesDatos[index].sedeLatitud.toString()),
                    double.parse(sedesDatos[index].sedeLongitud.toString()),
                  ),
                );
              },
              itemBuilder: (context, index) {
                final sede = sedesDatos[index];
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${sede.depNombre} - ${sede.sedeNombre}",
                                      style: const TextStyle(
                                        fontSize: 14,
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
                                      sede.sedeHorario,
                                      style: const TextStyle(fontSize: 12),
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
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  sede.sedeEstado == "activo"
                                      ? "🟢 Abierto"
                                      : "🔴 Cerrado",
                                  style: TextStyle(
                                    fontSize: 12,
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

}
