import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view_models/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  Map<String, String> appInfo = {
    "appName": "Cargando...",
    "packageName": "",
    "appVersion": "",
    "buildNumber": "",
    "apiVersion": "",
    "lastUpdate": "",
  };

  @override
  void initState() {
    super.initState();
    splashScreen.isLogin((data) {
      setState(() {
        appInfo = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "welcome_back".tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text("📱 ${appInfo['appName']}", style: TextStyle(fontSize: 16, color: Colors.white)),
            Text("🆔 ${appInfo['packageName']}", style: TextStyle(fontSize: 14, color: Colors.white)),
            Text("🔢 Versión App: ${appInfo['appVersion']} (${appInfo['buildNumber']})", style: TextStyle(fontSize: 14, color: Colors.white)),
            Text("🌐 API Versión: ${appInfo['apiVersion']}", style: TextStyle(fontSize: 14, color: Colors.white)),
            Text("📅 Última actualización: ${appInfo['lastUpdate']}", style: TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
