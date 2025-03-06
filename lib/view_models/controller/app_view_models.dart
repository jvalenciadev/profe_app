import 'package:get/get.dart';
import '../../../data/response/status.dart';
import '../../models/app_model.dart';
import '../../repository/app_repository.dart';

class AppInfoController extends GetxController {
  final _api = AppInfoRepository();

  final rxRequestStatus = Status.LOADING.obs;
  final appInfo = AppInfoModel().obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  void setAppInfo(AppInfoModel value) => appInfo.value = value;
  void setError(String value) => error.value = value;

  Future<void> appInfoApi() async {
    try {
      setRxRequestStatus(Status.LOADING);

      // Await the API response
      AppInfoModel value = await _api.appInfoApi();

      // Once the API call is successful, set the data
      setRxRequestStatus(Status.COMPLETED);
      setAppInfo(value);
    } catch (error) {
      // Handle error
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    }
  }

  Future<void> refreshApi() async {
    try {
      setRxRequestStatus(Status.LOADING);

      // Await the API response
      AppInfoModel value = await _api.appInfoApi();

      // Once the API call is successful, set the data
      setRxRequestStatus(Status.COMPLETED);
      setAppInfo(value);
    } catch (error) {
      // Handle error
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    }
  }
}
