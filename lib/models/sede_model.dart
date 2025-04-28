class SedeModel {
  int? sedeId;
  String? sedeImagen;
  String? sedeNombre;
  String? sedeNombreAbre;
  String? sedeDescripcion;
  String? sedeImagenResponsable1;
  String? sedeNombreResponsable1;
  String? sedeCargoResponsable1;
  String? sedeImagenResponsable2;
  String? sedeNombreResponsable2;
  String? sedeCargoResponsable2;
  int? sedeContacto1;
  int? sedeContacto2;
  String? sedeFacebook;
  String? sedeTiktok;
  String? sedeGrupoWhatsapp;
  String? sedeHorario;
  String? sedeTurno;
  String? sedeUbicacion;
  String? sedeLatitud;
  String? sedeLongitud;
  String? sedeEstado;
  int? depId;
  String? createdAt;
  String? updatedAt;
  String? depNombre;

  // Constructor
  SedeModel({
    this.sedeId,
    this.sedeImagen,
    this.sedeNombre,
    this.sedeNombreAbre,
    this.sedeDescripcion,
    this.sedeImagenResponsable1,
    this.sedeNombreResponsable1,
    this.sedeCargoResponsable1,
    this.sedeImagenResponsable2,
    this.sedeNombreResponsable2,
    this.sedeCargoResponsable2,
    this.sedeContacto1,
    this.sedeContacto2,
    this.sedeFacebook,
    this.sedeTiktok,
    this.sedeGrupoWhatsapp,
    this.sedeHorario,
    this.sedeTurno,
    this.sedeUbicacion,
    this.sedeLatitud,
    this.sedeLongitud,
    this.sedeEstado,
    this.depId,
    this.createdAt,
    this.updatedAt,
    this.depNombre,
  });

  // Factory constructor to create a SedeModel from JSON
  SedeModel.fromJson(Map<String, dynamic> json) {
    sedeId = json['sede_id'] as int?;
    sedeImagen = json['sede_imagen'] as String?;
    sedeNombre = json['sede_nombre'] as String?;
    sedeNombreAbre = json['sede_nombre_abre'] as String?;
    sedeDescripcion = json['sede_descripcion'] as String?;
    sedeImagenResponsable1 = json['sede_imagen_responsable1'] as String?;
    sedeNombreResponsable1 = json['sede_nombre_responsable1'] as String?;
    sedeCargoResponsable1 = json['sede_cargo_responsable1'] as String?;
    sedeImagenResponsable2 = json['sede_imagen_responsable2'] as String?;
    sedeNombreResponsable2 = json['sede_nombre_responsable2'] as String?;
    sedeCargoResponsable2 = json['sede_cargo_responsable2'] as String?;
    sedeContacto1 = json['sede_contacto_1'] as int?;
    sedeContacto2 = json['sede_contacto_2'] as int?;
    sedeFacebook = json['sede_facebook'] as String?;
    sedeTiktok = json['sede_tiktok'] as String?;
    sedeGrupoWhatsapp = json['sede_grupo_whatsapp'] as String?;
    sedeHorario = json['sede_horario'] as String?;
    sedeTurno = json['sede_turno'] as String?;
    sedeUbicacion = json['sede_ubicacion'] as String?;
    sedeLatitud = json['sede_latitud'] as String?;
    sedeLongitud = json['sede_longitud'] as String?;
    sedeEstado = json['sede_estado'] as String?;
    depId = json['dep_id'] as int?;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    depNombre = json['dep_nombre'] as String?;
  }

  // Convert the SedeModel instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sede_id'] = sedeId;
    data['sede_imagen'] = sedeImagen;
    data['sede_nombre'] = sedeNombre;
    data['sede_nombre_abre'] = sedeNombreAbre;
    data['sede_descripcion'] = sedeDescripcion;
    data['sede_imagen_responsable1'] = sedeImagenResponsable1;
    data['sede_nombre_responsable1'] = sedeNombreResponsable1;
    data['sede_cargo_responsable1'] = sedeCargoResponsable1;
    data['sede_imagen_responsable2'] = sedeImagenResponsable2;
    data['sede_nombre_responsable2'] = sedeNombreResponsable2;
    data['sede_cargo_responsable2'] = sedeCargoResponsable2;
    data['sede_contacto_1'] = sedeContacto1;
    data['sede_contacto_2'] = sedeContacto2;
    data['sede_facebook'] = sedeFacebook;
    data['sede_tiktok'] = sedeTiktok;
    data['sede_grupo_whatsapp'] = sedeGrupoWhatsapp;
    data['sede_horario'] = sedeHorario;
    data['sede_turno'] = sedeTurno;
    data['sede_ubicacion'] = sedeUbicacion;
    data['sede_latitud'] = sedeLatitud;
    data['sede_longitud'] = sedeLongitud;
    data['sede_estado'] = sedeEstado;
    data['dep_id'] = depId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['dep_nombre'] = depNombre;
    return data;
  }
}
