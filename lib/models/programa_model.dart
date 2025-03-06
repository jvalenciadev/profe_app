class ProgramaModel {
  int? proId;
  String? proCodigo;
  String? proNombre;
  String? proNombreAbre;
  String? proContenido;
  String? proHorario;
  int? proCargaHoraria;
  int? proCosto;
  String? proBanner;
  String? proAfiche;
  String? proConvocatoria;
  String? proFechaInicioInscripcion;
  String? proFechaFinInscripcion;
  String? proFechaInicioClase;
  int? proEstadoInscripcion;
  String? proEstado;
  int? pdId;
  int? pvId;
  int? proTipId;
  int? pmId;
  String? createdAt;
  String? updatedAt;
  String? proTipNombre;
  String? pdNombre;
  int? pdSemana;
  String? pmNombre;
  String? pvNombre;
  String? pvRomano;
  String? pvGestion;

  ProgramaModel({
    this.proId,
    this.proCodigo,
    this.proNombre,
    this.proNombreAbre,
    this.proContenido,
    this.proHorario,
    this.proCargaHoraria,
    this.proCosto,
    this.proBanner,
    this.proAfiche,
    this.proConvocatoria,
    this.proFechaInicioInscripcion,
    this.proFechaFinInscripcion,
    this.proFechaInicioClase,
    this.proEstadoInscripcion,
    this.proEstado,
    this.pdId,
    this.pvId,
    this.proTipId,
    this.pmId,
    this.createdAt,
    this.updatedAt,
    this.proTipNombre,
    this.pdNombre,
    this.pdSemana,
    this.pmNombre,
    this.pvNombre,
    this.pvRomano,
    this.pvGestion,
  });

  // Constructor from JSON
  factory ProgramaModel.fromJson(Map<String, dynamic> json) {
    return ProgramaModel(
      proId: json['pro_id'],
      proCodigo: json['pro_codigo'],
      proNombre: json['pro_nombre'],
      proNombreAbre: json['pro_nombre_abre'],
      proContenido: json['pro_contenido'],
      proHorario: json['pro_horario'],
      proCargaHoraria: json['pro_carga_horaria'],
      proCosto: json['pro_costo'],
      proBanner: json['pro_banner'],
      proAfiche: json['pro_afiche'],
      proConvocatoria: json['pro_convocatoria'],
      proFechaInicioInscripcion: json['pro_fecha_inicio_inscripcion'],
      proFechaFinInscripcion: json['pro_fecha_fin_inscripcion'],
      proFechaInicioClase: json['pro_fecha_inicio_clase'],
      proEstadoInscripcion: json['pro_estado_inscripcion'],
      proEstado: json['pro_estado'],
      pdId: json['pd_id'],
      pvId: json['pv_id'],
      proTipId: json['pro_tip_id'],
      pmId: json['pm_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      proTipNombre: json['pro_tip_nombre'],
      pdNombre: json['pd_nombre'],
      pdSemana: json['pd_semana'],
      pmNombre: json['pm_nombre'],
      pvNombre: json['pv_nombre'],
      pvRomano: json['pv_romano'],
      pvGestion: json['pv_gestion'],
    );
  }

  // To JSON maintaining the original format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pro_id'] = proId;
    data['pro_codigo'] = proCodigo;
    data['pro_nombre'] = proNombre;
    data['pro_nombre_abre'] = proNombreAbre;
    data['pro_contenido'] = proContenido;
    data['pro_horario'] = proHorario;
    data['pro_carga_horaria'] = proCargaHoraria;
    data['pro_costo'] = proCosto;
    data['pro_banner'] = proBanner;
    data['pro_afiche'] = proAfiche;
    data['pro_convocatoria'] = proConvocatoria;
    data['pro_fecha_inicio_inscripcion'] = proFechaInicioInscripcion;
    data['pro_fecha_fin_inscripcion'] = proFechaFinInscripcion;
    data['pro_fecha_inicio_clase'] = proFechaInicioClase;
    data['pro_estado_inscripcion'] = proEstadoInscripcion;
    data['pro_estado'] = proEstado;
    data['pd_id'] = pdId;
    data['pv_id'] = pvId;
    data['pro_tip_id'] = proTipId;
    data['pm_id'] = pmId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['pro_tip_nombre'] = proTipNombre;
    data['pd_nombre'] = pdNombre;
    data['pd_semana'] = pdSemana;
    data['pm_nombre'] = pmNombre;
    data['pv_nombre'] = pvNombre;
    data['pv_romano'] = pvRomano;
    data['pv_gestion'] = pvGestion;
    return data;
  }
}
