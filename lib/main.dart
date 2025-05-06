import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'res/getx_loclization/languages.dart';
import 'res/routes/routes.dart';
import 'res/themes/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'view_models/controller/app_view_models.dart';
import 'firebase/firebase_config.dart';
import 'firebase/firebase_messaging_service.dart';
import 'notifications/local_notifications.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase(); // Inicializa Firebase
  await LocalNotifications.initialize(); // Inicializa las notificaciones locales
  await FirebaseMessagingService.initializeFirebaseMessaging(); // Inicializa Firebase Messaging
  Get.put(AppInfoController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App PROFE',
      translations: Languages(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.lightTheme,
      getPages: AppRoutes.appRoutes(),
    );
  }
}
