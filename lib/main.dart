import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'res/getx_loclization/languages.dart';
import 'res/routes/routes.dart';
import 'res/themes/app_theme.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      translations: Languages(),
      locale: const Locale('en' ,'US'),
      fallbackLocale: const Locale('en' ,'US'),
       theme: AppTheme.lightTheme,
      getPages: AppRoutes.appRoutes(),
    );
  }
}

