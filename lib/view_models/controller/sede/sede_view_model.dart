import 'package:get/get.dart';
import 'package:programa_profe/models/home/sede_id_model.dart';
import 'package:programa_profe/repository/sede_repository/sede_repository.dart';
import '../../../data/response/status.dart';

class SedeController extends GetxController {
  // Repositorios
  final _sede = SedeRepository();

  // Datos observables
  final sedeId = SedeIdModel().obs;
  final error = ''.obs;

  final sedeStatus = Status.LOADING.obs;

  void loadSedes(String id) {
    sedeStatus.value = Status.LOADING;
    _sede
        .sedeIdApi(id)
        .then((res) {
          sedeId.value = res;
          sedeStatus.value = Status.COMPLETED;
        })
        .catchError((err) {
          error.value = err.toString();
          sedeStatus.value = Status.ERROR;
        });
  }
}
