class EventoModel {
  int? eveId;
  String? eveNombre;
  String? eveDescripcion;
  String? eveBanner;
  String? eveAfiche;
  DateTime? eveFecha;
  int? eveInscripcion;
  bool? eveAsistencia;
  DateTime? eveInsHoraAsisHabilitado;
  DateTime? eveInsHoraAsisDeshabilitado;
  int? eveTotalInscrito;
  String? eveLugar;
  String? etNombre;
  String? modalidades;

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

  // Mejorado: Conversion de JSON a objeto
  EventoModel.fromJson(Map<String, dynamic> json) {
    eveId = json['eve_id'] as int?;
    eveNombre = json['eve_nombre'] as String?;
    eveDescripcion = json['eve_descripcion'] as String?;
    eveBanner = json['eve_banner'] as String?;
    eveAfiche = json['eve_afiche'] as String?;
    eveFecha = _toDate(json['eve_fecha']);
    eveInscripcion = json['eve_inscripcion'] as int?;
    eveAsistencia = json['eve_asistencia'] as bool?;
    eveInsHoraAsisHabilitado = _toDate(json['eve_ins_hora_asis_habilitado']);
    eveInsHoraAsisDeshabilitado = _toDate(json['eve_ins_hora_asis_deshabilitado']);
    eveTotalInscrito = json['eve_total_inscrito'] as int?;
    eveLugar = json['eve_lugar'] as String?;
    etNombre = json['et_nombre'] as String?;
    modalidades = json['modalidades'] as String?;
  }

  // Helper para convertir el valor nulo o no nulo a DateTime
  DateTime? _toDate(dynamic value) {
    return value != null ? DateTime.parse(value) : null;
  }

  // Función de conversión de objeto a JSON manteniendo el formato
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['eve_id'] = eveId;
    data['eve_nombre'] = eveNombre;
    data['eve_descripcion'] = eveDescripcion;
    data['eve_banner'] = eveBanner;
    data['eve_afiche'] = eveAfiche;
    data['eve_fecha'] = eveFecha?.toIso8601String();
    data['eve_inscripcion'] = eveInscripcion;
    data['eve_asistencia'] = eveAsistencia;
    data['eve_ins_hora_asis_habilitado'] = eveInsHoraAsisHabilitado?.toIso8601String();
    data['eve_ins_hora_asis_deshabilitado'] = eveInsHoraAsisDeshabilitado?.toIso8601String();
    data['eve_total_inscrito'] = eveTotalInscrito;
    data['eve_lugar'] = eveLugar;
    data['et_nombre'] = etNombre;
    data['modalidades'] = modalidades;
    return data;
  }
}
