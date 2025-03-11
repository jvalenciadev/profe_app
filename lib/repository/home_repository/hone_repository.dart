

import 'package:programa_profe/models/home/galeria_list_model.dart';
import 'package:programa_profe/models/home/profe_id_model.dart';

import '../../data/network/network_api_services.dart';
import '../../models/home/video_list_model.dart';
import '../../res/app_url/app_url.dart';

class HomeRepository {

  final _apiService  = NetworkApiServices() ;

  Future<VideoListModel> videoListApi() async{
    dynamic response = await _apiService.getApi(AppUrl.videos);
    return VideoListModel.fromJson(response) ;
  }
  Future<ProfeIdModel> profeIdApi() async{
    dynamic response = await _apiService.getApi(AppUrl.profe);
    return ProfeIdModel.fromJson(response) ;
  }
  Future<GaleriaListModel> galeriaListApi() async{
    dynamic response = await _apiService.getApi(AppUrl.galerias);
    return GaleriaListModel.fromJson(response) ;
  }

}