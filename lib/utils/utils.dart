import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../res/colors/app_color.dart';

class Utils {
  static void fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode nextFocus,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColor.blackColor,
      textColor: AppColor.whiteColor,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static toastMessageCenter(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColor.blackColor,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG,
      textColor: AppColor.whiteColor,
    );
  }

  static snackBar(String title, String message) {
    Get.snackbar(title, message);
  }
}
void showCustomSnackbar({
  required String title,
  required String message,
  required bool isError,
}) {
  Get.snackbar(
    title,
    message,
    // Posición en pantalla
    snackPosition: SnackPosition.BOTTOM,
    // Que flote sobre el contenido
    snackStyle: SnackStyle.FLOATING,
    // Margen respecto a bordes
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    // Radio de las esquinas
    borderRadius: 12,
    // Sombra para dar profundidad
    boxShadows: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    // Icono a la izquierda
    icon: Icon(
      isError ? Icons.error_outline : Icons.check_circle_outline,
      color: Colors.white,
    ),
    // Color de fondo según tipo
    backgroundColor:
        (isError ? Colors.redAccent : Colors.green).withOpacity(0.9),
    // Color del texto
    colorText: Colors.white,
    // Animaciones de entrada/salida
    animationDuration: Duration(milliseconds: 300),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    // Tiempo en pantalla
    duration: Duration(seconds: 3),
  );
}

class Department {
  final int id;
  final String name;
  final String abbreviation;

  const Department({required this.id, required this.name, required this.abbreviation});
}

/// Lista de departamentos de Bolivia con ID, nombre y abreviación.
const List<Department> departmentList = [
  Department(id: 1, name: 'CHUQUISACA', abbreviation: 'CH'),
  Department(id: 2, name: 'LA PAZ', abbreviation: 'LP'),
  Department(id: 3, name: 'COCHABAMBA', abbreviation: 'CB'),
  Department(id: 4, name: 'ORURO', abbreviation: 'OR'),
  Department(id: 5, name: 'POTOSI', abbreviation: 'PT'),
  Department(id: 6, name: 'TARIJA', abbreviation: 'TJ'),
  Department(id: 7, name: 'SANTA CRUZ', abbreviation: 'SC'),
  Department(id: 8, name: 'BENI', abbreviation: 'BN'),
  Department(id: 9, name: 'PANDO', abbreviation: 'PD'),
];