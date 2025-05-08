import 'package:flutter/material.dart';
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
            Get.dialog(
              AlertDialog(
                title: const Text('Comprobante de Inscripción'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Evento: ${respuesta.persona!.eveNombre}'),
                    Text('Modalidad: ${respuesta.persona!.pmNombre}'),
                    Text('Tipo: ${respuesta.persona!.etNombre}'),
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
                        horizontal: 20,
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
                            const SizedBox(height: 12),
                            _buildField(
                              controller: _ciController,
                              hint: 'Ej. 12345678',
                              label: 'Carnet de Identidad',
                              icon: FontAwesomeIcons.addressCard,
                              keyboardType: TextInputType.number,
                              labelColor: AppColor.primaryColor,
                            ),
                            const SizedBox(height: 16),
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
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
                            const SizedBox(height: 24),

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
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 6,
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
                                            fontWeight: FontWeight.w600,
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
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: AppFonts.mina, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColor.greyColor),
            filled: true,
            fillColor: AppColor.whiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
        ),
      ],
    );
  }
}
