import 'package:get/get.dart';
import '../../../data/response/api_response.dart';
import '../../../data/response/status.dart';
import '../../../models/persona_model.dart';
import '../../../repository/evento_repository/evento_repository.dart';

class EventoController extends GetxController {
  final _evento = EventoRepository();

  /// Observable que contendrá status, data y mensaje de error
  final inscripcionResponse =
      ApiResponse<PersonaEstadoModel>(Status.IDLE, null, null).obs;

  /// POST: inscribir participante
  void eventoInscripcionPost(Map<String, dynamic> data) {
    // Cambiar estado a "cargando" mientras se realiza la petición
    inscripcionResponse.value = ApiResponse.loading();

    // Llamar al método de inscripción que retorna un Future
    _evento
        .eventoInscripcionApi(data)
        .then((personaModel) {
          inscripcionResponse.value = ApiResponse.completed(personaModel);
          print("📦 Contenido completo: ${personaModel.toJson()}");

        })
        .catchError((err, stackTrace) {
          // Si ocurre un error, actualizar el estado a "error"
          inscripcionResponse.value = ApiResponse.error(err.toString());

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
