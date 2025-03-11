// lib/themes/app_theme.dart
import 'package:flutter/material.dart';
import '../colors/app_color.dart';
import 'text_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColor.primaryColor,
      hintColor: AppColor.accentColor,
      textTheme: AppTextTheme.lightTextTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: AppColor.whiteColor,
      appBarTheme: AppBarTheme(
        color: AppColor.primaryColor,
      ),
    );
  }
}
