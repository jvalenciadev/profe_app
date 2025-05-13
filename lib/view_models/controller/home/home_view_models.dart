import 'package:get/get.dart';
import 'package:programa_profe/models/home/evento_list_model.dart';
import 'package:programa_profe/models/home/novedad_list_model.dart';
import 'package:programa_profe/models/home/profe_id_model.dart';
import 'package:programa_profe/models/home/programa_list_model.dart';
import 'package:programa_profe/models/home/video_list_model.dart';
import 'package:programa_profe/repository/evento_repository/evento_repository.dart';
import 'package:programa_profe/repository/novedad_repository/novedad_repository.dart';
import '../../../data/response/status.dart';
import '../../../models/home/sede_list_mode.dart';
import '../../../repository/home_repository/hone_repository.dart';
import '../../../repository/programa_repository/programa_repository.dart';
import '../../../repository/sede_repository/sede_repository.dart';

class HomeController extends GetxController {
  // Repositorios
  final _home = HomeRepository();
  final _evento = EventoRepository();
  final _sede = SedeRepository();
  final _novedad = NovedadRepository();
  final _programa = ProgramaRepository();

  // Datos observables
  final eventoList = EventoListModel().obs;
  final sedeList = SedeListModel().obs;
  final novedadList = NovedadListModel().obs;
  final programaList = ProgramaListModel().obs;
  final profeId = ProfeIdModel().obs;
  final videoList = VideoListModel().obs;
  final error = ''.obs;

  // Estados de carga independientes por sección
  final eventosStatus = Status.LOADING.obs;
  final sedesStatus = Status.LOADING.obs;
  final novedadesStatus = Status.LOADING.obs;
  final programasStatus = Status.LOADING.obs;
  final profeStatus = Status.LOADING.obs;
  final videosStatus = Status.LOADING.obs;

  // Métodos de carga aislados
  // Future<void> loadEventos()async  {
  //   try {
  //     eventosStatus.value = Status.LOADING;
  //     final res = await _evento.eventoListApi();
  //     eventoList.value = res;
  //     eventosStatus.value = Status.COMPLETED;
  //   } catch (err) {
  //     error.value = err.toString();
  //     eventosStatus.value = Status.ERROR;
  //   }
  // }
  void loadEventos() {
    eventosStatus.value = Status.LOADING;
    _evento
        .eventoListApi()
        .then((res) {
          eventoList.value = res;
          eventosStatus.value = Status.COMPLETED;
        })
        .catchError((err) {
          error.value = err.toString();
          eventosStatus.value = Status.ERROR;
        });
  }
  void loadSedes() {
    sedesStatus.value = Status.LOADING;
    _sede
        .sedeListApi()
        .then((res) {
          sedeList.value = res;
          sedesStatus.value = Status.COMPLETED;
        })
        .catchError((err) {
          error.value = err.toString();
          sedesStatus.value = Status.ERROR;
        });
  }

  void loadNovedades() {
    novedadesStatus.value = Status.LOADING;
    _novedad
        .novedadListApi()
        .then((res) {
          novedadList.value = res;
          novedadesStatus.value = Status.COMPLETED;
        })
        .catchError((err) {
          error.value = err.toString();
          novedadesStatus.value = Status.ERROR;
        });
  }

  void loadProgramas() {
    programasStatus.value = Status.LOADING;
    _programa
        .programaListApi()
        .then((res) {
          programaList.value = res;
          programasStatus.value = Status.COMPLETED;
        })
        .catchError((err) {
          error.value = err.toString();
          programasStatus.value = Status.ERROR;
        });
  }

  void loadProfeId() {
    profeStatus.value = Status.LOADING;
    _home
        .profeIdApi()
        .then((res) {
          profeId.value = res;
          profeStatus.value = Status.COMPLETED;
        })
        .catchError((err) {
          error.value = err.toString();
          profeStatus.value = Status.ERROR;
        });
  }

  void loadVideos() {
    videosStatus.value = Status.LOADING;
    _home
        .videoListApi()
        .then((res) {
          videoList.value = res;
          videosStatus.value = Status.COMPLETED;
        })
        .catchError((err) {
          error.value = err.toString();
          videosStatus.value = Status.ERROR;
        });
  }

  @override
  void onInit() {
    super.onInit();
    // Carga inicial de todas las secciones
    loadEventos();
    loadSedes();
    loadNovedades();
    loadProgramas();
    loadProfeId();
    loadVideos();
  }

  // Método general para recargar todo si es necesario
 Future<void> refreshAll() async {
    loadEventos();
    loadSedes();
    loadNovedades();
    loadProgramas();
    loadProfeId();
    loadVideos();
  }
}
