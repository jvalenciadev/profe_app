import 'package:flutter/material.dart';
import 'package:programa_profe/res/colors/app_color.dart';

class NewsCardLoading extends StatelessWidget {
  const NewsCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: AppColor.whiteColor,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(50, 0, 0, 0),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: Color.fromARGB(94, 255, 255, 255),
              blurRadius: 4,
              offset: Offset(-2, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen simulada
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
              child: Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),

            // Título y fecha
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título simulado
                  Expanded(
                    child: Container(
                      height: 20,
                      color: Colors.grey[300],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Fecha simulada
                  Container(
                    height: 16,
                    width: 60,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),

            // Descripción simulada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Container(height: 14, width: double.infinity, color: Colors.grey[300]),
                  const SizedBox(height: 6),
                  Container(height: 14, width: double.infinity, color: Colors.grey[300]),
                  const SizedBox(height: 6),
                  Container(height: 14, width: 200, color: Colors.grey[300]),
                ],
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
