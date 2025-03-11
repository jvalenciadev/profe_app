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
          Icon(CupertinoIcons.book_fill, size: 30, color: Colors.white),
          Icon(CupertinoIcons.house_fill, size: 30, color: Colors.white),
          Icon(CupertinoIcons.location_fill, size: 30, color: Colors.white),
          Icon(CupertinoIcons.info_circle, size: 30, color: Colors.white),
        ],
      ),
      body: _screens[_currentIndex],
    );
  }
}

// 🏡 Pantalla de Inicio
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.find<HomeController>();

  final List<String> carouselItems = [
    'assets/images/slide1.jpg',
    'assets/images/slide1.jpg',
    'assets/images/slide1.jpg',
    'assets/images/slide1.jpg',
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Obx(() {
          switch (homeController.rxRequestStatus.value) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator());
            case Status.ERROR:
              if (homeController.error.value == 'No internet') {
                return InterNetExceptionWidget(
                  onPress: () {
                    homeController.refreshApi();
                  },
                );
              } else {
                return GeneralExceptionWidget(
                  onPress: () {
                    homeController.refreshApi();
                  },
                );
              }
            case Status.COMPLETED:
              if (homeController.eventoList.value.respuesta == null ||
                  homeController.eventoList.value.respuesta!.isEmpty) {
                return Center(child: Text("No hay eventos disponibles"));
              }

              List eventos =
                  homeController.eventoList.value.respuesta!.take(6).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    child: Image.network(
                                      "${AppUrl.baseImage}/storage/profe/${homeController.profeId.value.respuesta!.profeImagen}",
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        iconSize: 30,
                                        icon: FaIcon(FontAwesomeIcons.facebook),
                                        color: AppColor.facebookColor,
                                        onPressed: () {
                                          // Acción para el ícono de Facebook
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      IconButton(
                                        iconSize: 30,
                                        icon: FaIcon(FontAwesomeIcons.tiktok),
                                        color: AppColor.tiktokColor,
                                        onPressed: () {
                                          // Acción para el ícono de TikTok
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      IconButton(
                                        iconSize: 30,
                                        icon: FaIcon(FontAwesomeIcons.whatsapp),
                                        color: AppColor.whatsappColor,
                                        onPressed: () {
                                          // Acción para el ícono de WhatsApp
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                convertirHtmlATexto(
                                  homeController
                                      .profeId
                                      .value
                                      .respuesta!
                                      .profeMision
                                      .toString(),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.blackColor,
                                  height:
                                      1.5, // Espaciado más suave entre líneas
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Column(
                    children: [
                      CarouselSlider(
                        items:
                            eventos.map((evento) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      "${AppUrl.baseImage}/storage/evento_afiches/${evento.eveAfiche}",
                                      width: double.infinity,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          evento.eveNombre.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.whiteColor,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          evento.eveFecha.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColor.grey2Color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                        options: CarouselOptions(
                          height: 300,
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
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          eventos.length,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: _currentIndex == index ? 12 : 8,
                            height: _currentIndex == index ? 12 : 8,
                            decoration: BoxDecoration(
                              color:
                                  _currentIndex == index
                                      ? AppColor.primaryColor
                                      : AppColor.grey2Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
          }
        }),
      ),
    );
  }
}
