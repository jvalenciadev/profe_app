import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:programa_profe/res/colors/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res/fonts/app_fonts.dart';
import 'utils.dart';

String formatDateTime(DateTime date) {
    // Formato: 15/01/2025 14:30
    return "${_two(date.day)}/${_two(date.month)}/${date.year} "
           "${_two(date.hour)}:${_two(date.minute)}";
  }

String _two(int n) => n.toString().padLeft(2, '0');


Duration parseDuration(String time) {
  final parts = time.split(':');
  return Duration(
    hours: int.parse(parts[0]),
    minutes: int.parse(parts[1]),
    seconds: int.parse(parts[2]),
  );
}
String durationToString(Duration? d) {
  if (d == null) return "";
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return "${twoDigits(d.inHours)}:"
         "${twoDigits(d.inMinutes % 60)}:"
         "${twoDigits(d.inSeconds % 60)}";
}

String formatearFecha(DateTime fecha) {
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(fecha); // Por ejemplo: '12 Mar 1998'
}

String formatearFechaConHora(DateTime fecha) {
  final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm');
  return formatter.format(fecha); // Por ejemplo: '12 Mar 1998 15:30'
}
String formatDuration(Duration? d) {
  if (d == null) return "-";

  String two(int n) => n.toString().padLeft(2, '0');

  return "${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}";
}
String formatDurationReadable(Duration? d) {
  if (d == null) return "-";

  final hours = d.inHours;
  final minutes = d.inMinutes % 60;
  final seconds = d.inSeconds % 60;

  List<String> parts = [];

  if (hours > 0) {
    parts.add("$hours ${hours == 1 ? "hora" : "horas"}");
  }
  if (minutes > 0) {
    parts.add("$minutes min");
  }
  if (seconds > 0 && hours == 0) {
    // Solo mostramos segundos si no hay horas
    parts.add("$seconds seg");
  }

  // Si todo es cero
  if (parts.isEmpty) return "0 min";

  return parts.join(" ");
}
// Verificar si una fecha es válida (si es después de la fecha actual)
bool esFechaValida(DateTime fecha) {
  return fecha.isAfter(DateTime.now());
}

// Obtener la fecha actual
DateTime obtenerFechaActual() {
  return DateTime.now();
}

String? formatFechaLarga(String? fecha) {
  if (fecha == null || fecha.isEmpty) return null;
  try {
    final DateTime dateTime = DateTime.parse(fecha);
    const List<String> meses = [
      "Ene",
      "Feb",
      "Mar",
      "Abr",
      "May",
      "Jun",
      "Jul",
      "Ago",
      "Sep",
      "Oct",
      "Nov",
      "Dic",
    ];
    return "${dateTime.day} de ${meses[dateTime.month - 1]} de ${dateTime.year}";
  } catch (e) {
    return null;
  }
}

Widget contactButton(String label, int? telefono, String programaNombre) {
  if (telefono == null) return const SizedBox.shrink();
  final mensaje = Uri.encodeComponent(
    '¡Hola! 🙋‍♂️\n\nEstoy interesado en la oferta formativa de "$programaNombre".\n¿Podrías enviarme más detalles sobre fechas, costos y contenido?\n\n¡Muchas gracias! 😊',
  );
  final uri = Uri.parse('https://wa.me/591$telefono?text=$mensaje');
  return Pulse(
    from: 1,
    to: 1.05,
    infinite: true,
    child: TextButton.icon(
      onPressed: () async {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          showCustomSnackbar(
            title: 'Error',
            message: 'No se pudo abrir WhatsApp',
            isError: true,
          );
        }
      },
      icon: const FaIcon(
        FontAwesomeIcons.whatsapp,
        color: AppColor.primaryColor,
        size: 18,
      ),
      label: Text(
        '$label: $telefono',
        style: const TextStyle(
          fontFamily: AppFonts.mina,
          color: AppColor.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget loading() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo o imagen de tu app
        Image.asset('assets/logos/logoprofe.png', width: 150, height: 80),
        const SizedBox(height: 16),
        // Texto amigable
        const Text(
          'Cargando información...',
          style: TextStyle(
            fontFamily: AppFonts.mina,
            fontSize: 16,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        // Indicador personalizado
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            color: AppColor.primaryColor,
          ),
        ),
      ],
    ),
  );
}

/// Widget de error unificado
Widget buildErrorWidget(VoidCallback onRetry) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.exclamationTriangle,
            size: 40,
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
          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: onRetry,
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String? formatFechaSinAnioLarga(String? fecha) {
  if (fecha == null || fecha.isEmpty) return null;
  try {
    final DateTime dateTime = DateTime.parse(fecha);
    const List<String> meses = [
      "Ene",
      "Feb",
      "Mar",
      "Abr",
      "May",
      "Jun",
      "Jul",
      "Ago",
      "Sep",
      "Oct",
      "Nov",
      "Dic",
    ];
    return "${dateTime.day} de ${meses[dateTime.month - 1]}";
  } catch (e) {
    return null;
  }
}

