import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../data/response/status.dart';
import '../../res/app_url/app_url.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/general_exception.dart';
import '../../res/components/internet_exceptions_widget.dart';
import '../../utils/utilidad.dart';
import '../../view_models/controller/home/home_view_models.dart';
import '../evento/evento_view.dart';
import '../informacion/informacion_view.dart';
import '../programa/programa_view.dart';
import '../sede/sede_view.dart';
import '../widgets/home_widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.homeListApi();
  }

  int _currentIndex = 2;
  final List<Widget> _screens = [
    EventScreen(),
    OffersScreen(),
    HomeScreen(),
    SedesScreen(),
    InformationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeOut,
        color: AppColor.primaryColor,
        buttonBackgroundColor: AppColor.primaryColor,
        height: 75,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(CupertinoIcons.calendar, size: 30, color: Colors.white),
          Icon(FontAwesomeIcons.graduationCap, size: 30, color: Colors.white),
          Icon(CupertinoIcons.house_fill, size: 30, color: Colors.white),
          Icon(CupertinoIcons.location_fill, size: 30, color: Colors.white),
          Icon(CupertinoIcons.info_circle, size: 30, color: Colors.white),
        ],
      ),
      body: _screens[_currentIndex],
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
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
      return Center(child: Text("No hay eventos disponibles"));
    }

    List eventos = homeController.eventoList.value.respuesta!.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileHeader(),
        buildEventSection(
          "Eventos",
          "Únete a nuestros eventos y mejora tu enseñanza. ¡Inscríbete ahora!",
          FontAwesomeIcons.chalkboardUser,
        ),
        _buildEventCarousel(eventos),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          // decoration: BoxDecoration(
          // color: Colors.white.withOpacity(0.9),
          //   borderRadius: BorderRadius.circular(15),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.1),
          //       blurRadius: 10,
          //       spreadRadius: 2,
          //       offset: Offset(0, 5),
          //     ),
          //   ],
          // ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Redes Sociales",
                      style: TextStyle(
                        fontFamily: 'Mina',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildSocialIcons(),
        buildEventSection(
          "Ofertas Académicas",
          "Participa en los Ciclos Formativos, Diplomados y Especialidades.",
          FontAwesomeIcons.graduationCap,
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      child: Image.network(
                        "${AppUrl.baseImage}/storage/profe/${homeController.profeId.value.respuesta!.profeImagen}",
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                _buildMissionText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialIcon(FontAwesomeIcons.facebook, AppColor.facebookColor),
        _buildSocialIcon(FontAwesomeIcons.tiktok, AppColor.tiktokColor),
        _buildSocialIcon(FontAwesomeIcons.youtube, AppColor.youtubeColor),
        _buildSocialIcon(FontAwesomeIcons.globe, AppColor.primaryColor),
        _buildSocialIcon(FontAwesomeIcons.whatsapp, AppColor.whatsappColor),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return IconButton(
      iconSize: 30,
      icon: FaIcon(icon),
      color: color,
      onPressed: () {
        // Acción para el ícono de red social
      },
    );
  }

  Widget _buildMissionText() {
    return Text(
      convertirHtmlATexto(
        homeController.profeId.value.respuesta!.profeMision.toString(),
      ),
      style: TextStyle(
        fontFamily: 'Mina',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColor.greyColor,
        height: 1.5,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildEventCarousel(List eventos) {
    return Column(
      children: [
        CarouselSlider(
          items: eventos.map((evento) => _buildEventCard(evento)).toList(),
          options: CarouselOptions(
            height: 200,
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
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        _buildEventGradient(),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
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
            AppColor.blackColor.withValues(alpha: 0.6),
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
            fontFamily: 'Mina',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          evento.eveFecha.toString(),
          style: TextStyle(
            fontFamily: 'Mina',
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
          fontFamily: 'Mina',
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
          fontFamily: 'Mina',
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
