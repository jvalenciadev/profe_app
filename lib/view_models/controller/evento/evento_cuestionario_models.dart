import 'package:get/get.dart';
import 'package:programa_profe/models/evento_cuestionario_model.dart';
import '../../../data/response/api_response.dart';
import '../../../data/response/status.dart';
import '../../../repository/evento_repository/evento_repository.dart';

class CuestionarioController extends GetxController {
  final _evento = EventoRepository();
   /// Observable que contendrá status, data y mensaje de error
  final cuestionarioResponse =
      ApiResponse<CuestionarioModel>(Status.IDLE, null, null).obs;
  /// POST: CUESTIONARIO
  void eventoCuestionarioPost(Map<String, dynamic> data) {
    // Cambiar estado a "cargando" mientras se realiza la petición
    cuestionarioResponse.value = ApiResponse.loading();

    // Llamar al método de inscripción que retorna un Future
    _evento
        .eventoCuestionarioApi(data)
        .then((cuestionarioModel) {
          cuestionarioResponse.value = ApiResponse.completed(cuestionarioModel);
          print("📦 Contenido completo: ${cuestionarioModel.toJson()}");
        })
        .catchError((err, stackTrace) {
          // Si ocurre un error, actualizar el estado a "error"
          cuestionarioResponse.value = ApiResponse.error(err.toString());

          // Mostrar el error básico
          print("❌ Error en inscripción: ${err.toString()}");

          // Mostrar el stack trace para mayor contexto (ayuda a depurar)
          print("📌 StackTrace:");
          print(stackTrace);

          // Si el error tiene más detalles, intenta mostrarlos
          if (err is Exception) {
            print("⚠️ Error tipo Exception: ${err.runtimeType}");
          } else {
            print("⚠️ Error desconocido: ${err}");
          }
        });
  }


}