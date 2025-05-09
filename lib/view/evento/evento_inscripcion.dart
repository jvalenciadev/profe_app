import 'dart:io';
import 'dart:ui' as ui;
import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/response/api_response.dart';
import '../../data/response/status.dart';
import '../../models/persona_model.dart';
import '../../res/app_url/app_url.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/home/evento_view_models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

class EventoInscripcionScreen extends StatefulWidget {
  const EventoInscripcionScreen({super.key});

  @override
  State<EventoInscripcionScreen> createState() =>
      _EventoInscripcionScreenState();
}

class _EventoInscripcionScreenState extends State<EventoInscripcionScreen> {
  final _ciController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  final EventoController _ctrl = Get.put(EventoController());

  // Declara este key a nivel de tu State
  final GlobalKey _certKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    ever(_ctrl.inscripcionResponse, (ApiResponse<PersonaEstadoModel> resp) {
      switch (resp.status) {
        case Status.LOADING:
          // nada
          break;

        case Status.COMPLETED:
          final respuesta = resp.data!.respuesta!;
          // si ya estaba inscrito
          if (respuesta.inscrito == true) {
            Future.microtask(() {
              final persona = respuesta.persona!;
              final nombreCompleto =
                  '${persona.nombre1} ${persona.apellido1} ${persona.apellido2}';
              final estadoColor =
                  respuesta.inscrito == true ? Colors.green : Colors.red;
              Get.dialog(
                Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // RepaintBoundary para captura
                      RepaintBoundary(
                        key: _certKey,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: AppColor.secondaryColor,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 45, 16, 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Evento (subtítulo) justo debajo del encabezado flotante
                              Text(
                                persona.eveNombre ?? 'Nombre del Evento',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppFonts.mina,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primaryColor,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const Divider(height: 24, thickness: 1),
                              _buildCertRow('C.I.:', persona.ci.toString()),
                              const SizedBox(height: 6),
                              _buildCertRow('Participante:', nombreCompleto),
                              const SizedBox(height: 6),
                              _buildCertRow(
                                'Fecha Nac.:',
                                persona.fechaNacimiento ?? '',
                              ),
                              const SizedBox(height: 6),
                              _buildCertRow(
                                'Modalidad:',
                                persona.pmNombre?.toUpperCase() ?? '',
                              ),
                              const SizedBox(height: 6),
                              _buildCertRow(
                                'Tipo de Evento:',
                                persona.etNombre?.toUpperCase() ?? '',
                              ),
                              const SizedBox(height: 6),
                              _buildCertRow(
                                'Departamento:',
                                persona.depNombre ?? '',
                              ),

                              const SizedBox(height: 15),
                              // Código de barras + texto
                              Center(
                                child: Column(
                                  children: [
                                    BarcodeWidget(
                                      barcode: Barcode.code128(),
                                      data: persona.ci.toString(),
                                      width: 220,
                                      height: 60,
                                      drawText: false,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      persona.ci.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Courier New',
                                        fontSize: 12,
                                        color: AppColor.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),
                              // Estado con chip
                              Chip(
                                label: Text(
                                  respuesta.estado ?? '',
                                  style: TextStyle(
                                    color: estadoColor,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFonts.mina,
                                  ),
                                ),
                                backgroundColor: estadoColor.withOpacity(0.1),
                                side: BorderSide(color: estadoColor),
                              ),

                              const SizedBox(height: 16),
                              // Botón cerrar
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -25,
                        left: 10,
                        right: 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Get.back(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  'Aceptar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.whiteColor,
                                    fontFamily: AppFonts.mina,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _saveCertificateImage,
                                icon: const Icon(
                                  Icons.save_alt,
                                  color: AppColor.whiteColor,
                                ),
                                label: const Text(
                                  'Guardar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.whiteColor,
                                    fontFamily: AppFonts.mina,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.secondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Encabezado flotante con título "COMPROBANTE"
                      Positioned(
                        top: -48,
                        left: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColor.secondaryColor,
                          child: Text(
                            'COMPROBANTE',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                barrierDismissible: false,
              );
            });
          } else {
            // persona encontrada pero NO inscrita
            final evento = Get.arguments;
            Future.microtask(() {
              Get.toNamed(
                RouteName.eventoFormularioView,
                arguments: {
                  'evento': evento,
                  'persona': respuesta.persona, // sólo la info de persona
                },
              );
            });
          }
          break;

        case Status.ERROR:
          break;

        case Status.IDLE:
        default:
          // nada
          break;
      }
    });
  }

  Future<void> _saveCertificateImage() async {
    // Verificar y solicitar permisos según la plataforma y versión
    if (Platform.isAndroid) {
      if (!await Permission.manageExternalStorage.isGranted &&
          !await Permission.photos.isGranted) {
        await [
          Permission.storage,
          Permission.mediaLibrary,
          Permission.photos,
          Permission.manageExternalStorage,
        ].request();
      }
    } else if (Platform.isIOS) {
      await Permission.photosAddOnly.request();
    }

    // Verificar si finalmente se otorgaron los permisos necesarios
    bool isPermissionGranted =
        Platform.isAndroid
            ? await Permission.storage.isGranted ||
                await Permission.manageExternalStorage.isGranted
            : await Permission.photosAddOnly.isGranted;

    if (!isPermissionGranted) {
      Get.snackbar(
        'Permiso denegado',
        'Debes otorgar permiso para guardar la imagen en la galería.',
      );
      return;
    }

    try {
      final ctx = _certKey.currentContext;
      if (ctx == null) throw 'Certificado no disponible';
      final boundary = ctx.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw 'No se pudo capturar el certificado';

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final String imageName =
          'comprobante_${DateTime.now().millisecondsSinceEpoch}';

      final success = await SaverGallery.saveImage(
        pngBytes,
        quality: 80,
        fileName: imageName,
        androidRelativePath: "Download/Eventos", // ✅ Carpeta deseada
        skipIfExists: false,
      );
      // Mostrar nuevamente los botones
      if (success.isSuccess == true) {
        Get.snackbar('Guardado', 'Comprobante guardado en Descargas/Eventos.');
      } else {
        Get.snackbar('Error', 'No se pudo guardar la imagen.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un problema: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final evento = Get.arguments;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 355,
              pinned: true,
              backgroundColor: AppColor.primaryColor,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          "${AppUrl.baseImage}/storage/evento_afiches/${evento.eveAfiche}",
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor.withOpacity(0.8),
                          border: Border.all(color: AppColor.secondaryColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.tag,
                              size: 16,
                              color: AppColor.secondaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              evento.etNombre ?? 'Etiqueta',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.mina,
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  evento.eveNombre ?? 'Evento sin nombre',
                  style: TextStyle(
                    fontFamily: AppFonts.mina,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(
                        FontAwesomeIcons.calendarDays,
                        size: 16,
                        color: AppColor.greyColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        evento.eveFecha ?? 'Sin fecha',
                        style: const TextStyle(fontFamily: AppFonts.mina),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        FontAwesomeIcons.mapPin,
                        size: 16,
                        color: AppColor.greyColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          evento.eveLugar ?? 'Sin lugar',
                          style: const TextStyle(fontFamily: AppFonts.mina),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    color: AppColor.grey3Color,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Text(
                                'Inscríbete al Evento',
                                style: TextStyle(
                                  fontFamily: AppFonts.mina,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildField(
                              controller: _ciController,
                              hint: 'Ej. 12345678',
                              label: 'Cédula de Identidad',
                              icon: FontAwesomeIcons.addressCard,
                              keyboardType: TextInputType.number,
                              labelColor: AppColor.primaryColor,
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  locale: const Locale('es', 'ES'),
                                  initialDate: selectedDate ?? DateTime(2000),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  builder:
                                      (ctx, child) => Theme(
                                        data: Theme.of(ctx).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: AppColor.secondaryColor,
                                            onPrimary: Colors.white,
                                            onSurface: AppColor.greyColor,
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  AppColor.secondaryColor,
                                              textStyle: const TextStyle(
                                                fontFamily: AppFonts.mina,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      ),
                                );
                                if (picked != null) {
                                  setState(() {
                                    selectedDate = picked;
                                    _dateController.text = DateFormat(
                                      'yyy-MM-dd',
                                      'es',
                                    ).format(picked);
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                child: _buildField(
                                  controller: _dateController,
                                  hint: 'Seleccione su fecha',
                                  label: 'Fecha de Nacimiento',
                                  icon: FontAwesomeIcons.calendarCheck,
                                  labelColor: AppColor.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // BOTÓN OBSERVADO
                            Obx(() {
                              final resp = _ctrl.inscripcionResponse.value;

                              return ElevatedButton(
                                // Deshabilitamos sólo mientras está LOADING
                                onPressed:
                                    resp.status == Status.LOADING
                                        ? null
                                        : _onSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),
                                child:
                                    resp.status == Status.LOADING
                                        // Mostramos el loader cuando estamos en LOADING
                                        ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                        // En cualquier otro estado (IDLE, COMPLETED, ERROR) mostramos el texto
                                        : const Text(
                                          'Inscribirme',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: AppFonts.mina,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.whiteColor,
                                          ),
                                        ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para filas de etiqueta+valor en el certificado
  Widget _buildCertRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: AppFonts.mina,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: TextStyle(fontSize: 14, fontFamily: AppFonts.mina),
          ),
        ),
      ],
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final evento = Get.arguments;
      // Reiniciamos el observable a loading (opcional si tu controller ya lo hace)
      _ctrl.inscripcionResponse.value = ApiResponse.loading();
      _ctrl.eventoInscripcionPost({
        "eve_id": evento.eveId,
        "per_ci": int.parse(_ciController.text),
        "per_fecha_nacimiento": _dateController.text,
      });
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Color labelColor = AppColor.primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.mina,
            fontWeight: FontWeight.w500,
            color: labelColor,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: AppFonts.mina, fontSize: 15),
          cursorColor: AppColor.primaryColor,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColor.greyColor),
            filled: true,
            fillColor: AppColor.whiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColor.grey2Color, // borde al enfocarse
                width: 1.5,
              ),
            ),
          ),

          validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
        ),
      ],
    );
  }
}
