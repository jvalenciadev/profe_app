

import 'package:programa_profe/models/home/novedad_id_model.dart';
import 'package:programa_profe/models/home/novedad_list_model.dart';

import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class NovedadRepository {

  final _apiService  = NetworkApiServices() ;

  Future<NovedadListModel> novedadListApi() async{
    dynamic response = await _apiService.getApi(AppUrl.novedades);
    return NovedadListModel.fromJson(response) ;
  }
  Future<NovedadIdModel> novedadIdApi(String id) async{
    dynamic response = await _apiService.getApi("${AppUrl.novedadId}/$id" );
    return NovedadIdModel.fromJson(response) ;
  }
}