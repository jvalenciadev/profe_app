class EstadoModel {
  String? status;
  int? codigoHttp;
  String? respuesta;
  String? error;

  EstadoModel({this.status, this.codigoHttp, this.respuesta, this.error});

  EstadoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['codigo_http'] = codigoHttp;
    data['respuesta'] = respuesta;
    data['error'] = error;
    return data;
  }
}