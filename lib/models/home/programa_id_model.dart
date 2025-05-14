import 'package:programa_profe/models/galeria_model.dart';
import 'package:programa_profe/models/programa_model.dart';

class ProgramaIdModel {
  String? status;
  int? codigoHttp;
  Respuesta? respuesta;
  String? error;

  ProgramaIdModel({this.status, this.codigoHttp, this.respuesta, this.error});

  ProgramaIdModel.fromJson(Map<String, dynamic> json) {
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
  ProgramaModel? programa;
  List<ProgramaSedeTurno>? programaSedeTurno;
  Restriccion? restriccion;
  List<GaleriaModel>? galeriasPorPrograma;

  Respuesta({
    this.programa,
    this.programaSedeTurno,
    this.restriccion,
    this.galeriasPorPrograma,
  });

  Respuesta.fromJson(Map<String, dynamic> json) {
    programa =
        json['programa'] != null
            ? ProgramaModel.fromJson(json['programa'])
            : null;

    if (json['programa_sede_turno'] != null) {
      programaSedeTurno =
          (json['programa_sede_turno'] as List)
              .map((i) => ProgramaSedeTurno.fromJson(i))
              .toList();
    }

    restriccion =
        json['restriccion'] != null
            ? Restriccion.fromJson(json['restriccion'])
            : null;

    if (json['galeriasPorPrograma'] != null) {
      galeriasPorPrograma =
          (json['galeriasPorPrograma'] as List)
              .map((i) => GaleriaModel.fromJson(i))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (programa != null) {
      data['programa'] = programa!.toJson();
    }
    if (programaSedeTurno != null) {
      data['programa_sede_turno'] =
          programaSedeTurno!.map((v) => v.toJson()).toList();
    }
    if (restriccion != null) {
      data['restriccion'] = restriccion!.toJson();
    }
    if (galeriasPorPrograma != null) {
      data['galeriasPorPrograma'] =
          galeriasPorPrograma!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProgramaSedeTurno {
  String? sedeNombre;
  String? depNombre;
  int? sedeContacto1;
  String? proTurIds;
  int? sedeContacto2;
  int? sedeId;
  String? programaturno;

  ProgramaSedeTurno({
    this.sedeNombre,
    this.depNombre,
    this.sedeContacto1,
    this.proTurIds,
    this.sedeContacto2,
    this.sedeId,
    this.programaturno,
  });

  ProgramaSedeTurno.fromJson(Map<String, dynamic> json) {
    sedeNombre = json['sede_nombre'];
    depNombre = json['dep_nombre'];
    sedeContacto1 = json['sede_contacto_1'];
    proTurIds = json['pro_tur_ids'];
    sedeContacto2 = json['sede_contacto_2'];
    sedeId = json['sede_id'];
    programaturno = json['programaturno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sede_nombre'] = sedeNombre;
    data['dep_nombre'] = depNombre;
    data['sede_contacto_1'] = sedeContacto1;
    data['pro_tur_ids'] = proTurIds;
    data['sede_contacto_2'] = sedeContacto2;
    data['sede_id'] = sedeId;
    data['programaturno'] = programaturno;
    return data;
  }
}

class Restriccion {
  String? resDescripcion;

  Restriccion({this.resDescripcion});

  Restriccion.fromJson(Map<String, dynamic> json) {
    resDescripcion = json['res_descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['res_descripcion'] = resDescripcion;
    return data;
  }
}
