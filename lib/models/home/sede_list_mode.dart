import 'package:programa_profe/models/sede_model.dart';

class SedeListModel {
  String? status;
  int? codigoHttp;
  List<SedeModel>? respuesta;
  String? error;

  SedeListModel({this.status, this.codigoHttp, this.respuesta, this.error});

  SedeListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'] != null
        ? (json['respuesta'] as List).map((v) => SedeModel.fromJson(v)).toList()
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
