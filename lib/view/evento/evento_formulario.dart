import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:programa_profe/res/app_url/app_url.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';
import 'package:programa_profe/utils/utils.dart';

import '../../data/response/api_response.dart';
import '../../data/response/status.dart';
import '../../models/evento_model.dart';
import '../../models/persona_model.dart';
import '../../res/colors/app_color.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/home/evento_view_models.dart';
import 'widget/widget.dart'; // donde hayas puesto buildField

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

  Department? _selectedDepartment;
  String? _selectedModality;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    evento  = EventoModel.fromJson(args['evento']);
    persona = Persona.fromJson(args['persona']);

    // Escuchar cambios de status
    ever(_ctrl.inscripcionResponse, _handleInscripcionResponse);
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
            showCustomSnackbar(
              title: '¡Listo!',
              message: respuesta.estado!,
              isError: false,
            );
            // después de mostrar el toast, volvemos al Home
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.offAllNamed(RouteName.homeView);
            });
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
