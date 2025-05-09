import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:programa_profe/view/home/home_screen.dart';
import '../../res/assets/image_assets.dart';
import '../../res/colors/app_color.dart';
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
  final homeController = Get.put(HomeController(), permanent: true);

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    try {
      homeController.onInit();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load home data');
    }
  }

  int _currentIndex = 2;
  final List<String> _titles = [
    "Eventos",
    "Ofertas académicas",
    "Home",
    "Sedes",
    "Información",
  ];
  final List<Widget> _screens = [
    EventScreen(),
    OffersScreen(),
    HomeScreen(),
    SedesScreen(),
    InformationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 850;
    return Scaffold(
      appBar:
          isSmallScreen
              ? null // ❌ Oculta AppBar completamente si la pantalla es muy pequeña
              : AppBar(
                automaticallyImplyLeading:
                    false, // No muestra el ícono de "atrás"
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
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
                    // Título de la sección
                    Text(
                      _titles[_currentIndex],
                      style: TextStyle(
                        fontFamily: 'Mina',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.whiteColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Logo de la empresa
                    Image.asset(
                      ImageAssets.logoProfe,
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: _buildBottomNavBar(),
      body: _screens[_currentIndex],
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
      child: GNav(
        rippleColor: AppColor.secondaryColor,
        hoverColor: AppColor.primaryColor,
        backgroundColor: AppColor.whiteColor,
        color: AppColor.primaryColor,
        activeColor: AppColor.whiteColor,
        tabActiveBorder: Border.all(color: AppColor.whiteColor, width: 1),
        tabBorder: Border.all(color: AppColor.whiteColor, width: 1),
        tabShadow: const [BoxShadow(color: AppColor.whiteColor, blurRadius: 8)],
        curve: Curves.bounceIn,
        duration: const Duration(milliseconds: 400),
        tabBackgroundColor: AppColor.secondaryColor,
        gap: 8,
        tabBorderRadius: 15,
        haptic: true,
        onTabChange: (index) => setState(() => _currentIndex = index),
        selectedIndex: _currentIndex,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        tabs: const [
          GButton(
            icon: FontAwesomeIcons.calendarDays,
            iconSize: 20,
            text: 'Eventos',
          ),
          GButton(
            icon: FontAwesomeIcons.graduationCap,
            iconSize: 20,
            text: 'Ofertas',
          ),
          GButton(
            icon: FontAwesomeIcons.houseChimney,
            iconSize: 20,
            text: 'Home',
          ),
          GButton(icon: FontAwesomeIcons.building, iconSize: 20, text: 'Sedes'),
        ],
      ),
    );
  }
}
