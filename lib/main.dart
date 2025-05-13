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
import 'package:flutter_localizations/flutter_localizations.dart';

import 'view_models/controller/programa/programa_view_model.dart';
import 'view_models/controller/radio_controller.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase(); // Inicializa Firebase
  await LocalNotifications.initialize(); // Inicializa las notificaciones locales
  Get.put(AppInfoController());
  Get.put(ProgramaController());
  Get.put(RadioController(), permanent: true);
  runApp(const MyApp());
  // Esperar a que la UI esté montada
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FirebaseMessagingService.initializeFirebaseMessaging();
  });
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
      locale: const Locale('es', 'BO'),
      fallbackLocale: const Locale('es', 'BO'),
      theme: AppTheme.lightTheme,
      getPages: AppRoutes.appRoutes(),
      //  ↓↓↓ AGREGA ESTO ↓↓↓
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('es', 'BO'), // Español (Bolivia), si prefieres
        Locale('en', 'US'), // Inglés como fallback
      ],
    );
  }
}
