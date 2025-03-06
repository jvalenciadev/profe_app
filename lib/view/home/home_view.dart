import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/user_preference/user_prefrence_view_model.dart';

import '../../view_models/controller/home/home_view_models.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final homeController = Get.put(HomeController());

  UserPreference userPreference = UserPreference();


  @override
  void initState() {
    super.initState();
    // homeController.userListApi();

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            userPreference.removeUser().then((value){
              Get.toNamed(RouteName.loginView);
            });
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(),
    );
  }
}
