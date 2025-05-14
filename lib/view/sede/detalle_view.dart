import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:programa_profe/models/galeria_model.dart';
import 'package:programa_profe/models/sede_model.dart';
import 'package:programa_profe/res/app_url/app_url.dart';
import 'package:programa_profe/res/colors/app_color.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../data/response/status.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/sede/sede_view_model.dart';

class SedeDetallesScreen extends StatefulWidget {
  const SedeDetallesScreen({Key? key}) : super(key: key);

  @override
  _SedeDetallesScreenState createState() => _SedeDetallesScreenState();
}

class _SedeDetallesScreenState extends State<SedeDetallesScreen> {
  final _controller = Get.find<SedeController>();
  late final String _sedeId;

  @override
  void initState() {
    super.initState();
    final sede = Get.arguments as SedeModel;
    _sedeId = sede.sedeId.toString();
    _controller.loadSedes(_sedeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Obx(() {
        switch (_controller.sedeStatus.value) {
          case Status.LOADING:
            return loading();
          case Status.ERROR:
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.exclamationTriangle,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¡Vaya! Algo salió mal.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.mina,
                        fontSize: 18,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _controller.error.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.mina,
                        fontSize: 14,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _controller.loadSedes(_sedeId),
                      icon: const FaIcon(
                        FontAwesomeIcons.undo,
                        size: 16,
                        color: AppColor.whiteColor,
                      ),
                      label: const Text(
                        'Reintentar',
                        style: TextStyle(
                          fontFamily: AppFonts.mina,
                          color: AppColor.whiteColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          case Status.COMPLETED:
            final data = _controller.sedeId.value.respuesta!;
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  _buildParallaxAppBar(data.sede!),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildInfoSection(data.sede!),
                        const SizedBox(height: 10),
                        _buildGaleriaSection(data.galerias!),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }

  Widget _buildParallaxAppBar(SedeModel sede) {
    return SliverAppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12, top: 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColor.whiteColor,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      expandedHeight: 340,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColor.primaryColor,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;
          return FlexibleSpaceBar(
            centerTitle: true,
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: top < 120 ? 1.0 : 0.0,
              child: Text(
                sede.sedeNombreAbre ?? '',
                style: const TextStyle(
                  fontFamily: AppFonts.mina,
                  color: AppColor.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      '${AppUrl.baseImage}/storage/sede_imagen/${sede.sedeImagen}',
                  fit: BoxFit.cover,
                ),
                // Overlay degradado
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                // Título grande cuando está expandido
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(
                    sede.sedeNombreAbre ?? '',
                    style: const TextStyle(
                      fontFamily: AppFonts.mina,
                      fontSize: 24,
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black54,
                          offset: Offset(0, 2),
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
    );
  }

  Widget _buildInfoSection(SedeModel sede) {
    // Decodifica horario y turno (si necesitas separarlos en lista)
    final turnoList =
        sede.sedeTurno
            ?.replaceFirst('Turnos: ', '')
            .split(' | ')
            .map((t) => t.trim())
            .toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre sede
            Text(
              sede.sedeNombre ?? '—',
              style: const TextStyle(
                fontFamily: AppFonts.mina,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 12),

            // Descripción HTML (usa flutter_html o similar)
            if (sede.sedeDescripcion != null)
              mostrarHtml(sede.sedeDescripcion!),

            const Divider(),

            // Horario
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FontAwesomeIcons.clock,
                  size: 18,
                  color: AppColor.primaryColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Días de atención:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: AppFonts.mina,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 0,
                        children:
                            sede.sedeHorario!
                                .replaceAll('Días:', '')
                                .split('|')
                                .map(
                                  (dia) => Chip(
                                    label: Text(
                                      dia.trim(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        fontFamily: AppFonts.mina,
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                    backgroundColor: AppColor.secondaryColor
                                        .withOpacity(0.2),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Turnos
            if (turnoList != null)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    turnoList.map((turno) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.clock,
                              size: 14,
                              color: AppColor.primaryColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              turno,
                              style: const TextStyle(
                                fontFamily: AppFonts.mina,
                                fontSize: 12,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),

            const SizedBox(height: 12),

            // Contactos
            if (sede.sedeContacto1 != null)
              contactButton('Contacto 1', sede.sedeContacto1, ""),
            if (sede.sedeContacto2 != null)
              contactButton('Contacto 2', sede.sedeContacto2, ""),

            const SizedBox(height: 12),

            // Facebook
            if (sede.sedeFacebook != null)
              TextButton.icon(
                onPressed: () => launchUrlString(sede.sedeFacebook!),
                icon: const FaIcon(
                  FontAwesomeIcons.facebook,
                  color: AppColor.primaryColor,
                ),
                label: const Text(
                  'Facebook',
                  style: TextStyle(
                    fontFamily: AppFonts.mina,
                    color: AppColor.primaryColor,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Mapa embebido (o botón para abrir en Google Maps)
            if (sede.sedeLatitud != null && sede.sedeLongitud != null)
              SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(sede.sedeLatitud!),
                      double.parse(sede.sedeLongitud!),
                    ),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('sede_${sede.sedeId}'),
                      position: LatLng(
                        double.parse(sede.sedeLatitud!),
                        double.parse(sede.sedeLongitud!),
                      ),
                      infoWindow: InfoWindow(title: sede.sedeNombre),
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  onTap: (_) {
                    final mapUri = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${sede.sedeLatitud},${sede.sedeLongitud}',
                    );
                    launchUrl(mapUri, mode: LaunchMode.externalApplication);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGaleriaSection(List<GaleriaModel> galeria) {
    if (galeria.isEmpty) {
      return const Center(
        child: Text(
          'No hay imágenes disponibles.',
          style: TextStyle(
            fontFamily: AppFonts.mina,
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Galería',
            style: const TextStyle(
              fontFamily: AppFonts.mina,
              color: AppColor.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: galeria.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (_, i) {
            final g = galeria[i];
            return GestureDetector(
              onTap: () => _openGallery(context, galeria, i),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl:
                            '${AppUrl.baseImage}/storage/galeria/${g.galeriaImagen}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          g.proNombreAbre ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: AppFonts.mina,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _openGallery(
    BuildContext context,
    List<GaleriaModel> galeria,
    int initialIndex,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(backgroundColor: Colors.transparent),
              body: PhotoViewGallery.builder(
                itemCount: galeria.length,
                pageController: PageController(initialPage: initialIndex),
                builder: (ctx, index) {
                  final img = galeria[index];
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                      '${AppUrl.baseImage}/storage/galeria/${img.galeriaImagen}',
                    ),
                    heroAttributes: PhotoViewHeroAttributes(
                      tag: img.galeriaId!,
                    ),
                  );
                },
                loadingBuilder:
                    (ctx, event) =>
                        const Center(child: CircularProgressIndicator()),
              ),
            ),
      ),
    );
  }
}
