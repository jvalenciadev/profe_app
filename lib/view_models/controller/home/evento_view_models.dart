
import 'package:get/get.dart';
import 'package:programa_profe/models/home/evento_list_model.dart';
import '../../../data/response/status.dart';
import '../../../repository/evento_repository/evento_repository.dart';

class EventoController extends GetxController {

  final _evento = EventoRepository();


  final rxRequestStatus = Status.LOADING.obs;
  final eventoList =EventoListModel().obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value ;
  void setEventoList(EventoListModel _value) => eventoList.value = _value ;
  void setError(String _value) => error.value = _value ;


  void homeListApi(){
    setRxRequestStatus(Status.LOADING);
    _evento.eventoListApi().then((value){
       print("Eventos recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setEventoList(value);
    }).onError((error, stackTrace){
      print("Error al obtener eventos: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
   
  }

  void refreshApi(){
    setRxRequestStatus(Status.LOADING);
    _evento.eventoListApi().then((value){
      setRxRequestStatus(Status.COMPLETED);
      setEventoList(value);
    }).onError((error, stackTrace){
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}