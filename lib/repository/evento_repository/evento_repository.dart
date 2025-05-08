

import 'package:programa_profe/models/home/evento_list_model.dart';
import '../../data/network/network_api_services.dart';
import '../../models/home/evento_id_model.dart';
import '../../models/persona_model.dart';
import '../../res/app_url/app_url.dart';

class EventoRepository {

  final _apiService  = NetworkApiServices() ;

  Future<EventoListModel> eventoListApi() async{
    dynamic response = await _apiService.getApi(AppUrl.eventos);
    return EventoListModel.fromJson(response) ;
  }
  Future<EventoIdModel> eventoIdApi(String id) async{
    dynamic response = await _apiService.getApi("${AppUrl.eventosId}/$id" );
    return EventoIdModel.fromJson(response) ;
  }
  Future<PersonaEstadoModel> eventoInscripcionApi(Map<String, dynamic> data) async {
    final response = await _apiService.postApi(data, AppUrl.eventoInscripcion);
    return PersonaEstadoModel.fromJson(response);
  }
}