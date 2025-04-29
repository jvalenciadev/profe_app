
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

  final _home = HomeRepository();
  final _evento = EventoRepository();
  final _sede = SedeRepository();
  final _novedad = NovedadRepository();
  final _programa = ProgramaRepository();


  final rxRequestStatus = Status.LOADING.obs;
  final eventoList =EventoListModel().obs;
  final sedeList = SedeListModel().obs;
  final novedadList =NovedadListModel().obs;
  final videoList =VideoListModel().obs;
  final profeId =ProfeIdModel().obs;
  final programaList =ProgramaListModel().obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status _value) => rxRequestStatus.value = _value ;
  void setEventoList(EventoListModel _value) => eventoList.value = _value ;
  void setSedeList(SedeListModel _value) => sedeList.value = _value ;
  void setNovedadList(NovedadListModel _value) => novedadList.value = _value ;
  void setVideoList(VideoListModel _value) => videoList.value = _value ;
  void setProfeId(ProfeIdModel _value) => profeId.value = _value ;
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
    _sede.sedeListApi().then((value){
      print("Sedes recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setSedeList(value);
    }).onError((error, stackTrace){
      print("Error al obtener sedes: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
    _novedad.novedadListApi().then((value){
       print("Novedad recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setNovedadList(value);
    }).onError((error, stackTrace){
      print("Error al obtener Novedades: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
    _programa.programaListApi().then((value){
       print("Novedad recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setProgramaList(value);
    }).onError((error, stackTrace){
      print("Error al obtener Novedades: $error");
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
    _sede.sedeListApi().then((value){
      print("Sedes recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setSedeList(value);
    }).onError((error, stackTrace){
      print("Error al obtener sedes: $error");
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
    _novedad.novedadListApi().then((value){
       print("Novedad recibidos: ${value.respuesta}");
      setRxRequestStatus(Status.COMPLETED);
      setNovedadList(value);
    }).onError((error, stackTrace){
      print("Error al obtener Novedades: $error");
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
    _home.videoListApi().then((value){
      setRxRequestStatus(Status.COMPLETED);
      setVideoList(value);
    }).onError((error, stackTrace){
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}