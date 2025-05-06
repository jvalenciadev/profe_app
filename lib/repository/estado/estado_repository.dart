

import '../../data/network/network_api_services.dart';
import '../../models/estado_model.dart';
import '../../res/app_url/app_url.dart';

class EstadoRepository {

  final _apiService  = NetworkApiServices() ;

  Future<EstadoModel> enviarTokenApi(String token) async{
    final data = {
      'token': token,
    };
    dynamic response = await _apiService.postApi(data,AppUrl.agregarToken);
    return EstadoModel.fromJson(response);
  }
}