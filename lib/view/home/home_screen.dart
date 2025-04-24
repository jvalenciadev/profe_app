import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';

import '../../data/response/status.dart';
import '../../res/app_url/app_url.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/general_exception.dart';
import '../../res/components/internet_exceptions_widget.dart';
import '../../view_models/controller/home/home_view_models.dart';
import '../widgets/home_widgets.dart';
import '../widgets/novedades_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.find<HomeController>();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Obx(() {
          switch (homeController.rxRequestStatus.value) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator());
            case Status.ERROR:
              return _buildErrorWidget();
            case Status.COMPLETED:
              return _buildCompletedState();
          }
        }),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (homeController.error.value == 'No internet') {
      return InterNetExceptionWidget(onPress: homeController.refreshApi);
    } else {
      return GeneralExceptionWidget(onPress: homeController.refreshApi);
    }
  }

  Widget _buildCompletedState() {
    if (homeController.eventoList.value.respuesta == null ||
        homeController.eventoList.value.respuesta!.isEmpty) {
      return Center(
        child: Text(
          "No hay eventos disponibles",
          style: TextStyle(fontFamily: AppFonts.Mina),
        ),
      );
    }
    if (homeController.novedadList.value.respuesta == null ||
        homeController.novedadList.value.respuesta!.isEmpty) {
      return Center(
        child: Text(
          "No hay novedades disponibles",
          style: TextStyle(fontFamily: AppFonts.Mina),
        ),
      );
    }
    

    List eventos = homeController.eventoList.value.respuesta!.take(10).toList();
    List novedades = homeController.novedadList.value.respuesta!.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //_buildProfileHeader(),
        buildEventSection(
          "Eventos",
          "Únete a nuestros eventos y mejora tu enseñanza. ¡Inscríbete ahora!",
          FontAwesomeIcons.calendarDays,
        ),
        _buildEventCarousel(eventos),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //   decoration: BoxDecoration(
        //   color: AppColor.whiteColor.withOpacity(0.9),
        //     borderRadius: BorderRadius.circular(15),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.1),
        //         blurRadius: 10,
        //         spreadRadius: 2,
        //         offset: Offset(0, 5),
        //       ),
        //     ],
        //   ),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               "Redes Sociales",
        //               style: TextStyle(
        //                 fontFamily: AppFonts.Mina,
        //                 fontSize: 22,
        //                 fontWeight: FontWeight.bold,
        //                 color: AppColor.primaryColor,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     _buildSocialIcon(FontAwesomeIcons.facebook, AppColor.facebookColor),
        //     _buildSocialIcon(FontAwesomeIcons.tiktok, AppColor.tiktokColor),
        //     _buildSocialIcon(FontAwesomeIcons.youtube, AppColor.youtubeColor),
        //     _buildSocialIcon(FontAwesomeIcons.globe, AppColor.primaryColor),
        //     _buildSocialIcon(FontAwesomeIcons.whatsapp, AppColor.whatsappColor),
        //   ],
        // ),
        buildEventSection(
          "Menu",
          "Explora nuestras opciones disponibles",
          FontAwesomeIcons.bars,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIcons(
              FontAwesomeIcons.calendarDays,
              AppColor.secondaryColor,
              "Eventos",
              () {},
            ),
            _buildIcons(
              FontAwesomeIcons.graduationCap,
              AppColor.secondaryColor,
              "Ofertas\nAcadémicas",
              () {
                setState(() {});
              },
            ),
            _buildIcons(
              FontAwesomeIcons.building,
              AppColor.secondaryColor,
              "Sedes",
              () {},
            ),
            _buildIcons(
              FontAwesomeIcons.circleInfo,
              AppColor.secondaryColor,
              "Información",
              () {},
            ),
          ],
        ),
        buildEventSection(
          "Novedades",
          "Mantente informado con las últimas novedades y actualizaciones.",
          FontAwesomeIcons.newspaper,
        ),
        Column(
           children: novedades.map<Widget>((novedad) {
            return NewsCard(
              imageUrl: "${AppUrl.baseImage}/storage/blog/${novedad.blogImagen}",
              title: novedad.blogTitulo,
              description: novedad.blogDescripcion,
              date: novedad.createdAt,
            );
          }).toList(),
        ),
      ],
    );
  }

  // Widget _buildProfileHeader() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   ClipRRect(
  //                     child: Image.network(
  //                       "${AppUrl.baseImage}/storage/profe/${homeController.profeId.value.respuesta!.profeImagen}",
  //                       width: 150,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 10),
  //               _buildMissionText(),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildIcons(
    IconData icon,
    Color color,
    String title,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColor.whiteColor,
            backgroundColor:
                color, // Color del texto y los íconos cuando el botón está presionado
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ), // Ajustar el tamaño del botón
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                size: 30, // Tamaño del ícono
                color: AppColor.whiteColor, // Color del ícono
              ),
              SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.Mina,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.whiteColor, // Color del texto
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildSocialIcon(IconData icon, Color color) {
  //   return IconButton(
  //     iconSize: 30,
  //     icon: FaIcon(icon),
  //     color: color,
  //     onPressed: () {
  //       // Acción para el ícono de red social
  //     },
  //   );
  // }

  // Widget _buildMissionText() {
  //   return Text(
  //     convertirHtmlATexto(
  //       homeController.profeId.value.respuesta!.profeMision.toString(),
  //     ),
  //     style: TextStyle(
  //       fontFamily: AppFonts.Mina,
  //       fontSize: 14,
  //       fontWeight: FontWeight.w500,
  //       color: AppColor.greyColor,
  //       height: 1.2,
  //     ),
  //     maxLines: 3,
  //     overflow: TextOverflow.ellipsis,
  //     textAlign: TextAlign.justify,
  //   );
  // }

  Widget _buildEventCarousel(List eventos) {
    return Column(
      children: [
        CarouselSlider(
          items: eventos.map((evento) => _buildEventCard(evento)).toList(),
          options: CarouselOptions(
            // height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
            aspectRatio: 16 / 9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
            autoPlayInterval: const Duration(seconds: 7),
          ),
        ),
        const SizedBox(height: 5),
        _buildCarouselIndicator(eventos),
      ],
    );
  }

  Widget _buildEventCard(evento) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            "${AppUrl.baseImage}/storage/evento_afiches/${evento.eveAfiche}",
            width: double.infinity,
            //height: 220,
            fit: BoxFit.cover,
          ),
        ),
        _buildEventGradient(),
        Positioned(
          bottom: 0,
          left: 20,
          child: _buildEventDetails(evento),
        ),
      ],
    );
  }

  Widget _buildEventGradient() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColor.blackColor.withValues(alpha: 0.5),
            AppColor.transparentColor,
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetails(evento) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          evento.etNombre.toString(),
          style: TextStyle(
            fontFamily: AppFonts.Mina,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          evento.eveFecha.toString(),
          style: TextStyle(
            fontFamily: AppFonts.Mina,
            fontSize: 16,
            color: AppColor.grey2Color,
          ),
        ),
        const SizedBox(height: 10),
        _buildEventActions(evento),
      ],
    );
  }

  Widget _buildEventActions(evento) {
    return Row(
      children: [
        if (evento.eveInscripcion == 1) _buildInscriptionButton(),
        const SizedBox(width: 10),
        if (evento.eveAsistencia == 1) _buildAttendanceButton(),
      ],
    );
  }

  Widget _buildInscriptionButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        "Inscribirse",
        style: TextStyle(
          fontFamily: AppFonts.Mina,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }

  Widget _buildAttendanceButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        "Asistencia",
        style: TextStyle(
          fontFamily: AppFonts.Mina,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }

  Widget _buildCarouselIndicator(List eventos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        eventos.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: _currentIndex == index ? 14 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                _currentIndex == index
                    ? AppColor.primaryColor
                    : AppColor.grey2Color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
