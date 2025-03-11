import 'package:programa_profe/models/galeria_model.dart';

class GaleriaListModel {
  String? status;
  int? codigoHttp;
  List<GaleriaModel>? respuesta;
  String? error;

  GaleriaListModel({this.status, this.codigoHttp, this.respuesta, this.error});

  GaleriaListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'] != null
        ? (json['respuesta'] as List).map((v) => GaleriaModel.fromJson(v)).toList()
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
