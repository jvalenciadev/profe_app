import 'package:programa_profe/models/novedad_model.dart';

class NovedadListModel {
  String? status;
  int? codigoHttp;
  List<NovedadModel>? respuesta;
  String? error;

  NovedadListModel({this.status, this.codigoHttp, this.respuesta, this.error});

  NovedadListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'] != null
        ? (json['respuesta'] as List).map((v) => NovedadModel.fromJson(v)).toList()
        : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['codigo_http'] = codigoHttp;
    if (respuesta != null) {
      data['respuesta'] = respuesta!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    return data;
  }
}
