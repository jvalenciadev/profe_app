import 'package:programa_profe/models/sede_model.dart';

class SedeIdModel {
  String? status;
  int? codigoHttp;
  SedeModel? respuesta;
  String? error;

  SedeIdModel({this.status, this.codigoHttp, this.respuesta, this.error});

  SedeIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'] != null ? SedeModel.fromJson(json['respuesta']) : null;
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