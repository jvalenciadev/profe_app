class PersonaEstadoModel {
  String? status;
  int? codigoHttp;
  PersonaModel? respuesta;
  String? error;

  PersonaEstadoModel({
    this.status,
    this.codigoHttp,
    this.respuesta,
    this.error,
  });

  PersonaEstadoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as String?;
    codigoHttp = json['codigo_http'] as int?;
    respuesta =
        json['respuesta'] != null
            ? PersonaModel.fromJson(json['respuesta'] as Map<String, dynamic>)
            : null;
    error = json['error'] as String?;
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'codigo_http': codigoHttp,
    'respuesta': respuesta?.toJson(),
    'error': error,
  };
}

class PersonaModel {
  bool? inscrito; // <— Cambiado a bool
  String? estado;
  Persona? persona;

  PersonaModel({this.inscrito, this.estado, this.persona});

  PersonaModel.fromJson(Map<String, dynamic> json) {
    inscrito = json['inscrito'] as bool?; // viene true/false
    estado = json['estado'] as String?;
    persona =
        json['persona'] != null
            ? Persona.fromJson(json['persona'] as Map<String, dynamic>)
            : null;
  }

  Map<String, dynamic> toJson() => {
    'inscrito': inscrito,
    'estado': estado,
    'persona': persona?.toJson(),
  };
}

class Persona {
  int? ci;
  String? complemento;
  String? nombre1;
  String? apellido1;
  String? apellido2;
  String? celular; // si celular es numérico, cámbialo a int?
  String? correo;
  String? fechaNacimiento;
  String? pmNombre;
  String? depNombre;
  String? eveNombre;
  String? etNombre;

  Persona({
    this.ci,
    this.complemento,
    this.nombre1,
    this.apellido1,
    this.apellido2,
    this.celular,
    this.correo,
    this.fechaNacimiento,
    this.pmNombre,
    this.depNombre,
    this.eveNombre,
    this.etNombre,
  });

  Persona.fromJson(Map<String, dynamic> json) {
    ci = json['ci'] as int?;
    complemento = json['complemento'] as String?;
    nombre1 = json['nombre1'] as String?;
    apellido1 = json['apellido1'] as String?;
    apellido2 = json['apellido2'] as String?;
    celular = json['celular']?.toString(); // si viene int, lo conviertes
    correo = json['correo'] as String?;
    fechaNacimiento = json['fecha_nacimiento'] as String?;
    pmNombre = json['pm_nombre'] as String?;
    depNombre = json['dep_nombre'] as String?;
    eveNombre = json['eve_nombre'] as String?;
    etNombre = json['et_nombre'] as String?;
  }

  Map<String, dynamic> toJson() => {
    'ci': ci,
    'complemento': complemento,
    'nombre1': nombre1,
    'apellido1': apellido1,
    'apellido2': apellido2,
    'celular': celular,
    'correo': correo,
    'fecha_nacimiento': fechaNacimiento,
    'pm_nombre': pmNombre,
    'dep_nombre': depNombre,
    'eve_nombre': eveNombre,
    'et_nombre': etNombre,
  };
}
