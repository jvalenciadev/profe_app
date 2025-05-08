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
    // 1) Pasamos a LOADING
    inscripcionResponse.value = ApiResponse.loading();

    _evento.eventoInscripcionApi(data).then((personaModel) {
      // 2) Si todo OK, marcamos COMPLETED con los datos
      inscripcionResponse.value = ApiResponse.completed(personaModel);
      print("Inscripción exitosa: ${personaModel.respuesta?.persona?.nombre1}");
    }).catchError((err) {
      // 3) En error, guardamos el mensaje
      inscripcionResponse.value = ApiResponse.error(err.toString());
      print("Error en inscripción: $err");
    });
  }
}