String formatoHoraAmPm(String hora24) {
  try {
    final hora = DateFormat("HH:mm:ss").parse(hora24);
    return DateFormat("hh:mm a").format(hora).toLowerCase(); // ej: 03:00 pm
  } catch (e) {
    return hora24; // En caso de error, devuelve el valor original
  }
}

String? formatFechaCorta(String? fecha) {
  if (fecha == null || fecha.isEmpty) return null;
  try {
    final DateTime dateTime = DateTime.parse(fecha);
    const List<String> meses = [
      "Ene",
      "Feb",
      "Mar",
      "Abr",
      "May",
      "Jun",
      "Jul",
      "Ago",
      "Sep",
      "Oct",
      "Nov",
      "Dic",
    ];
    return "${dateTime.day} de ${meses[dateTime.month - 1]}/${dateTime.year}";
  } catch (e) {
    return null;
  }
}

// Función auxiliar para convertir hora desde String
String? parseHora(String? hora) {
  if (hora == null || hora.isEmpty) return null;
  try {
    final DateTime dateTime = DateTime.parse("1970-01-01 $hora");
    return "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}:"
        "${dateTime.second.toString().padLeft(2, '0')}";
  } catch (e) {
    return null;
  }
}

// Función auxiliar para convertir una cadena JSON en lista de strings
List<String>? parseLista(String? jsonLista) {
  if (jsonLista == null || jsonLista.isEmpty) return null;
  try {
    return List<String>.from(json.decode(jsonLista));
  } catch (e) {
    return null;
  }
}

// 2. Gestión de Inscripciones y Validaciones
Widget mostrarHtml(String? html) {
  if (html == null || html.trim().isEmpty) {
    return const Text(
      'Sin descripción disponible',
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  return Html(
    data: html,
    style: {
      "body": Style(
        fontSize: FontSize(16),
        fontFamily: AppFonts.mina,
        color: AppColor.greyColor,
        lineHeight: LineHeight(1.5),
        margin: Margins.only(top: 0, bottom: 0),
        padding: HtmlPaddings.zero,
      ),
      "p": Style(margin: Margins.only(bottom: 12)),
    },
  );
}

String convertirHtmlATexto(String html) {
  RegExp exp = RegExp(r'<[^>]*>');
  return html.replaceAll(exp, ''); // Elimina las etiquetas HTML
}

// Verificar si la inscripción está cerrada
bool inscripcionCerrada(DateTime fechaFinInscripcion) {
  return DateTime.now().isAfter(fechaFinInscripcion);
}

// Verificar si el usuario ya está inscrito en un evento
bool yaInscripto(String usuarioId, String eventoId) {
  // Lógica para verificar inscripción en la base de datos
  return false; // Retorna 'false' si no está inscrito
}

// 3. Formateo de Contenidos

// Truncar un texto largo a un tamaño máximo
String truncarTexto(String texto, int longitudMaxima) {
  if (texto.length > longitudMaxima) {
    return texto.substring(0, longitudMaxima) + '...';
  }
  return texto;
}

// Convertir texto con formato especial a HTML (por ejemplo, **negrita**, *cursiva*)
String convertirAHTML(String texto) {
  return texto
      .replaceAll('\n', '<br/>')
      .replaceAll('**', '<b>')
      .replaceAll('*', '<i>');
}

// 4. Gestión de Eventos

// Calcular la duración de un evento en horas
Duration calcularDuracionEvento(DateTime inicio, DateTime fin) {
  return fin.difference(inicio);
}

// 5. Notificaciones y Mensajes

// Enviar una notificación a un usuario sobre un evento
void enviarNotificacion(String mensaje, String usuarioId) {
  // Lógica para enviar notificación (por ejemplo, usando Firebase Cloud Messaging)
}

// Mostrar una alerta de evento (usando paquetes como Flutter Local Notifications o Alerts)
void mostrarAlertaDeEvento(String mensaje) {
  // Lógica para mostrar la alerta
}

// 6. Manejo de Usuarios

// Verificar si un usuario es administrador
bool esAdministrador(String usuarioId) {
  // Consulta el rol del usuario en la base de datos
  return false; // Retorna 'true' si el usuario es administrador
}

// Verificar si un usuario está inscrito en un evento
bool estaInscripto(String usuarioId, String eventoId) {
  // Verifica en la base de datos si el usuario está inscrito en el evento
  return false; // Retorna 'true' si está inscrito
}

// 7. Gestión de Sedes

// Verificar si un evento se realiza en una sede específica
bool eventoEnSede(String eventoId, String sedeId) {
  // Lógica para comprobar si el evento se lleva a cabo en la sede indicada
  return false; // Retorna 'true' si el evento es en la sede
}

// 9. Gestión de Videos y Multimedia

// Obtener el thumbnail de un video desde una URL
String obtenerThumbnailDeVideo(String urlVideo) {
  // Usar alguna lógica para obtener el thumbnail del video, por ejemplo con una API
  return 'url_thumbnail_video'; // Retorna la URL del thumbnail del video
}
