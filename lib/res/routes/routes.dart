

import 'package:get/get.dart';
import '../../res/routes/routes_name.dart';
import '../../view/home/home_view.dart';
import '../../view/login/login_view.dart';
import '../../view/splash_screen.dart';
import '../../view/widgets/update_app_view.dart';

class AppRoutes {

  static appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashScreen() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.loginView,
      page: () => LoginView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.homeView,
      page: () => HomeView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.updateAppView,
      page: () => UpdateAppView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
  ];

}