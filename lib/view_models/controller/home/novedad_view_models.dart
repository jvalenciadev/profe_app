
import 'package:get/get.dart';
import 'package:programa_profe/models/home/novedad_list_model.dart';
import 'package:programa_profe/repository/novedad_repository/novedad_repository.dart';
import '../../../data/response/status.dart';

class NovedadController extends GetxController {


  final _novedad = NovedadRepository();


  final rxRequestStatus = Status.LOADING.obs;
  final novedadList =NovedadListModel().obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value ;
  void setNovedadList(NovedadListModel _value) => novedadList.value = _value ;
  void setError(String _value) => error.value = _value ;


  void homeListApi(){
    setRxRequestStatus(Status.LOADING);

    _novedad.novedadListApi().then((value){
       print("Novedad recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setNovedadList(value);
    }).onError((error, stackTrace){
      print("Error al obtener Novedades: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi(){

    setRxRequestStatus(Status.LOADING);

    _novedad.novedadListApi().then((value){
       print("Novedad recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setNovedadList(value);
    }).onError((error, stackTrace){
      print("Error al obtener Novedades: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}