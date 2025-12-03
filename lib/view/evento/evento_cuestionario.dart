import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';

import '../../data/response/api_response.dart';
import '../../data/response/status.dart';
import '../../models/evento_cuestionario_model.dart';
import '../../models/evento_model.dart';
import '../../models/persona_model.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/icons/icons.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/evento/evento_cuestionario_models.dart';
import 'evento_cuestionario_run.dart';

class EventoCuestionarioScreen extends StatefulWidget {
  const EventoCuestionarioScreen({super.key});

  @override
  State<EventoCuestionarioScreen> createState() =>
      _EventoCuestionarioScreenState();
}

class _EventoCuestionarioScreenState extends State<EventoCuestionarioScreen> {
  late EventoModel evento;
  late Persona persona;
  final CuestionarioController _ctrl = Get.put(CuestionarioController());

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    evento = EventoModel.fromJson(args['evento']);
    persona = Persona.fromJson(args['persona']);

    ever(_ctrl.cuestionarioResponse, (ApiResponse<CuestionarioModel> resp) {
      if (resp.status == Status.ERROR) {
        Get.snackbar(
          'Error',
          resp.message ?? 'Ha ocurrido un error',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.redColor,
          colorText: AppColor.whiteColor,
        );
      }
    });

    _ctrl.cuestionarioResponse.value = ApiResponse.loading();
    _ctrl.eventoCuestionarioPost({
      "eve_id": evento.eveId,
      "per_ci": persona.ci,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey4Color,
      body: SafeArea(
        child: Obx(() {
          final resp = _ctrl.cuestionarioResponse.value;

          if (resp.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (resp.status == Status.ERROR) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  _ctrl.eventoCuestionarioPost({
                    "eve_id": evento.eveId,
                    "per_ci": persona.ci,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.secondaryButtonColor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Reintentar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          if (resp.status == Status.COMPLETED) {
            return _buildCuestionarioView(resp.data!);
          }

          return const SizedBox();
        }),
      ),
    );
  }

  Widget _buildCuestionarioView(CuestionarioModel cuestionario) {
    final data = cuestionario.respuesta;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================== EVENTO ========================
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [AppColor.primaryColor, AppColor.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.eveNombre ?? "Evento sin título",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor,
                    fontFamily: AppFonts.montserrat,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppColor.whiteColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      evento.eveLugar ?? "Sin lugar",
                      style: const TextStyle(
                          color: AppColor.whiteColor, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ======================== PARTICIPANTE ========================
          _sectionTitle("Participante"),
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: AppColor.primaryColor.withOpacity(0.2),
                child: const Icon(Icons.person,
                    color: AppColor.primaryColor, size: 30),
              ),
              title: Text(
                "${persona.nombre1} ${persona.apellido1} ${persona.apellido2}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: AppFonts.montserrat,
                ),
              ),
              subtitle: Text("CI: ${persona.ci}",
                  style: const TextStyle(
                      fontFamily: AppFonts.schylerRegular, fontSize: 14)),
            ),
          ),

          const SizedBox(height: 24),

          // ======================== INFO CUESTIONARIO ========================
          _sectionTitle("Información del Cuestionario"),
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _infoTile(
                    icon: iconMap['clock']!,
                    label: "Duración",
                    value: formatDurationReadable(data?.eveCueTiempo),
                  ),
                  _infoTile(
                    icon: iconMap['trophy']!,
                    label: "Puntaje Máximo",
                    value: "${data?.eveCuePtsMax ?? 0} puntos",
                  ),
                  _infoTile(
                    icon: iconMap['calendar-days']!,
                    label: "Inicio",
                    value: formatDateTime(data!.eveCueFechaIni ?? DateTime.now()),
                  ),
                  _infoTile(
                    icon: iconMap['calendar-days']!,
                    label: "Fin",
                    value: formatDateTime(data.eveCueFechaFin ?? DateTime.now()),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ======================== BOTÓN INICIAR ========================
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow, color: AppColor.whiteColor),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryButtonColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
              ),
              label: const Text(
                "Iniciar Cuestionario",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.whiteColor,
                  fontFamily: AppFonts.montserrat,
                ),
              ),
              onPressed: () {
                Get.to(() => const QuizScreen());
              },
            ),
          ),

          const SizedBox(height: 32),

          // ======================== TITULO CUESTIONARIO ========================
          _sectionTitle(data.eveCueTitulo ?? "Cuestionario"),

          // ======================== DESCRIPCIÓN HTML ========================
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Html(
                data: data.eveCueDescripcion ?? '',
                extensions: const [
                  IframeHtmlExtension(),
                  TableHtmlExtension(),
                ],
                style: {
                  "p": Style(
                      fontSize: FontSize(16),
                      lineHeight: LineHeight(1.5),
                      margin: Margins.symmetric(vertical: 12),
                      fontFamily: AppFonts.schylerRegular),
                  "h1": Style(
                      fontSize: FontSize(24),
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.montserrat),
                  "table": Style(
                      alignment: Alignment.center,
                      margin: Margins.symmetric(vertical: 16),
                      width: Width.auto()),
                  "th": Style(
                      backgroundColor: AppColor.grey2Color,
                      fontWeight: FontWeight.bold,
                      padding: HtmlPaddings.all(12),
                      border: Border.all(color: AppColor.greyColor)),
                  "td": Style(
                      padding: HtmlPaddings.all(10),
                      border: Border.all(color: AppColor.grey2Color)),
                  "blockquote": Style(
                      padding: HtmlPaddings.all(12),
                      backgroundColor: AppColor.grey3Color,
                      border: Border(
                          left: BorderSide(
                              color: AppColor.primaryColor, width: 4)),
                      fontStyle: FontStyle.italic,
                      margin: Margins.symmetric(vertical: 12)),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.primaryColor,
          fontFamily: AppFonts.montserrat,
        ),
      ),
    );
  }

  Widget _infoTile(
      {required IconData icon, required String label, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.grey4Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColor.secondaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
