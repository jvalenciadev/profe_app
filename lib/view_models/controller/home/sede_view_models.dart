
import 'package:get/get.dart';
import '../../../data/response/status.dart';
import '../../../models/home/sede_list_mode.dart';
import '../../../repository/sede_repository/sede_repository.dart';

class SedeController extends GetxController {

  final _sede = SedeRepository();


  final rxRequestStatus = Status.LOADING.obs;
  final sedeList = SedeListModel().obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value ;
  void setSedeList(SedeListModel _value) => sedeList.value = _value ;
  void setError(String _value) => error.value = _value ;


  void homeListApi(){
    setRxRequestStatus(Status.LOADING);

   
    _sede.sedeListApi().then((value){
      print("Sedes recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setSedeList(value);
    }).onError((error, stackTrace){
      print("Error al obtener sedes: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi(){

    setRxRequestStatus(Status.LOADING);

    _sede.sedeListApi().then((value){
      print("Sedes recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setSedeList(value);
    }).onError((error, stackTrace){
      print("Error al obtener sedes: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}