import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor {

  static const Color blackColor = Color(0xff000000) ;
  static const Color whiteColor = Color(0xffffffff) ;
  static const Color transparentColor = Colors.transparent;

  static const Color primaryColor =  Color.fromRGBO(35, 68, 113, 1);
  static const Color secondaryColor =  Color.fromRGBO(20, 116, 166, 1);
  static const Color backgroundColor =  Color(0xff01B1C9);
  static const Color accentColor =  Color(0xff01B1C9);
  static const Color greyColor =  Color.fromARGB(255, 95, 95, 95);
  static const Color grey2Color =  Color.fromARGB(255, 219, 219, 219);
  static const Color grey3Color =  Color.fromARGB(255, 242, 247, 248);
  static const Color grey4Color =  Color.fromARGB(255, 238, 246, 248);

  static const Color primaryButtonColor =  Color.fromARGB(255, 1, 177, 201);
  static const Color secondaryButtonColor =  Color(0xffFC3F5B);

  static const Color redColor =  Color.fromARGB(255, 218, 6, 38);

  static const Color primaryTextColor =  Color(0xff000000);
  static const Color secondaryTextColor =  Color(0xff444648);
  static const Color facebookColor = Color(0xFF4267B2);  // Azul de Facebook
  static const Color tiktokColor = Color.fromARGB(255, 0, 0, 0);   // Verde de TikTok
  static const Color whatsappColor = Color(0xFF25D366);  // Verde de WhatsApp
  static const Color youtubeColor = Color(0xFFFF0000); 

  static const Color radioStream = Color.fromARGB(255, 41, 35, 92); 
}

final Map<String, Color> colorMap = {
  'blackColor': AppColor.blackColor,
  'whiteColor': AppColor.whiteColor,
  'transparentColor': AppColor.transparentColor,
  'primaryColor': AppColor.primaryColor,
  'secondaryColor': AppColor.secondaryColor,
  'backgroundColor': AppColor.backgroundColor,
  'accentColor': AppColor.accentColor,
  'greyColor': AppColor.greyColor,
  'grey2Color': AppColor.grey2Color,
  'grey3Color': AppColor.grey3Color,
  'grey4Color': AppColor.grey4Color,
  'primaryButtonColor': AppColor.primaryButtonColor,
  'secondaryButtonColor': AppColor.secondaryButtonColor,
  'redColor': AppColor.redColor,
  'primaryTextColor': AppColor.primaryTextColor,
  'secondaryTextColor': AppColor.secondaryTextColor,
  'facebookColor': AppColor.facebookColor,
  'tiktokColor': AppColor.tiktokColor,
  'whatsappColor': AppColor.whatsappColor,
  'youtubeColor': AppColor.youtubeColor,
  'radioStream': AppColor.radioStream,
};