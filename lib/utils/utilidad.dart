import 'package:intl/intl.dart';


String formatearFecha(DateTime fecha) {
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(fecha); // Por ejemplo: '12 Mar 1998'
}

String formatearFechaConHora(DateTime fecha) {
  final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm');
  return formatter.format(fecha); // Por ejemplo: '12 Mar 1998 15:30'
}

// Verificar si una fecha es válida (si es después de la fecha actual)
bool esFechaValida(DateTime fecha) {
  return fecha.isAfter(DateTime.now());
}

// Obtener la fecha actual
DateTime obtenerFechaActual() {
  return DateTime.now();
}

// 2. Gestión de Inscripciones y Validaciones

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
