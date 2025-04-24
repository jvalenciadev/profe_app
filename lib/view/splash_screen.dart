import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Para animaciones
import 'package:programa_profe/res/colors/app_color.dart';
import '../../view_models/services/splash_services.dart';
import '../res/fonts/app_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices splashScreen = SplashServices();
  Map<String, String> appInfo = {
    "appName": "Cargando...",
    "appLogo": "",
    "appVersion": "",
  };

  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchAppInfo();
  }

  void _fetchAppInfo() {
    setState(() => hasError = false);
    splashScreen.isLogin(
      (data) {
        setState(() {
          appInfo = data;
        });
      },
      onError: () {
        setState(() => hasError = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.whiteColor,
              Color(0xFFE0E0E0),
            ], // Ligero degradado gris claro
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeIn(
            duration: const Duration(milliseconds: 900),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 80),
                _buildAppInfo(),
                const SizedBox(height: 20),
                hasError ? _buildRetryButton() : _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Suaviza los bordes
      child:
          appInfo['appLogo']!.isNotEmpty
              ? Image.network(
                appInfo['appLogo']!,
                width: 260,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: AppColor.greyColor,
                    ),
              )
              : const Icon(Icons.image, size: 80, color: AppColor.greyColor),
    );
  }

  Widget _buildAppInfo() {
    return Column(children: [_buildInfoRow("Versión:", appInfo['appVersion'])]);
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppFonts.Mina,
              fontWeight: FontWeight.w500,
              color: AppColor.primaryTextColor,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            value ?? "Cargando...",
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppFonts.Mina,
              color: AppColor.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: const [
        CircularProgressIndicator(color: AppColor.primaryColor),
        SizedBox(height: 10),
        Text(
          "Cargando...",
          style: TextStyle(color: AppColor.greyColor,fontFamily: AppFonts.Mina, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: AppColor.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: _fetchAppInfo,
      icon: const Icon(Icons.refresh),
      label: const Text("Reintentar",style: TextStyle(
        fontFamily: AppFonts.Mina,
      ),),
    );
  }
}
