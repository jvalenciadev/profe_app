import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:programa_profe/res/colors/app_color.dart';
import 'package:programa_profe/res/routes/routes_name.dart';

import '../../res/fonts/app_fonts.dart'; // Para animaciones

class UpdateAppView extends StatelessWidget {
  const UpdateAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.whiteColor,
              Color(0xFFE3F2FD),
            ], // Suave degradado azul
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeIn(
          duration: const Duration(milliseconds: 900),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.system_update,
                size: 80,
                color: AppColor.primaryColor,
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Actualización requerida!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: AppFonts.Mina,
                  fontWeight: FontWeight.bold,
                  color: AppColor.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tu versión de la app está desactualizada. Por favor, actualiza para continuar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.Mina,
                  color: AppColor.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Aquí debes colocar la URL de tu app en la tienda
                  // launch('https://play.google.com/store/apps/details?id=com.miapp');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: AppColor.whiteColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.download, color: AppColor.whiteColor),
                label: const Text(
                  'Actualizar ahora',
                  style: TextStyle(fontSize: 16,
                  fontFamily: AppFonts.Mina,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Redirigir al HomeView
                  Get.toNamed(RouteName.homeView);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: AppColor.primaryColor,
                      width: 2,
                    ),
                  ),
                  foregroundColor: AppColor.primaryColor,
                  backgroundColor: AppColor.whiteColor,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.Mina,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
