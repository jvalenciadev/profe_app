import 'dart:convert';
import '../utils/utilidad.dart';

class EventoModel {
  int? eveId;
  String? eveNombre;
  String? eveDescripcion;
  String? eveBanner;
  String? eveAfiche;
  String? eveFecha;
  int? eveInscripcion;
  bool? eveAsistencia;
  String? eveInsHoraAsisHabilitado;
  String? eveInsHoraAsisDeshabilitado;
  int? eveTotalInscrito;
  String? eveLugar;
  String? etNombre;
  List<String>? modalidades;

  EventoModel({
    this.eveId,
    this.eveNombre,
    this.eveDescripcion,
    this.eveBanner,
    this.eveAfiche,
    this.eveFecha,
    this.eveInscripcion,
    this.eveAsistencia,
    this.eveInsHoraAsisHabilitado,
    this.eveInsHoraAsisDeshabilitado,
    this.eveTotalInscrito,
    this.eveLugar,
    this.etNombre,
    this.modalidades,
  });

  

  // Constructor desde JSON
  EventoModel.fromJson(Map<String, dynamic> json) {
    eveId = json['eve_id'] as int?;
    eveNombre = json['eve_nombre'] as String?;
    eveDescripcion = json['eve_descripcion'] as String?;
    eveBanner = json['eve_banner'] as String?;
    eveAfiche = json['eve_afiche'] as String?;
    eveFecha = formatFechaCorta(json['eve_fecha']);
    eveInscripcion = json['eve_inscripcion'] as int?;
    eveAsistencia = (json['eve_asistencia'] == 1);
    eveInsHoraAsisHabilitado = parseHora(json['eve_ins_hora_asis_habilitado']);
    eveInsHoraAsisDeshabilitado = parseHora(json['eve_ins_hora_asis_deshabilitado']);
    eveTotalInscrito = json['eve_total_inscrito'] as int?;
    eveLugar = json['eve_lugar'] as String?;
    etNombre = json['et_nombre'] as String?;
    modalidades = parseLista(json['modalidades']);
  }

  // Conversión a JSON
  Map<String, dynamic> toJson() {
    return {
      'eve_id': eveId,
      'eve_nombre': eveNombre,
      'eve_descripcion': eveDescripcion,
      'eve_banner': eveBanner,
      'eve_afiche': eveAfiche,
      'eve_fecha': eveFecha,
      'eve_inscripcion': eveInscripcion,
      'eve_asistencia': eveAsistencia == true ? 1 : 0,
      'eve_ins_hora_asis_habilitado': eveInsHoraAsisHabilitado,
      'eve_ins_hora_asis_deshabilitado': eveInsHoraAsisDeshabilitado,
      'eve_total_inscrito': eveTotalInscrito,
      'eve_lugar': eveLugar,
      'et_nombre': etNombre,
      'modalidades': jsonEncode(modalidades),
    };
  }
}
