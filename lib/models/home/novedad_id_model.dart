import 'package:programa_profe/models/novedad_model.dart';

class NovedadIdModel {
  String? status;
  int? codigoHttp;
  NovedadModel? respuesta;
  String? error;

  NovedadIdModel({this.status, this.codigoHttp, this.respuesta, this.error});

  NovedadIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'] != null ? NovedadModel.fromJson(json['respuesta']) : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['codigo_http'] = codigoHttp;
    if (respuesta != null) {
      data['respuesta'] = respuesta!.toJson();
    }
    data['error'] = error;
    return data;
  }
}