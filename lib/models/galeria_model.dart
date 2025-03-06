class GaleriaModel {
  int? galeriaId;
  String? galeriaImagen;
  String? galeriaEstado;
  int? sedeId;
  int? proId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? proNombreAbre;
  String? proNombre;
  String? depNombre;
  String? depAbreviacion;
  String? sedeNombreAbre;
  String? sedeNombre;

  GaleriaModel({
    this.galeriaId,
    this.galeriaImagen,
    this.galeriaEstado,
    this.sedeId,
    this.proId,
    this.createdAt,
    this.updatedAt,
    this.proNombreAbre,
    this.proNombre,
    this.depNombre,
    this.depAbreviacion,
    this.sedeNombreAbre,
    this.sedeNombre,
  });

  // Constructor para crear el modelo desde JSON
  GaleriaModel.fromJson(Map<String, dynamic> json) {
    galeriaId = json['galeria_id'];
    galeriaImagen = json['galeria_imagen'];
    galeriaEstado = json['galeria_estado'];
    sedeId = json['sede_id'];
    proId = json['pro_id'];
    createdAt = _toDate(json['created_at']);
    updatedAt = _toDate(json['updated_at']);
    proNombreAbre = json['pro_nombre_abre'];
    proNombre = json['pro_nombre'];
    depNombre = json['dep_nombre'];
    depAbreviacion = json['dep_abreviacion'];
    sedeNombreAbre = json['sede_nombre_abre'];
    sedeNombre = json['sede_nombre'];
  }

  // Helper para convertir el valor de fecha en formato DateTime
  DateTime? _toDate(dynamic value) {
    return value != null ? DateTime.parse(value) : null;
  }

  // Función para convertir el modelo a JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['galeria_id'] = galeriaId;
    data['galeria_imagen'] = galeriaImagen;
    data['galeria_estado'] = galeriaEstado;
    data['sede_id'] = sedeId;
    data['pro_id'] = proId;
    data['created_at'] = createdAt?.toIso8601String() ?? '';
    data['updated_at'] = updatedAt?.toIso8601String() ?? '';
    data['pro_nombre_abre'] = proNombreAbre;
    data['pro_nombre'] = proNombre;
    data['dep_nombre'] = depNombre;
    data['dep_abreviacion'] = depAbreviacion;
    data['sede_nombre_abre'] = sedeNombreAbre;
    data['sede_nombre'] = sedeNombre;
    return data;
  }
}
