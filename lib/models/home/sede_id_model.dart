import '../galeria_model.dart';
import '../sede_model.dart';

class SedeIdModel {
  String? status;
  int? codigoHttp;
  Respuesta? respuesta;
  String? error;

  SedeIdModel({this.status, this.codigoHttp, this.respuesta, this.error});

  SedeIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta =
        json['respuesta'] != null
            ? Respuesta.fromJson(json['respuesta'])
            : null;
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

class Respuesta {
  SedeModel? sede;
  List<GaleriaModel>? galerias;

  Respuesta({this.sede, this.galerias});

  Respuesta.fromJson(Map<String, dynamic> json) {
    sede = json['sede'] != null ? SedeModel.fromJson(json['sede']) : null;

    if (json['galerias'] != null) {
      galerias =
          (json['galerias'] as List)
              .map((i) => GaleriaModel.fromJson(i))
              .toList();
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (sede != null) {
      data['sede'] = sede!.toJson();
    }

    if (galerias != null) {
      data['galerias'] = galerias!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
