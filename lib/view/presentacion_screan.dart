import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/response/status.dart';
import '../res/colors/app_color.dart';
import '../res/fonts/app_fonts.dart';
import '../res/routes/routes_name.dart';
import '../utils/utilidad.dart';
import '../view_models/controller/app_view_models.dart';

class PresentacionScreen extends StatefulWidget {
  const PresentacionScreen({super.key});

  @override
  State<PresentacionScreen> createState() => _PresentacionScreenState();
}

class _PresentacionScreenState extends State<PresentacionScreen> {
  final AppInfoController appInfoController = Get.find<AppInfoController>();

  @override
  void initState() {
    super.initState();
    appInfoController.appInfoApi();
  }

  void goToHome() => Get.offAllNamed(RouteName.homeView);

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Degradado de fondo general
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEEF5FF), Color(0xFFDCEAFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            switch (appInfoController.rxRequestStatus.value) {
              case Status.LOADING:
                return loading();

              case Status.ERROR:
                return buildErrorWidget(appInfoController.refreshApi);

              case Status.COMPLETED:
                final data = appInfoController.appInfo.value.respuesta!;

                return IntroductionScreen(
                  globalBackgroundColor: Colors.transparent,
                  pages: [
                    // 👉 Página 1: Bienvenida + Logo
                    PageViewModel(
                      titleWidget: Text(
                        data.nombre ?? 'Bienvenido',
                        style: TextStyle(
                          fontFamily: AppFonts.mina,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      image: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: data.logo!,
                          width: 240,
                          placeholder: (_,__) => const CircularProgressIndicator(color: AppColor.primaryColor),
                          errorWidget: (_,__,___) => const Icon(Icons.error, color: AppColor.primaryColor),
                        ),
                      ),
                      bodyWidget: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,4))],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text("Versión actual: ${data.versionActual}", style: TextStyle(fontFamily: AppFonts.mina)),
                              // Text("🛠 Mínima: ${data.versionMinima}", style: TextStyle(fontFamily: AppFonts.mina)),
                              if (data.ultimaActualizacion != null)
                                Text("🕒 Actualizado: ${formatFechaLarga(data.ultimaActualizacion!.toString())}", style: TextStyle(fontFamily: AppFonts.mina)),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => _launchURL(data.playstoreUrl!),
                                icon: const Icon(Icons.shop_2, color: Colors.white),
                                label: const Text('Play Store', style: TextStyle(fontFamily: AppFonts.mina, color: AppColor.whiteColor)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      decoration: _pageDecor(),
                    ),

                    // 👉 Página 2: Novedades
                    if ((data.novedades ?? []).isNotEmpty)
                      PageViewModel(
                        title: 'Novedades',
                        image: const Icon(Icons.new_releases, size: 120, color: AppColor.secondaryColor),
                        bodyWidget: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,4))],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.novedades!
                                  .map((n) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: Row(
                                          children: [
                                            Icon(Icons.fiber_manual_record, size: 12, color: AppColor.secondaryColor),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(n, style: TextStyle(fontFamily: AppFonts.mina))),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        decoration: _pageDecor(),
                      ),

                    // 👉 Página 3: Enlaces y soporte
                    PageViewModel(
                      title: 'Soporte y Enlaces',
                      image: const Icon(Icons.support_agent, size: 120, color: Colors.green),
                      bodyWidget: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,4))],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (data.contactoSoporte != null)
                                Row(
                                  children: [
                                    const Icon(Icons.email, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(data.contactoSoporte!, style: TextStyle(fontFamily: AppFonts.mina)),
                                  ],
                                ),
                              const SizedBox(height: 12),
                              if (data.sitioWeb != null)
                                _linkButton(Icons.public, 'Sitio web', data.sitioWeb!),
                              if (data.terminosUrl != null)
                                _linkButton(Icons.description, 'Términos y condiciones', data.terminosUrl!),
                              if (data.privacidadUrl != null)
                                _linkButton(Icons.privacy_tip, 'Política de privacidad', data.privacidadUrl!),
                            ],
                          ),
                        ),
                      ),
                      decoration: _pageDecor(),
                    ),
                  ],
                  onDone: goToHome,
                  onSkip: goToHome,
                  showSkipButton: true,
                  skip: Text('Saltar', style: TextStyle(fontFamily: AppFonts.mina, color: AppColor.primaryColor)),
                  next: Icon(Icons.arrow_forward, color: AppColor.primaryColor),
                  done: Text('Empezar',
                      style: TextStyle(fontFamily: AppFonts.mina, color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                  dotsDecorator: DotsDecorator(
                    activeColor: AppColor.primaryColor,
                    size: const Size(8, 8),
                    activeSize: const Size(20, 8),
                    activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    color: Colors.grey.shade300,
                  ),
                );

              case Status.IDLE:
                return const Center(child: Text('Esperando...'));
            }
          }),
        ),
      ),
    );
  }

  PageDecoration _pageDecor() => PageDecoration(
        pageColor: Colors.transparent,
        titlePadding: const EdgeInsets.symmetric(vertical: 12),
        imagePadding: EdgeInsets.zero,
        contentMargin: const EdgeInsets.symmetric(horizontal: 24),
      );

  Widget _linkButton(IconData ic, String label, String url) {
    return TextButton.icon(
      onPressed: () => _launchURL(url),
      icon: Icon(ic, color: AppColor.primaryColor),
      label: Text(label, style: TextStyle(fontFamily: AppFonts.mina,color: AppColor.primaryColor)),
    );
  }
}
