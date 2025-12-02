import 'dart:io';
import 'dart:ui' as ui;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:programa_profe/res/app_url/app_url.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';
import 'package:programa_profe/utils/utils.dart';
import 'package:saver_gallery/saver_gallery.dart';

import '../../data/response/api_response.dart';
import '../../data/response/status.dart';
import '../../models/evento_model.dart';
import '../../models/persona_model.dart';
import '../../res/colors/app_color.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/evento/evento_view_models.dart';
import 'widget/widget.dart'; // donde hayas puesto buildField
import 'package:permission_handler/permission_handler.dart';

class EventoFormularioScreen extends StatefulWidget {
  const EventoFormularioScreen({Key? key}) : super(key: key);

  @override
  State<EventoFormularioScreen> createState() => _EventoFormularioScreenState();
}

class _EventoFormularioScreenState extends State<EventoFormularioScreen> {
  late EventoModel evento;
  late Persona persona;
  final _formKey = GlobalKey<FormState>();
  final EventoController _ctrl = Get.put(EventoController());
  final GlobalKey _certKey = GlobalKey();
  bool _isSaving = false;
  Department? _selectedDepartment;
  String? _selectedModality;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    evento = EventoModel.fromJson(args['evento']);
    persona = Persona.fromJson(args['persona']);

