import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:programa_profe/res/assets/image_assets.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';

import '../../data/response/status.dart';
import '../../res/app_url/app_url.dart';
import '../../res/colors/app_color.dart';
import '../../res/routes/routes_name.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/home/home_view_models.dart';
import '../../view_models/controller/radio_controller.dart';
import '../widgets/home_widgets.dart';
import '../widgets/loading_carusel_widget.dart';
import '../widgets/novedades_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.find<HomeController>();
  final radioCtrl = Get.find<RadioController>();
  final String streamUrl = 'https://node-17.zeno.fm/7qzeshy6xf8uv.aac';

  @override
  void initState() {
    super.initState();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: homeController.refreshAll,
      color: AppColor.primaryColor,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: _buildCompletedState(),
        ),
      ),
    );
  }

  /// Widget reutilizable que muestra loading, error o el contenido.
  Widget _stateHandler({
    required Status status,
    required Widget Function() onSuccess,
    required VoidCallback onRetry,
  }) {
    switch (status) {
      case Status.LOADING:
        return LoadingCarouselPlaceholder(); // o tu indicador unificado
      case Status.ERROR:
        return buildErrorWidget(onRetry);
      case Status.COMPLETED:
        return onSuccess();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCompletedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //_buildProfileHeader(),
        buildEventSection(
          "Eventos",
          "Únete a nuestros eventos y mejora tu enseñanza. ¡Inscríbete ahora!",
          FontAwesomeIcons.calendarDays,
        ),
        Obx(() {
          return _stateHandler(
            status: homeController.eventosStatus.value,
            onRetry: homeController.refreshAll,
            onSuccess: () {
              final eventos =
                  homeController.eventoList.value.respuesta!.take(5).toList();
              return _buildEventCarousel(eventos);
            },
          );
        }),
        SizedBox(height: 5),
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
              () {
                setState(() {
                  Get.toNamed(RouteName.eventoView);
                });
              },
            ),
            _buildIcons(
              FontAwesomeIcons.graduationCap,
              AppColor.secondaryColor,
              "Ofertas\nAcadémicas",
              () {
                setState(() {
                  Get.toNamed(RouteName.programaView);
                });
              },
            ),
            _buildIcons(
              FontAwesomeIcons.building,
              AppColor.secondaryColor,
              "Sedes",
              () {
                setState(() {
                  Get.toNamed(RouteName.sedeView);
                });
              },
            ),
            _buildIcons(
              FontAwesomeIcons.circleInfo,
              AppColor.secondaryColor,
              "Información",
              () {
                setState(() {
                  Get.toNamed(RouteName.informacionView);
                });
              },
            ),
          ],
        ),
        SizedBox(height: 5),
        Card(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Logo de la radio
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.radioStream, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      ImageAssets.logoradio,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Texto y estado
                Expanded(
                  child: Obx(() {
                    final radio = radioCtrl;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sintonía Educativo',
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.radioStream,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              radio.hasError
                                  ? FontAwesomeIcons.triangleExclamation
                                  : radio.isPlaying
                                  ? FontAwesomeIcons.wifi
                                  : FontAwesomeIcons.radio,
                              size: 14,
                              color:
                                  radio.hasError
                                      ? AppColor.redColor
                                      : AppColor.greyColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              radio.hasError
                                  ? 'Error de conexión'
                                  : radio.isPlaying
                                  ? 'Reproduciendo...'
                                  : 'Disponible',
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    radio.hasError
                                        ? AppColor.redColor
                                        : AppColor.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),

                // Botón play/pause o retry
                Obx(() {
                  final radio = radioCtrl;

                  if (radio.hasError) {
                    // Mostrar botón de retry
                    return IconButton(
                      iconSize: 25,
                      splashRadius: 28,
                      icon: const Icon(
                        FontAwesomeIcons.rotateRight,
                        color: AppColor.redColor,
                      ),
                      onPressed: radio.retry,
                      tooltip: 'Reintentar conexión',
                    );
                  }

                  if (radio.isLoading) {
                    return const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.grey2Color,
                        ),
                      ),
                    );
                  }

                  return IconButton(
                    iconSize: 40,
                    splashRadius: 28,
                    icon: Icon(
                      radio.isPlaying
                          ? FontAwesomeIcons.pause
                          : FontAwesomeIcons.play,
                      color: AppColor.radioStream,
                      size: 25,
                    ),
                    onPressed: radio.togglePlayPause,
                  );
                }),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        buildEventSection(
          "Novedades",
          "Mantente informado con las últimas novedades y actualizaciones.",
          FontAwesomeIcons.newspaper,
        ),
        Obx(() {
          return _stateHandler(
            status: homeController.novedadesStatus.value,
            onRetry: homeController.refreshAll,
            onSuccess: () {
              final novedades = homeController.novedadList.value.respuesta!;
              return Column(
                children:
                    novedades.map((n) {
                      return NewsCard(
                        imageUrl:
                            "${AppUrl.baseImage}/storage/blog/${n.blogImagen}",
                        title: n.blogTitulo!,
                        description: mostrarHtml(n.blogDescripcion!),
                        date: n.createdAt!,
                      );
                    }).toList(),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildIcons(
    IconData icon,
    Color color,
    String title,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Pulse(
                                              from: 1,
                                              to: 1.02,
                                              infinite: true,
                                              child: ElevatedButton(
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
                  fontFamily: AppFonts.mina,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.whiteColor, // Color del texto
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),),
      ],
    );
  }

  Widget _buildEventCarousel(List eventos) {
    return Column(
      children: [
        CarouselSlider(
          items: eventos.map((evento) => _buildEventCard(evento)).toList(),
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.95,
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

  Widget _buildCarouselIndicator(List eventos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        eventos.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: _currentIndex == index ? 18 : 10,
          height: 6,
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

  Widget _buildEventCard(evento) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl:
                "${AppUrl.baseImage}/storage/evento_afiches/${evento.eveAfiche}",
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Center(
                  child: CircularProgressIndicator(color: AppColor.grey2Color),
                ),
            errorWidget:
                (context, url, error) => Center(
                  child: Icon(
                    FontAwesomeIcons.image,
                    size: 50,
                    color: AppColor.grey2Color,
                  ),
                ),
          ),
        ),
        _buildEventGradient(),
        Positioned(
          top: 10,
          right: 10,
          child: Material(
            // Fondo y sombra del botón
            color: AppColor.secondaryColor.withOpacity(0.5),
            shape: const CircleBorder(),
            elevation: 4,
            child: IconButton(
              // Acción al pulsar
              onPressed: () {
                Get.toNamed(RouteName.eventoDetalleView, arguments: evento);
              },
              icon: const Icon(
                FontAwesomeIcons.chevronRight,
                size: 18,
                color: AppColor.whiteColor,
              ),
              // Espacio alrededor del icono
              padding: const EdgeInsets.all(10),
              // Define la forma para el splash
              splashRadius: 24,
              // Color de la onda al tocar
              splashColor: AppColor.whiteColor.withOpacity(0.3),
              highlightColor: AppColor.whiteColor.withOpacity(0.1),
              // Constraint vacías para no agregar espacios extra
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 15,
          right: 15,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento.etNombre.toString(),
              style: const TextStyle(
                fontFamily: AppFonts.mina,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.whiteColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              evento.eveFecha.toString(),
              style: const TextStyle(
                fontFamily: AppFonts.mina,
                fontSize: 14,
                color: AppColor.grey2Color,
              ),
            ),
          ],
        ),
        _buildEventActions(evento),
      ],
    );
  }

  Widget _buildEventActions(evento) {
    return Row(
      children: [
        if (evento.eveInscripcion == 1) _buildInscriptionButton(evento),
        const SizedBox(width: 10),
        if (evento.eveAsistencia == true) _buildAttendanceButton(evento),
      ],
    );
  }

  Widget _buildInscriptionButton(dynamic evento) {
    return Pulse(
      from: 1,
      to: 1.02,
      infinite: true,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            Get.toNamed(RouteName.eventoInscripcionView, arguments: evento);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: Colors.white, // Esto mejora el efecto en presión
          shadowColor: Colors.black.withOpacity(0.4),
        ),
        child: Text(
          "Inscríbete",
          style: TextStyle(
            fontFamily: AppFonts.mina,
            fontSize: 15,
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceButton(dynamic evento) {
    return Pulse(
      from: 1,
      to: 1.02,
      infinite: true,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            Get.toNamed(RouteName.eventoAsistenciaView, arguments: evento);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: Colors.white, // Esto mejora el efecto en presión
          shadowColor: Colors.black.withOpacity(0.4),
        ),

        child: Text(
          "Asistencia",
          style: TextStyle(
            fontFamily: AppFonts.mina,
            fontSize: 15,
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
