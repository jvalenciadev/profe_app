
class AppInfoModel {
  final String? status;
  final int? codigoHttp;
  final AppInfoData? respuesta;
  final String? error;

  AppInfoModel({
    this.status,
    this.codigoHttp,
    this.respuesta,
    this.error,
  });

  factory AppInfoModel.fromJson(Map<String, dynamic> json) {
    return AppInfoModel(
      status: json['status'] as String?,
      codigoHttp: json['codigo_http'] as int?,
      respuesta: json['respuesta'] != null
          ? AppInfoData.fromJson(json['respuesta'])
          : null,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'codigo_http': codigoHttp,
      'respuesta': respuesta?.toJson(),
      'error': error,
    };
  }
}
class AppInfoData {
  int? id;
  String? logo;
  String? icono;
  String? nombre;
  String? versionActual;
  String? versionMinima;
  DateTime? ultimaActualizacion;
  String? playstoreUrl;
  String? sitioWeb;
  String? contactoSoporte;
  bool? estadoMantenimiento;
  List<String>? novedades;
  String? terminosUrl;
  String? privacidadUrl;

  AppInfoData({
    this.id,
    this.logo,
    this.icono,
    this.nombre,
    this.versionActual,
    this.versionMinima,
    this.ultimaActualizacion,
    this.playstoreUrl,
    this.sitioWeb,
    this.contactoSoporte,
    this.estadoMantenimiento,
    this.novedades,
    this.terminosUrl,
    this.privacidadUrl,
  });

  AppInfoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    icono = json['icono'];
    nombre = json['nombre'];
    versionActual = json['version_actual'];
    versionMinima = json['version_minima'];
    ultimaActualizacion = json['ultima_actualizacion'] != null
        ? DateTime.tryParse(json['ultima_actualizacion'])
        : null;
    playstoreUrl = json['playstore_url'];
    sitioWeb = json['sitio_web'];
    contactoSoporte = json['contacto_soporte'];
    estadoMantenimiento = json['estado_mantenimiento'];
    novedades = (json['novedades'] as List<dynamic>?)?.map((e) => e.toString()).toList();
    terminosUrl = json['terminos_url'];
    privacidadUrl = json['privacidad_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['logo'] = logo;
    data['icono'] = icono;
    data['nombre'] = nombre;
    data['version_actual'] = versionActual;
    data['version_minima'] = versionMinima;
    data['ultima_actualizacion'] = ultimaActualizacion?.toIso8601String();
    data['playstore_url'] = playstoreUrl;
    data['sitio_web'] = sitioWeb;
    data['contacto_soporte'] = contactoSoporte;
    data['estado_mantenimiento'] = estadoMantenimiento;
    data['novedades'] = novedades;
    data['terminos_url'] = terminosUrl;
    data['privacidad_url'] = privacidadUrl;
    return data;
  }
}