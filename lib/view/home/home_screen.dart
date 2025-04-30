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
import '../../utils/preloader.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/home/home_view_models.dart';
import '../widgets/home_widgets.dart';
import '../widgets/novedades_widget.dart';
import 'package:just_audio/just_audio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class RadioPlayerService {
  static final RadioPlayerService _instance = RadioPlayerService._internal();

  factory RadioPlayerService() => _instance;

  late final AudioPlayer player;

  RadioPlayerService._internal() {
    player = AudioPlayer();
  }
}

final radioService = RadioPlayerService();

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.find<HomeController>();
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _hasError = false;
  bool _isLoading = true;

  final String streamUrl = 'https://node-17.zeno.fm/7qzeshy6xf8uv.aac';

  @override
  void initState() {
    super.initState();
    _player = radioService.player;

    if (!_player.playing) {
      _initializePlayer();
    } else {
      setState(() {
        _isLoading = false;
        _isPlaying = true;
      });
    }
  }

  Future<void> _initializePlayer() async {
    try {
      await _player.setUrl(streamUrl);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _togglePlayPause() {
    if (_player.playing) {
      _player.pause();
      setState(() => _isPlaying = false);
    } else {
      _player.play();
      setState(() => _isPlaying = true);
    }
  }
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Obx(() {
          switch (homeController.rxRequestStatus.value) {
            case Status.LOADING:
              return LoadingContainer();
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
          style: TextStyle(fontFamily: AppFonts.mina),
        ),
      );
    }
    if (homeController.novedadList.value.respuesta == null ||
        homeController.novedadList.value.respuesta!.isEmpty) {
      return Center(
        child: Text(
          "No hay novedades disponibles",
          style: TextStyle(fontFamily: AppFonts.mina),
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
        //                 fontFamily: AppFonts.mina,
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
                      'assets/logos/logo_radio.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Texto y estado
                Expanded(
                  child: Column(
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
                            _hasError
                                ? Icons.error_outline
                                : _isPlaying
                                ? Icons.wifi_tethering
                                : Icons.radio,
                            size: 14,
                            color:
                                _hasError
                                    ? AppColor.redColor
                                    : AppColor.greyColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _hasError
                                ? 'Error de conexión'
                                : _isPlaying
                                ? 'Reproduciendo'
                                : 'Disponible',
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  _hasError
                                      ? AppColor.redColor
                                      : AppColor.greyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Botón de reproducción
                _isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                      iconSize: 40,
                      splashRadius: 28,
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle : Icons.play_circle,
                        color: AppColor.radioStream,
                      ),
                      onPressed: _togglePlayPause,
                    ),
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
        Column(
          children:
              novedades.map<Widget>((novedad) {
                return NewsCard(
                  imageUrl:
                      "${AppUrl.baseImage}/storage/blog/${novedad.blogImagen}",
                  title: novedad.blogTitulo,
                  description: mostrarHtml(novedad.blogDescripcion),
                  date: novedad.createdAt,
                );
              }).toList(),
        ),
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
                  fontFamily: AppFonts.mina,
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
  Widget _buildEventCarousel(List eventos) {
    return Column(
      children: [
        CarouselSlider(
          items: eventos.map((evento) => _buildEventCard(evento)).toList(),
          options: CarouselOptions(
            // height: 200,
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
        Positioned(bottom: 0, left: 20, child: _buildEventDetails(evento)),
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
            fontFamily: AppFonts.mina,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          evento.eveFecha.toString(),
          style: TextStyle(
            fontFamily: AppFonts.mina,
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
          fontFamily: AppFonts.mina,
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
          fontFamily: AppFonts.mina,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }

  
}
