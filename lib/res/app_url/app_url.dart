import 'package:flutter_dotenv/flutter_dotenv.dart';
class AppUrl {

  static String get baseUrl => dotenv.env['BASEURL'] ?? 'https://default.url/api/v1';  // Valor por defecto si no se carga la variable
  static String get eventos => '$baseUrl/eventos';
  static String get eventosId => '$baseUrl/evento';
  static String get programas => '$baseUrl/programas';
  static String get programaId => '$baseUrl/programa';
  static String get novedades => '$baseUrl/novedades';
  static String get novedadId => '$baseUrl/novedad';
  static String get sedes => '$baseUrl/sedes';
  static String get sedeId => '$baseUrl/sede';
  static String get galerias => '$baseUrl/galerias';
  static String get videos => '$baseUrl/videos';
  static String get appInfo => '$baseUrl/appInfo';
  static String get profe => '$baseUrl/profe';
}