    // Escuchar cambios de status
    ever(_ctrl.inscripcionResponse, _handleInscripcionResponse);
  }

  Future<void> _saveCertificateImage(setStateDialog) async {
    setStateDialog(() => _isSaving = true);
    try {
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
        showCustomSnackbar(
          title: 'Permiso denegado',
          message:
              'Debes otorgar permiso para guardar la imagen en la galería.',
          isError: true,
        );
        return;
      }

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
        androidRelativePath: "Pictures/Eventos", // ✅ Carpeta deseada
        skipIfExists: false,
      );
      // Mostrar nuevamente los botones
      if (success.isSuccess == true) {
        showCustomSnackbar(
          title: '¡Guardado!',
          message: 'Comprobante guardado en Pictures/Eventos.',
          isError: false,
        );
      } else {
        showCustomSnackbar(
          title: 'Error',
          message: 'No se pudo guardar la imagen.',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Ocurrió un problema.',
        isError: true,
      );
    } finally {
      setStateDialog(() => _isSaving = false);
    }
  }

  void _handleInscripcionResponse(ApiResponse<PersonaEstadoModel> resp) {
    switch (resp.status) {
      case Status.LOADING:
        // no hace nada, el botón ya muestra indicador
        break;

      case Status.ERROR:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCustomSnackbar(
            title: 'Error',
            message: resp.message ?? 'Ocurrió un error',
            isError: true,
          );
        });
        break;

      case Status.COMPLETED:
        final respuesta = resp.data?.respuesta;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (respuesta == null) {
            showCustomSnackbar(
              title: 'Error',
              message: resp.data?.error ?? 'Ocurrió un error desconocido',
              isError: true,
            );
          } else {
            Future.microtask(() {
              final persona = respuesta.persona!;
              final nombreCompleto =
                  '${persona.nombre1} ${persona.apellido1} ${persona.apellido2}';
              final estadoColor =
                  respuesta.inscrito == true ? Colors.green : Colors.green;
              Get.dialog(
                StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return Dialog(
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
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/logos/logoprofeinvertido.png',
                                  ),
                                  fit: BoxFit.fitWidth,
                                  colorFilter: ColorFilter.mode(
                                    Colors.white.withOpacity(0.2),
                                    BlendMode.dstATop,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                20,
                                16,
                                20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Título con estilo destacado
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.secondaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      persona.eveNombre ?? 'Nombre del Evento',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: AppFonts.mina,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.primaryColor,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: AppColor.greyColor,
                                  ),
                                  const SizedBox(height: 10),
                                  buildCertRow('C.I.:', persona.ci.toString()),
                                  const SizedBox(height: 6),
                                  buildCertRow('Participante:', nombreCompleto),
                                  const SizedBox(height: 6),
                                  buildCertRow(
                                    'Fecha Nac.:',
                                    persona.fechaNacimiento ?? '',
                                  ),
                                  const SizedBox(height: 6),
                                  buildCertRow(
                                    'Modalidad:',
                                    persona.pmNombre?.toUpperCase() ?? '',
                                  ),
                                  const SizedBox(height: 6),
                                  buildCertRow(
                                    'Celular:',
                                    persona.celular?.toUpperCase() ?? '',
                                  ),
                                  const SizedBox(height: 6),
                                  buildCertRow('Correo:', persona.correo ?? ''),
                                  const SizedBox(height: 6),
                                  buildCertRow(
                                    'Tipo de Evento:',
                                    persona.etNombre?.toUpperCase() ?? '',
                                  ),
                                  const SizedBox(height: 6),
                                  buildCertRow(
                                    'Departamento:',
                                    persona.depNombre ?? '',
                                  ),
                                  const SizedBox(height: 10),
                                  // Código de barras + texto
                                  Center(
                                    child: Column(
                                      children: [
                                        Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: BarcodeWidget(
                                              barcode: Barcode.code128(),
                                              data: persona.ci.toString(),
                                              width: 200,
                                              height: 50,
                                              drawText: false,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          persona.ci.toString(),
                                          style: TextStyle(
                                            fontFamily: 'Courier New',
                                            fontSize: 14,
                                            color: AppColor.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  // Estado con chip
                                  Chip(
                                    label: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            300, // Ajusta este valor al ancho que necesites
                                      ),
                                      child: Text(
                                        respuesta.estado ?? '',
                                        style: TextStyle(
                                          color: estadoColor,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppFonts.mina,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                    backgroundColor: estadoColor.withOpacity(
                                      0.1,
                                    ),
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
                                    onPressed: () {
                                      Get.back();
                                      // después de mostrar el toast, volvemos al Home
                                      Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () {
                                          Get.offAllNamed(RouteName.homeView);
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primaryColor,
                                      foregroundColor:
                                          Colors
                                              .white, // Esto mejora el efecto en presión
                                      shadowColor: Colors.black.withOpacity(
                                        0.4,
                                      ), // sombra al presionar
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
                                        fontSize: 14,
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
                                    onPressed: () async {
                                      _isSaving
                                          ? null
                                          : _saveCertificateImage(
                                            setStateDialog,
                                          );
                                    },
                                    icon:
                                        _isSaving
                                            ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColor.whiteColor,
                                              ),
                                            )
                                            : const Icon(
                                              Icons.save_alt,
                                              color: AppColor.whiteColor,
                                            ),
                                    label: Text(
                                      _isSaving ? 'Guardando...' : 'Guardar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.whiteColor,
                                        fontFamily: AppFonts.mina,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.secondaryColor,
                                      foregroundColor:
                                          Colors
                                              .white, // Esto mejora el efecto en presión
                                      shadowColor: Colors.black.withOpacity(
                                        0.4,
                                      ),
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
                            top: -20, // ajusta según nuevo alto
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.secondaryColor,
                                  borderRadius: BorderRadius.circular(
                                    24,
                                  ), // píldora
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'COMPROBANTE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                barrierDismissible: false,
              );
            });

            showCustomSnackbar(
              title: '¡Listo!',
              message: respuesta.estado!,
              isError: false,
            );
          }
        });
        break;

      case Status.IDLE:
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // ... tu SliverAppBar y encabezado ...
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
                  // ... fecha y lugar ...
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
                            const SizedBox(height: 15),

                            // Campos de sólo lectura
                            buildField(
                              label: 'Cédula de Identidad',
                              initialValue: persona.ci.toString(),
                              hint: '',
                              icon: FontAwesomeIcons.idCard,
                              readOnly: true,
                            ),
                            buildField(
                              label: 'Nombre Completo',
                              initialValue:
                                  '${persona.nombre1} ${persona.apellido1} ${persona.apellido2}',
                              hint: '',
                              icon: FontAwesomeIcons.user,
                              readOnly: true,
                            ),
                            buildField(
                              label: 'Correo',
                              initialValue: persona.correo ?? '',
                              hint: '',
                              icon: FontAwesomeIcons.envelope,
                              readOnly: true,
                            ),
                            buildField(
                              label: 'Celular',
                              initialValue: persona.celular ?? '',
                              hint: '',
                              icon: FontAwesomeIcons.phone,
                              readOnly: true,
                            ),

                            const SizedBox(height: 16),

                            // Modalidad (editable)
                            const Text(
                              'Modalidad',
                              style: TextStyle(
                                fontFamily: AppFonts.mina,
                                fontWeight: FontWeight.w500,
                                color: AppColor.primaryColor,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _selectedModality,
                              style: TextStyle(
                                fontFamily: AppFonts.mina,
                                fontWeight: FontWeight.w500,
                                color: AppColor.blackColor,
                                fontSize: 15,
                              ),
                              items:
                                  (evento.modalidades ?? [])
                                      .map(
                                        (mod) => DropdownMenuItem(
                                          value: mod,
                                          child: Text(mod),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (val) =>
                                      setState(() => _selectedModality = val),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColor.whiteColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColor.grey2Color,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              validator:
                                  (v) =>
                                      v == null
                                          ? 'Seleccione una modalidad'
                                          : null,
                            ),

                            const SizedBox(height: 16),

                            // Departamento (editable)
                            const Text(
                              'Departamento',
                              style: TextStyle(
                                fontFamily: AppFonts.mina,
                                fontWeight: FontWeight.w500,
                                color: AppColor.primaryColor,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<Department>(
                              style: TextStyle(
                                fontFamily: AppFonts.mina,
                                fontWeight: FontWeight.w500,
                                color: AppColor.blackColor,
                                fontSize: 15,
                              ),
                              value: _selectedDepartment,
                              items:
                                  departmentList
                                      .map(
                                        (d) => DropdownMenuItem(
                                          value: d,
                                          child: Text(d.name),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (val) =>
                                      setState(() => _selectedDepartment = val),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColor.whiteColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColor.grey2Color,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              validator:
                                  (v) =>
                                      v == null
                                          ? 'Seleccione un departamento'
                                          : null,
                            ),

                            const SizedBox(height: 20),

                            Obx(() {
                              final resp = _ctrl.inscripcionResponse.value;
                              return ElevatedButton(
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
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                              Colors.white,
                                            ),
                                          ),
                                        )
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

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _ctrl.inscripcionResponse.value = ApiResponse.loading();
      _ctrl.eventoInscripcionParPost({
        "eve_id": evento.eveId,
        "per_ci": persona.ci,
        "per_fecha_nacimiento": persona.fechaNacimiento,
        "dep_id": _selectedDepartment!.id,
        "pm_nombre": _selectedModality,
      });
    }
  }
}
