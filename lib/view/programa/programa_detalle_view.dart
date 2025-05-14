import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:programa_profe/models/galeria_model.dart';
import 'package:programa_profe/models/programa_model.dart';
import 'package:programa_profe/res/app_url/app_url.dart';
import 'package:programa_profe/res/colors/app_color.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';
import '../../data/response/status.dart';
import '../../models/home/programa_id_model.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/programa/programa_view_model.dart';

class ProgramaDetalleView extends StatefulWidget {
  const ProgramaDetalleView({Key? key}) : super(key: key);

  @override
  _ProgramaDetalleViewState createState() => _ProgramaDetalleViewState();
}

class _ProgramaDetalleViewState extends State<ProgramaDetalleView> {
  final _controller = Get.find<ProgramaController>();
  late final String _proId;

  @override
  void initState() {
    super.initState();
    final _programa = Get.arguments as ProgramaModel;
    _proId = _programa.proId.toString();
    _controller.loadProgramas(_proId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Obx(() {
        switch (_controller.programaStatus.value) {
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
                      onPressed: () => _controller.loadProgramas(_proId),
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
            final data = _controller.programaId.value.respuesta!;
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  _buildParallaxAppBar(data.programa!),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildInfoSection(data.programa!),
                        const SizedBox(height: 10),
                        _buildRestriccionSection(data.restriccion),
                        const SizedBox(height: 10),
                        _buildSedesSection(
                          data.programaSedeTurno!,
                          data.programa!.proNombreAbre,
                        ),
                        const SizedBox(height: 10),
                        _buildGaleriaSection(data.galeriasPorPrograma!),
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

  Widget _buildParallaxAppBar(ProgramaModel prog) {
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
                prog.proNombreAbre ?? '',
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
                      '${AppUrl.baseImage}/storage/programa_afiches/${prog.proAfiche}',
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
                    prog.proNombreAbre ?? '',
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

  Widget _buildInfoSection(ProgramaModel prog) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prog.proNombre!,
              style: const TextStyle(
                fontFamily: AppFonts.mina,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            const Divider(),
            // Tipo de programa
            _infoRow(FontAwesomeIcons.tag, 'Tipo', prog.proTipNombre),
            // Versión y gestión
            _infoRow(
              FontAwesomeIcons.layerGroup,
              prog.pvNombre!,
              '${prog.pvRomano} - ${prog.pvGestion}',
            ),
            // Modalidad
            _infoRow(
              FontAwesomeIcons.chalkboardTeacher,
              'Modalidad',
              prog.pmNombre,
            ),
            // Horario
            _infoRow(FontAwesomeIcons.clock, 'Horario', prog.proHorario),
            // Carga Horaria
            _infoRow(
              FontAwesomeIcons.hourglassHalf,
              'Carga Horaria',
              '${prog.proCargaHoraria} hs',
            ),
            // Costo
            _infoRow(FontAwesomeIcons.wallet, 'Costo', '${prog.proCosto} Bs'),
            // Duración
            _infoRow(FontAwesomeIcons.calendarDay, 'Duración', prog.pdNombre),
            // Fechas de inscripción
            _infoRow(
              FontAwesomeIcons.calendarAlt,
              'Inscripción',
              '${formatFechaSinAnioLarga(prog.proFechaInicioInscripcion)} → ${formatFechaLarga(prog.proFechaFinInscripcion)}',
            ),
            // Inicio de clases
            _infoRow(
              FontAwesomeIcons.school,
              'Inicio de Clases',
              formatFechaLarga(prog.proFechaInicioClase),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColor.primaryColor),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.mina,
              color: AppColor.primaryColor,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '—',
              style: const TextStyle(fontFamily: AppFonts.mina, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSedesSection(
    List<ProgramaSedeTurno> sedes,
    String? programaNombre,
  ) {
    return ExpansionTile(
      leading: const Icon(
        // ignore: deprecated_member_use
        FontAwesomeIcons.mapMarkedAlt,
        color: AppColor.primaryColor,
      ),
      title: Text(
        'Sedes y Turnos',
        style: const TextStyle(
          fontFamily: AppFonts.mina,
          color: AppColor.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      children: sedes.map((s) => _sedeCard(s, programaNombre)).toList(),
    );
  }

  Widget _sedeCard(ProgramaSedeTurno s, String? programaNombre) {
    final List<String> turnos =
        (jsonDecode(s.programaturno!) as List<dynamic>).cast<String>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(
          s.sedeNombre ?? '—',
          style: const TextStyle(fontFamily: AppFonts.mina),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Depto.: ${s.depNombre}',
              style: const TextStyle(fontFamily: AppFonts.mina),
            ),
            contactButton('Contacto 1', s.sedeContacto1, programaNombre!),
            contactButton('Contacto 2', s.sedeContacto2, programaNombre),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  turnos.map((turno) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColor.primaryColor.withOpacity(0.3),
                        ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildRestriccionSection(Restriccion? res) {
    if (res?.resDescripcion == null || res!.resDescripcion!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restricción',
              style: const TextStyle(
                fontFamily: AppFonts.mina,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            mostrarHtml(res.resDescripcion!),
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
                          g.sedeNombre ?? '',
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
