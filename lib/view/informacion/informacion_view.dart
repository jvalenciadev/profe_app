import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/response/status.dart';
import '../../res/app_url/app_url.dart';
import '../../res/assets/image_assets.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/home/home_view_models.dart';
import '../../models/video_model.dart';

class InformationScreen extends StatelessWidget {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.primaryColor, AppColor.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo o icono al lado del título
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const FaIcon(
                  FontAwesomeIcons.graduationCap,
                  size: 20,
                  color: AppColor.whiteColor,
                ),
              ),

              const Text(
                'Programa PROFE',
                style: TextStyle(
                  fontFamily: AppFonts.mina,
                  color: AppColor.whiteColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 15),
              Image.asset(
                ImageAssets.logoProfe,
                width: 120,
                fit: BoxFit.contain,
              ),
            ],
          ),
          centerTitle: false,
          elevation: 0,
          toolbarHeight: 80,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final pStatus = homeController.profeStatus.value;
          final vStatus = homeController.videosStatus.value;

          if (pStatus == Status.LOADING || vStatus == Status.LOADING) {
            return loading();
          }

          if (pStatus == Status.ERROR || vStatus == Status.ERROR) {
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
                      homeController.error.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.mina,
                        fontSize: 14,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => homeController.refreshAll(),
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
          }

          final profe = homeController.profeId.value.respuesta!;
          final videos = homeController.videoList.value.respuesta ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Banner
                if (profe.profeBanner != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Opcional: bordes redondeados
                    child: CachedNetworkImage(
                      imageUrl:
                          '${AppUrl.baseImage}/storage/profe/${profe.profeAfiche}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Center(
                            child:
                                CircularProgressIndicator(), // Placeholder mientras carga
                          ),
                      errorWidget:
                          (context, url, error) =>
                              Icon(Icons.error), // Si falla la carga
                    ),
                  ),

                /// Título
                Text(
                  profe.profeNombre ?? '',
                  style: const TextStyle(
                    fontFamily: AppFonts.mina,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),

                /// Botones de contacto (mejor diseño)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Pulse(
                              from: 1,
                              to: 1.05,
                              infinite: true,
                              child: TextButton.icon(
                                onPressed:
                                    () => _launchUrl(
                                      'mailto:${profe.profeCorreo}',
                                    ),
                                icon: const FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: AppColor.primaryColor,
                                  size: 24,
                                ),
                                label: const Text(
                                  'Correo',
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColor.secondaryColor,
                                ),
                              ),
                            ),
                            Pulse(
                              from: 1,
                              to: 1.05,
                              infinite: true,
                              child: TextButton.icon(
                                onPressed: () {
                                  _launchUrl(
                                    '${AppUrl.baseImage}/storage/profe/${profe.profeConvocatoria}',
                                  );
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.solidFilePdf,
                                  color: AppColor.redColor,
                                  size: 24,
                                ),
                                label: const Text(
                                  'Convocatoria',
                                  style: TextStyle(
                                    color: AppColor.redColor,
                                    fontSize: 16,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColor.redColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Descripción
                if (profe.profeDescripcion != null) ...[
                  mostrarHtml(profe.profeDescripcion!),
                  const SizedBox(height: 20),
                ],

                /// Secciones informativas
                _sectionCard('Sobre Nosotros', profe.profeSobreNosotros),
                _sectionCard('Misión', profe.profeMision),
                _sectionCard('Visión', profe.profeVision),
                _sectionCard('Actividad', profe.profeActividad),

                const SizedBox(height: 16),

                /// Redes sociales
                if (_hasAnySocial(profe))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Redes Sociales'),
                      Center(
                        child: Wrap(
                          spacing: 25,
                          runSpacing: 12,
                          children: [
                            if (profe.profeFacebook != null)
                              _socialIcon(
                                FontAwesomeIcons.facebook,
                                profe.profeFacebook!,
                              ),
                            if (profe.profeYoutube != null)
                              _socialIcon(
                                FontAwesomeIcons.youtube,
                                profe.profeYoutube!,
                              ),
                            if (profe.profeTiktok != null)
                              _socialIcon(
                                FontAwesomeIcons.tiktok,
                                profe.profeTiktok!,
                              ),
                            if (profe.profePagina != null)
                              _socialIcon(
                                FontAwesomeIcons.globe,
                                profe.profePagina!,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 30),

                /// VIDEOS
                if (videos.isNotEmpty) ...[
                  if (videos.any((v) => v.videoTipo == 'TIKTOK')) ...[
                    _buildSectionHeader('Videos TikTok'),
                    Wrap(
                      spacing: 5,
                      runSpacing: 2,
                      children:
                          videos
                              .where((v) => v.videoTipo == 'TIKTOK')
                              .map(_buildTikTokButton)
                              .toList(),
                    ),
                  ],
                  if (videos.any((v) => v.videoTipo != 'TIKTOK')) ...[
                    _buildSectionHeader('Multimedia'),
                    Column(
                      children:
                          videos
                              .where((v) => v.videoTipo != 'TIKTOK')
                              .map(_buildEmbeddedVideoCard)
                              .toList(),
                    ),
                  ],
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  bool _hasAnySocial(profe) {
    return profe.profeFacebook != null ||
        profe.profeYoutube != null ||
        profe.profeTiktok != null ||
        profe.profePagina != null;
  }

  Widget _sectionCard(String title, String? html) {
    if (html == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.mina,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          mostrarHtml(html),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return Pulse(
      from: 1,
      to: 1.1,
      duration: const Duration(seconds: 1),
      infinite: true,
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: AppColor.primaryColor.withOpacity(0.1),
          child: FaIcon(icon, size: 22, color: AppColor.primaryColor),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: AppFonts.mina,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.primaryColor,
        ),
      ),
    );
  }

  Widget _buildTikTokButton(VideoModel video) {
    final match = RegExp(r'cite="([^"]+)"').firstMatch(video.videoIframe ?? '');
    final url = match?.group(1) ?? '';

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColor.tiktokColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
      onPressed:
          url.isEmpty
              ? null
              : () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
      icon: const FaIcon(FontAwesomeIcons.tiktok, color: AppColor.tiktokColor),
      label: const Text(
        'Ver TikTok',
        style: TextStyle(
          fontFamily: AppFonts.mina,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColor.tiktokColor,
        ),
      ),
    );
  }

  Widget _buildEmbeddedVideoCard(VideoModel video) {
    final match = RegExp(r'src="([^"]+)"').firstMatch(video.videoIframe ?? '');
    final url = match?.group(1) ?? '';
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header tipo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              video.videoTipo ?? '',
              style: const TextStyle(
                fontFamily: AppFonts.mina,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColor.primaryColor,
              ),
            ),
          ),

          /// WebView
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: WebViewWidget(controller: controller),
            ),
          ),
        ],
      ),
    );
  }
}
