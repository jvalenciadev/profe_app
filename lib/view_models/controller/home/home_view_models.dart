
import 'package:get/get.dart';
import 'package:programa_profe/models/home/evento_list_model.dart';
import 'package:programa_profe/models/home/galeria_list_model.dart';
import 'package:programa_profe/models/home/profe_id_model.dart';
import 'package:programa_profe/models/home/programa_list_model.dart';
import 'package:programa_profe/models/home/video_list_model.dart';
import 'package:programa_profe/repository/evento_repository/evento_repository.dart';
import 'package:programa_profe/repository/programa_repository/programa_repository.dart';
import '../../../data/response/status.dart';
import '../../../repository/home_repository/hone_repository.dart';

class HomeController extends GetxController {

  final _home = HomeRepository();
  final _evento = EventoRepository();
  final _programa = ProgramaRepository();


  final rxRequestStatus = Status.LOADING.obs ;
  final eventoList =EventoListModel().obs ;
  final videoList =VideoListModel().obs ;
  final profeId =ProfeIdModel().obs ;
  final galeriaList =GaleriaListModel().obs ;
  final programaList =ProgramaListModel().obs ;
  RxString error = ''.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value ;
  void setEventoList(EventoListModel _value) => eventoList.value = _value ;
  void setVideoList(VideoListModel _value) => videoList.value = _value ;
  void setProfeId(ProfeIdModel _value) => profeId.value = _value ;
  void setGaleriaList(GaleriaListModel _value) => galeriaList.value = _value ;
  void setProgramaList(ProgramaListModel _value) => programaList.value = _value ;
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
    _programa.programaListApi().then((value){
       print("Programas recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setProgramaList(value);
    }).onError((error, stackTrace){
      print("Error al obtener eventos: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
    _home.profeIdApi().then((value){
       print("Profe recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setProfeId(value);
    }).onError((error, stackTrace){
      print("Error al obtener profe: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
    _home.galeriaListApi().then((value){
       print("Galerias recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setGaleriaList(value);
    }).onError((error, stackTrace){
      print("Error al obtener galerias: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
    _home.videoListApi().then((value){
      setRxRequestStatus(Status.COMPLETED);
      setVideoList(value);
    }).onError((error, stackTrace){
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