import '../utils/utilidad.dart';

class NovedadModel {
  int? blogId;
  String? blogImagen;
  String? blogTitulo;
  String? blogDescripcion;
  String? blogEstado;
  String? createdAt;
  String? updatedAt;

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
      createdAt: formatFechaCorta(json['created_at']),
      updatedAt: json['updated_at'],
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
