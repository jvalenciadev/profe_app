

import 'package:programa_profe/models/home/programa_id_model.dart';
import 'package:programa_profe/models/home/programa_list_model.dart';

import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class ProgramaRepository {

  final _apiService  = NetworkApiServices() ;

  Future<ProgramaListModel> programaListApi() async{
    dynamic response = await _apiService.getApi(AppUrl.programas);
    return ProgramaListModel.fromJson(response) ;
  }
  Future<ProgramaIdModel> programaIdApi(String id) async{
    dynamic response = await _apiService.getApi("${AppUrl.programaId}/$id" );
    return ProgramaIdModel.fromJson(response) ;
  }
}