import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view_models/controller/home/home_view_models.dart';

class InformationScreen extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("🎓 Información", style: TextStyle(fontSize: 24)),
    );
  }
}
