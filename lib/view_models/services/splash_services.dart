import 'dart:async';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../controller/app_view_models.dart';
import '../../res/routes/routes_name.dart';

class SplashServices {
  final AppInfoController appInfoController = Get.find<AppInfoController>();

  void isLogin(
    Function(Map<String, String>) onDataReceived, {
    required VoidCallback onError,
  }) async {
    try {
      // Obtención de la información de la app
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String packageName = packageInfo.packageName;
      String appVersion = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      // Llamamos a la API de appInfo y esperamos a que termine
      await appInfoController.appInfoApi(); // Esperamos a que la API termine
      //throw Exception("Forzando error para prueba"); // ← Fuerza el error aquí

      // Ahora obtenemos los datos de appInfo después de que la API haya respondido
      final appInfo = appInfoController.appInfo.value;
      // Validamos si la respuesta es válida
      if (appInfo.respuesta == null || appInfo.respuesta?.nombre == null) {
        onError(); // Si no hay datos válidos, salimos por error
        return;
      }

      Map<String, String> data = {
        "appLogo": appInfo.respuesta?.logo ?? "Desconocido",
        "appName": appInfo.respuesta?.nombre ?? "Desconocido",
        "packageName": packageName,
        "appVersion": appInfo.respuesta?.versionActual ?? "Desconocido",
        "buildNumber": buildNumber,
        "apiVersion": appInfo.respuesta?.versionActual ?? "Desconocida",
      };

      onDataReceived(data); // Pasamos la info al SplashScreen

      // Esperamos 3 segundos antes de comprobar la versión
      Timer(const Duration(seconds: 3), () {
        _checkAppVersion(appVersion);
      });
    } catch (e) {
      print("Error al obtener appInfo: $e");
      onError(); // Si hay una excepción, llamamos a onError
    }
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
