import 'package:get/get.dart';
import 'package:programa_profe/view/evento/evento_asistencia.dart';
import 'package:programa_profe/view/evento/evento_formulario.dart';
import 'package:programa_profe/view/evento/evento_inscripcion.dart';
import '../../res/routes/routes_name.dart';
import '../../view/evento/evento_detalle.dart';
import '../../view/evento/evento_view.dart';
import '../../view/home/home_view.dart';
import '../../view/informacion/informacion_view.dart';
import '../../view/programa/programa_view.dart';
import '../../view/sede/sede_view.dart';
import '../../view/splash_screen.dart';
import '../../view/widgets/update_app_view.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.homeView,
      page: () => HomeView(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RouteName.updateAppView,
      page: () => UpdateAppView(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteName.programaView,
      page: () => OffersScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteName.sedeView,
      page: () => SedesScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteName.informacionView,
      page: () => InformationScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),

    GetPage(
      name: RouteName.eventoView,
      page: () => EventScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.eventoDetalleView,
      page: () => EventDetalleScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.size,
    ),
    GetPage(
      name: RouteName.eventoAsistenciaView,
      page: () => EventoAsistenciaScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.eventoInscripcionView,
      page: () => EventoInscripcionScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.eventoFormularioView,
      page: () => EventoFormularioScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
