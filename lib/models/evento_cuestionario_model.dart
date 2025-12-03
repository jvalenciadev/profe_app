import '../utils/utilidad.dart';

class CuestionarioModel {
  String? status;
  int? codigoHttp;
  Cuestionario? respuesta;
  String? error;

  CuestionarioModel({this.status, this.codigoHttp, this.respuesta, this.error});

  CuestionarioModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'] != null
        ? Cuestionario.fromJson(json['respuesta'])
        : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['codigo_http'] = codigoHttp;
    data['respuesta'] = respuesta?.toJson(); 
    data['error'] = error;
    return data;
  }
}
class Cuestionario {
  String? eveCueId;
  String? eveCueTitulo;
  String? eveCueDescripcion;
  DateTime? eveCueFechaIni;
  DateTime? eveCueFechaFin;
  Duration? eveCueTiempo;
  int? eveCuePtsMax;
  int? eveId;

  Cuestionario({
    this.eveCueId,
    this.eveCueTitulo,
    this.eveCueDescripcion,
    this.eveCueFechaIni,
    this.eveCueFechaFin,
    this.eveCueTiempo,
    this.eveCuePtsMax,
    this.eveId,
  });

  Cuestionario.fromJson(Map<String, dynamic> json) {
    eveCueId = json['eve_cue_id'];
    eveCueTitulo = json['eve_cue_titulo'];
    eveCueDescripcion = json['eve_cue_descripcion'];
    eveCueFechaIni = json['eve_cue_fecha_ini'] != null
        ? DateTime.tryParse(json['eve_cue_fecha_ini'])
        : null;
    eveCueFechaFin = json['eve_cue_fecha_fin'] != null
        ? DateTime.tryParse(json['eve_cue_fecha_fin'])
        : null;
    if (json['eve_cue_tiempo'] != null) {
      final t = json['eve_cue_tiempo'].split(":"); // ["00","15","00"]
      eveCueTiempo = Duration(
        hours: int.parse(t[0]),
        minutes: int.parse(t[1]),
        seconds: int.parse(t[2]),
      );
    } else {
      eveCueTiempo = null;
    }
    eveCuePtsMax = json['eve_cue_pts_max'];
    eveId = json['eve_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['eve_cue_id'] = eveCueId;
    data['eve_cue_titulo'] = eveCueTitulo;
    data['eve_cue_descripcion'] = eveCueDescripcion;
    data['eve_cue_fecha_ini'] = eveCueFechaIni?.toIso8601String();
    data['eve_cue_fecha_fin'] = eveCueFechaFin?.toIso8601String();
    data['eve_cue_tiempo'] = durationToString(eveCueTiempo);
    data['eve_cue_pts_max'] = eveCuePtsMax;
    data['eve_id'] = eveId;
    return data;
  }
}
