import 'package:programa_profe/models/profe_model.dart';

class ProfeIdModel {
  String? status;
  int? codigoHttp;
  ProfeModel? respuesta;
  String? error;

  ProfeIdModel({this.status, this.codigoHttp, this.respuesta, this.error});

  ProfeIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'] != null ? ProfeModel.fromJson(json['respuesta']) : null;
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