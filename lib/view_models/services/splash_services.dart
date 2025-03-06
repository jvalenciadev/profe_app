import 'dart:async';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controller/app_view_models.dart';
import '../../res/routes/routes_name.dart';

class SplashServices {
  final AppInfoController appInfoController = Get.find<AppInfoController>();

  void isLogin(Function(Map<String, String>) onDataReceived) async {
    // Obtención de la información de la app
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String appVersion = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    // Llamamos a la API de appInfo y esperamos a que termine
    await appInfoController.appInfoApi();  // Esperamos a que la API termine

    // Ahora obtenemos los datos de appInfo después de que la API haya respondido
    final appInfo = appInfoController.appInfo.value;

    print("------------------------------- ${appInfo.respuesta?.nombre}");

    Map<String, String> data = {
      "appName": appName,
      "packageName": packageName,
      "appVersion": appVersion,
      "buildNumber": buildNumber,
      "apiVersion": appInfo.respuesta?.sitioWeb ?? "Desconocida",
    };

    onDataReceived(data); // Pasamos la info al SplashScreen

    // Esperamos 3 segundos antes de comprobar la versión
    Timer(const Duration(seconds: 3), () {
      _checkAppVersion(appVersion);
    });
  }

  void _checkAppVersion(String appVersion) {
    final appInfo = appInfoController.appInfo.value;
    print("------------------------------- ${appInfo.respuesta?.nombre}");

    String versionActual = appInfo.respuesta?.versionActual ?? '';

    if (appVersion != versionActual) {
      Get.toNamed(RouteName.updateAppView);
    } else {
      Get.toNamed(RouteName.homeView);
    }
  }
}
