class CuestionarioModel {
  String? status;
  int? codigoHttp;
  Cuestionario? respuesta;
  String? error;

  CuestionarioModel({this.status, this.codigoHttp, this.respuesta, this.error});

  CuestionarioModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['codigo_http'] = codigoHttp;
    data['respuesta'] = respuesta;
    data['error'] = error;
    return data;
  }
}
class Cuestionario {
  String? eveCueId;
  String? eveCueTitulo;
  String? eveCueDescripcion;
  DateTime? eveCueFecha_ini;
  DateTime? eveCueFecha_fin;
  DateTime? eveCueTiempo;
  int? eveCuePtsMax;
  int? eveId;

  Cuestionario({
    this.eveCueId,
    this.eveCueTitulo,
    this.eveCueDescripcion,
    this.eveCueFecha_ini,
    this.eveCueFecha_fin,
    this.eveCueTiempo,
    this.eveCuePtsMax,
    this.eveId,
  });

  Cuestionario.fromJson(Map<String, dynamic> json) {
    eveCueId = json['eve_cue_id'];
    eveCueTitulo = json['eve_cue_titulo'];
    eveCueDescripcion = json['eve_cue_descripcion'];
    eveCueFecha_ini = json['eve_cue_fecha_ini'] != null
        ? DateTime.tryParse(json['eve_cue_fecha_ini'])
        : null;
    eveCueFecha_fin = json['eve_cue_fecha_fin'] != null
        ? DateTime.tryParse(json['eve_cue_fecha_fin'])
        : null;
    eveCueTiempo = json['eve_cue_tiempo'] != null
        ? DateTime.tryParse(json['eve_cue_tiempo'])
        : null;
    eveCuePtsMax = json['eve_cue_pts_max'];
    eveId = json['eve_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['eve_cue_id'] = eveCueId;
    data['eve_cue_titulo'] = eveCueTitulo;
    data['eve_cue_descripcion'] = eveCueDescripcion;
    data['eve_cue_fecha_ini'] = eveCueFecha_ini?.toIso8601String();
    data['eve_cue_fecha_fin'] = eveCueFecha_fin?.toIso8601String();
    data['eve_cue_tiempo'] = eveCueTiempo?.toIso8601String();
    data['eve_cue_pts_max'] = eveCuePtsMax;
    data['eve_id'] = eveId;
    return data;
  }
}
