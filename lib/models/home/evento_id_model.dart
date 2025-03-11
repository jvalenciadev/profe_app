import 'package:programa_profe/models/evento_model.dart';

class EventoIdModel {
  String? status;
  int? codigoHttp;
  EventoModel? respuesta;
  String? error;

  EventoIdModel({this.status, this.codigoHttp, this.respuesta, this.error});

  EventoIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'] != null ? EventoModel.fromJson(json['respuesta']) : null;
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