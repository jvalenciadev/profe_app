import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Sede {
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final bool abierto;
  final LatLng ubicacion;

  Sede(this.nombre, this.descripcion, this.imagenUrl, this.abierto, this.ubicacion);
}

class SedesScreen extends StatefulWidget {
  @override
  _SedesScreenState createState() => _SedesScreenState();
}

class _SedesScreenState extends State<SedesScreen> {
  GoogleMapController? mapController;
  LatLng _initialPosition = const LatLng(-17.7833, -63.1821); // Santa Cruz (fallback)
  final List<Sede> sedes = [
    Sede("Sede Central", "Oficina principal", "https://via.placeholder.com/100", true, LatLng(-17.784, -63.1825)),
    Sede("Sede Este", "Centro académico", "https://via.placeholder.com/100", false, LatLng(-17.786, -63.1800)),
    Sede("Sede Norte", "Centro deportivo", "https://via.placeholder.com/100", true, LatLng(-17.785, -63.1850)),
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) _serviceEnabled = await location.requestService();

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    if (_permissionGranted == PermissionStatus.granted) {
      LocationData _locationData = await location.getLocation();
      setState(() {
        _initialPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
      });
    }
  }

  void _moverMapa(LatLng destino) {
    mapController?.animateCamera(CameraUpdate.newLatLng(destino));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) => mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 15,
                  ),
                  markers: sedes.map((sede) {
                    return Marker(
                      markerId: MarkerId(sede.nombre),
                      position: sede.ubicacion,
                      infoWindow: InfoWindow(title: sede.nombre),
                    );
                  }).toSet(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: sedes.length,
                      controller: PageController(viewportFraction: 0.9),
                      onPageChanged: (index) {
                        _moverMapa(sedes[index].ubicacion);
                      },
                      itemBuilder: (context, index) {
                        final sede = sedes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 6,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                child: Image.network(
                                  sede.imagenUrl,
                                  width: 100,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        sede.nombre,
                                        style: const TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        sede.descripcion,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        sede.abierto ? "🟢 Abierto" : "🔴 Cerrado",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: sede.abierto ? Colors.green : Colors.red,
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
            ),
    );
  }
}
