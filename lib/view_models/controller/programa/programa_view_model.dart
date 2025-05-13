import 'package:get/get.dart';
import '../../../data/response/status.dart';
import '../../../models/home/programa_id_model.dart';
import '../../../repository/programa_repository/programa_repository.dart';

class ProgramaController extends GetxController {
  // Repositorios
  final _programa = ProgramaRepository();

  // Datos observables
  final programaId = ProgramaIdModel().obs;
  final error = ''.obs;

  final programaStatus = Status.LOADING.obs;

  void loadProgramas(String id) {
    programaStatus.value = Status.LOADING;
    _programa
        .programaIdApi(id)
        .then((res) {
          programaId.value = res;
          programaStatus.value = Status.COMPLETED;
        })
        .catchError((err) {
          error.value = err.toString();
          programaStatus.value = Status.ERROR;
        });
  }
}
