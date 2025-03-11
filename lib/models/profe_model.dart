class ProfeModel {
  int? profeId;
  String? profeImagen;
  String? profeNombre;
  String? profeDescripcion;
  String? profeSobreNosotros;
  String? profeMision;
  String? profeVision;
  String? profeActividad;
  DateTime? profeFechaCreacion;
  String? profeCorreo;
  String? profeCelular;
  String? profeTelefono;
  String? profePagina;
  String? profeFacebook;
  String? profeTiktok;
  String? profeYoutube;
  String? profeUbicacion;
  String? profeLatitud;
  String? profeLongitud;
  String? profeBanner;
  String? profeAfiche;
  String? profeConvocatoria;
  String? profeEstado;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProfeModel({
    this.profeId,
    this.profeImagen,
    this.profeNombre,
    this.profeDescripcion,
    this.profeSobreNosotros,
    this.profeMision,
    this.profeVision,
    this.profeActividad,
    this.profeFechaCreacion,
    this.profeCorreo,
    this.profeCelular,
    this.profeTelefono,
    this.profePagina,
    this.profeFacebook,
    this.profeTiktok,
    this.profeYoutube,
    this.profeUbicacion,
    this.profeLatitud,
    this.profeLongitud,
    this.profeBanner,
    this.profeAfiche,
    this.profeConvocatoria,
    this.profeEstado,
    this.createdAt,
    this.updatedAt,
  });

  ProfeModel.fromJson(Map<String, dynamic> json) {
    profeId = json['profe_id'];
    profeImagen = json['profe_imagen'];
    profeNombre = json['profe_nombre'];
    profeDescripcion = json['profe_descripcion'];
    profeSobreNosotros = json['profe_sobre_nosotros'];
    profeMision = json['profe_mision'];
    profeVision = json['profe_vision'];
    profeActividad = json['profe_actividad'];
    profeFechaCreacion = json['profe_fecha_creacion'] != null ? DateTime.parse(json['profe_fecha_creacion']) : null;
    profeCorreo = json['profe_correo'];
    profeCelular = json['profe_celular'];
    profeTelefono = json['profe_telefono'];
    profePagina = json['profe_pagina'];
    profeFacebook = json['profe_facebook'];
    profeTiktok = json['profe_tiktok'];
    profeYoutube = json['profe_youtube'];
    profeUbicacion = json['profe_ubicacion'];
    profeLatitud = json['profe_latitud'];
    profeLongitud = json['profe_longitud'];
    profeBanner = json['profe_banner'];
    profeAfiche = json['profe_afiche'];
    profeConvocatoria = json['profe_convocatoria'];
    profeEstado = json['profe_estado'];
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profe_id'] = profeId;
    data['profe_imagen'] = profeImagen;
    data['profe_nombre'] = profeNombre;
    data['profe_descripcion'] = profeDescripcion;
    data['profe_sobre_nosotros'] = profeSobreNosotros;
    data['profe_mision'] = profeMision;
    data['profe_vision'] = profeVision;
    data['profe_actividad'] = profeActividad;
    data['profe_fecha_creacion'] = profeFechaCreacion?.toIso8601String();
    data['profe_correo'] = profeCorreo;
    data['profe_celular'] = profeCelular;
    data['profe_telefono'] = profeTelefono;
    data['profe_pagina'] = profePagina;
    data['profe_facebook'] = profeFacebook;
    data['profe_tiktok'] = profeTiktok;
    data['profe_youtube'] = profeYoutube;
    data['profe_ubicacion'] = profeUbicacion;
    data['profe_latitud'] = profeLatitud;
    data['profe_longitud'] = profeLongitud;
    data['profe_banner'] = profeBanner;
    data['profe_afiche'] = profeAfiche;
    data['profe_convocatoria'] = profeConvocatoria;
    data['profe_estado'] = profeEstado;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }
}
