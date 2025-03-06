import 'package:programa_profe/models/programa_model.dart';

class ProgramaListModel {
  String? status;
  int? codigoHttp;
  List<ProgramaModel>? respuesta;
  String? error;

  ProgramaListModel({this.status, this.codigoHttp, this.respuesta, this.error});

  ProgramaListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    if (json['respuesta'] != null) {
      respuesta = (json['respuesta'] as List)
          .map((v) => ProgramaModel.fromJson(v))
          .toList();
    }
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
