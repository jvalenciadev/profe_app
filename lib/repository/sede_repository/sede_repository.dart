import '../../data/network/network_api_services.dart';
import '../../models/home/sede_id_model.dart';
import '../../models/home/sede_list_mode.dart';
import '../../res/app_url/app_url.dart';

class SedeRepository {

  final _apiService  = NetworkApiServices() ;

  Future<SedeListModel> sedeListApi() async{
    dynamic response = await _apiService.getApi(AppUrl.sedes);
    print("-------------------$response");
    return SedeListModel.fromJson(response) ;
  }
  Future<SedeIdModel> sedeIdApi(String id) async{
    dynamic response = await _apiService.getApi("${AppUrl.sedeId}/$id" );
    return SedeIdModel.fromJson(response) ;
  }
}