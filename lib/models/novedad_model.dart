class NovedadModel {
  int? blogId;
  String? blogImagen;
  String? blogTitulo;
  String? blogDescripcion;
  String? blogEstado;
  DateTime? createdAt;
  DateTime? updatedAt;

  NovedadModel({
    this.blogId,
    this.blogImagen,
    this.blogTitulo,
    this.blogDescripcion,
    this.blogEstado,
    this.createdAt,
    this.updatedAt,
  });

  // Constructor de fábrica para crear una instancia a partir de JSON
  factory NovedadModel.fromJson(Map<String, dynamic> json) {
    return NovedadModel(
      blogId: json['blog_id'],
      blogImagen: json['blog_imagen'],
      blogTitulo: json['blog_titulo'],
      blogDescripcion: json['blog_descripcion'],
      blogEstado: json['blog_estado'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Método para convertir la instancia en un Map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blog_id'] = blogId;
    data['blog_imagen'] = blogImagen;
    data['blog_titulo'] = blogTitulo;
    data['blog_descripcion'] = blogDescripcion;
    data['blog_estado'] = blogEstado;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }
}
