class OpcionesModel {
  String? status;
  int? codigoHttp;
  List<Pregunta>? respuesta;
  String? error;

  OpcionesModel({this.status, this.codigoHttp, this.respuesta, this.error});

  OpcionesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    codigoHttp = json['codigo_http'];

    if (json['respuesta'] != null) {
      respuesta = (json['respuesta'] as List)
          .map((e) => Pregunta.fromJson(e))
          .toList();
    }

    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "codigo_http": codigoHttp,
      "respuesta": respuesta?.map((e) => e.toJson()).toList(),
      "error": error
    };
  }
}
class Pregunta {
  int? id;
  String? texto;
  String? tipo;
  int? obligatorio;
  String? respuestaCorrecta;
  int? cueId;
  List<Opcion>? opciones;

  Pregunta({
    this.id,
    this.texto,
    this.tipo,
    this.obligatorio,
    this.respuestaCorrecta,
    this.cueId,
    this.opciones,
  });

  Pregunta.fromJson(Map<String, dynamic> json) {
    id = json['eve_pre_id'];
    texto = json['eve_pre_texto'];
    tipo = json['eve_pre_tipo'];
    obligatorio = json['eve_pre_obligatorio'];
    respuestaCorrecta = json['eve_pre_respuesta_correcta'];
    cueId = json['eve_cue_id'];

    if (json['opciones'] != null) {
      opciones = (json['opciones'] as List)
          .map((e) => Opcion.fromJson(e))
          .toList();
    } else {
      opciones = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "eve_pre_id": id,
      "eve_pre_texto": texto,
      "eve_pre_tipo": tipo,
      "eve_pre_obligatorio": obligatorio,
      "eve_pre_respuesta_correcta": respuestaCorrecta,
      "eve_cue_id": cueId,
      "opciones": opciones?.map((e) => e.toJson()).toList(),
    };
  }
}
class Opcion {
  int? id;
  String? texto;
  int? esCorrecta;

  Opcion({this.id, this.texto, this.esCorrecta});

  Opcion.fromJson(Map<String, dynamic> json) {
    id = json['eve_opc_id'];
    texto = json['eve_opc_texto'];
    esCorrecta = json['eve_opc_es_correcta'];
  }

  Map<String, dynamic> toJson() {
    return {
      "eve_opc_id": id,
      "eve_opc_texto": texto,
      "eve_opc_es_correcta": esCorrecta,
    };
  }
}
