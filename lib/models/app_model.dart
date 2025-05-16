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
  List<PageData>? pages;
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
    this.pages,
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
    pages = (json['pages'] as List<dynamic>?)
          ?.map((e) => PageData.fromJson(e))
          .toList();
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
    data['pages'] = pages?.map((e) => e.toJson()).toList();
    data['terminos_url'] = terminosUrl;
    data['privacidad_url'] = privacidadUrl;
    return data;
  }
}


class PageData {
  String? title;
  String? body;
  String? imageUrl;
  List<SocialData>? socials;

  PageData({
    this.title,
    this.body,
    this.imageUrl,
    this.socials,
  });

  factory PageData.fromJson(Map<String, dynamic> json) {
    return PageData(
      title: json['title'],
      body: json['body'],
      imageUrl: json['imageUrl'],
      socials: (json['socials'] as List<dynamic>?)
          ?.map((e) => SocialData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'socials': socials?.map((e) => e.toJson()).toList(),
    };
  }
}

class SocialData {
  String? icon;
  String? url;
  String? color;

  SocialData({
    this.icon,
    this.url,
    this.color,
  });

  factory SocialData.fromJson(Map<String, dynamic> json) {
    return SocialData(
      icon: json['icon'],
      url: json['url'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'url': url,
      'color': color,
    };
  }
}
