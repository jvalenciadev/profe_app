

import 'package:programa_profe/models/app_model.dart';

import '../../data/network/network_api_services.dart';
import '../../res/app_url/app_url.dart';

class AppInfoRepository {

  final _apiService  = NetworkApiServices() ;

  Future<AppInfoModel> appInfoApi() async{
    dynamic response = await _apiService.getApi(AppUrl.appInfo);
    return AppInfoModel.fromJson(response) ;
  }
  // Future<UserListModel> userListApi() async{
  //   dynamic response = await _apiService.getApi(AppUrl.userListApi);
  //   return UserListModel.fromJson(response) ;
  // }

}