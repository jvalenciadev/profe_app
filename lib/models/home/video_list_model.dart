import 'package:programa_profe/models/video_model.dart';

class VideoListModel {
  String? status;
  int? codigoHttp;
  List<VideoModel>? respuesta;
  String? error;

  VideoListModel({this.status, this.codigoHttp, this.respuesta, this.error});

  VideoListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];
    respuesta = json['respuesta'] != null
        ? (json['respuesta'] as List).map((v) => VideoModel.fromJson(v)).toList()
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
