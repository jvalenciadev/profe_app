import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:programa_profe/models/app_model.dart';
import 'package:programa_profe/res/icons/icons.dart' show iconMap;
import 'package:url_launcher/url_launcher.dart';

import '../data/response/status.dart';
import '../res/colors/app_color.dart';
import '../res/fonts/app_fonts.dart';
import '../res/routes/routes_name.dart';
import '../utils/utilidad.dart';
import '../utils/utils.dart';
import '../view_models/controller/app_view_models.dart';

class PresentacionScreen extends StatefulWidget {
  PresentacionScreen({Key? key}) : super(key: key);

  @override
  _PresentacionScreenState createState() => _PresentacionScreenState();
}

class _PresentacionScreenState extends State<PresentacionScreen> {
  final _controller = Get.find<AppInfoController>();
  void _goHome() => Get.offAllNamed(RouteName.homeView);

  @override
  void initState() {
    super.initState();
    _controller.appInfoApi();
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      showCustomSnackbar(
        title: "Error",
        message: 'No se pudo abrir: \$url',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (_controller.rxRequestStatus.value) {
          case Status.LOADING:
            return loading();
          case Status.ERROR:
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.exclamationTriangle,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '¡Vaya! Algo salió mal.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.mina,
                        fontSize: 18,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _controller.error.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.mina,
                        fontSize: 14,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _controller.appInfoApi(),
                      icon: const FaIcon(
                        FontAwesomeIcons.undo,
                        size: 16,
                        color: AppColor.whiteColor,
                      ),
                      label: const Text(
                        'Reintentar',
                        style: TextStyle(
                          fontFamily: AppFonts.mina,
                          color: AppColor.whiteColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          case Status.COMPLETED:
          final data = _controller.appInfo.value.respuesta!;
            return Stack(
              children: [
                // Fondo degradado
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.primaryColor, AppColor.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ZoomIn(
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor.withOpacity(0.3),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // opcional: redondea esquinas
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 8),
                          ],
                        ),
                        child: Image.asset(
                          'assets/logos/logoprofe.png',
                          width: 200,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                // IntroductionScreen
                Padding(
                  padding: const EdgeInsets.only(top: 180),
                  child: IntroductionScreen(
                    pages: data.pages?.map((p) => _buildPage(p)).toList(),
                    globalBackgroundColor: Colors.transparent,
                    showSkipButton: true,
                    skip: FadeInLeft(
                      child: Text(
                        'Saltar',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontFamily: AppFonts.montserrat,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    next: BounceInRight(
                      child: CircleAvatar(
                        backgroundColor: AppColor.whiteColor.withOpacity(0.8),
                        radius: 24,
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                    done: BounceInUp(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(color: Colors.black38, blurRadius: 12),
                          ],
                        ),
                        child: Text(
                          'Comenzar',
                          style: TextStyle(
                            fontFamily: AppFonts.mina,
                            fontSize: 16,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onDone: _goHome,
                    onSkip: _goHome,
                    dotsDecorator: DotsDecorator(
                      size: const Size(12, 12),
                      activeSize: const Size(24, 12),
                      activeColor: AppColor.whiteColor,
                      color: AppColor.whiteColor.withOpacity(0.5),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    animationDuration: 600,
                    curve: Curves.easeInOutQuad,
                  ),
                ),
              ],
            );
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }

  PageViewModel _buildPage(PageData p) {
    return PageViewModel(
      decoration: const PageDecoration(
        pageColor: Colors.transparent,
        imagePadding: EdgeInsets.zero,
        contentMargin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      titleWidget: FadeInDown(
        child: Text(
          p.title!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.mina,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
      ),
      bodyWidget: FadeIn(
        delay: const Duration(milliseconds: 300),
        child: Text(
          p.body!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.montserrat,
            fontSize: 18,
            color: AppColor.whiteColor.withOpacity(0.9),
          ),
        ),
      ),
      image: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de fondo animado
          Pulse(
            duration: const Duration(seconds: 2),
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: AppColor.whiteColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Imagen principal
          ZoomIn(
            delay: const Duration(milliseconds: 500),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: p.imageUrl!,
                width: 350,
                height: 200,
                fit: BoxFit.fill,
                placeholder:
                    (c, u) => Container(
                      height: 270,
                      color: const Color.fromARGB(12, 245, 245, 245),
                      child: const Center(child: CircularProgressIndicator(color: AppColor.primaryColor,)),
                    ),
                errorWidget:
                    (c, u, e) => Container(
                      height: 270,
                      color: const Color.fromARGB(12, 245, 245, 245),
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              p.socials!
                  .map(
                    (s) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () => _launchURL(s.url!),
                        child: Pulse(
                          infinite: true,
                          child: FaIcon(
                            iconMap[s.icon] ?? FontAwesomeIcons.circleQuestion,
                            size: 28,
                            color: (colorMap[s.color] ?? Colors.grey).withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
