import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:programa_profe/res/colors/app_color.dart';
import 'package:programa_profe/res/fonts/app_fonts.dart';

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Widget description;
  final String date;

  NewsCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: AppColor.whiteColor,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(50, 0, 0, 0),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: const Color.fromARGB(94, 255, 255, 255),
              blurRadius: 4,
              offset: Offset(-2, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con bordes redondeados
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      height: 250,
                      color: AppColor.grey3Color,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.grey2Color,
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      height: 250,
                      color: AppColor.grey3Color,
                      child: Icon(
                        FontAwesomeIcons.image,
                        size: 50,
                        color: AppColor.grey2Color,
                      ),
                    ),
              ),
            ),

            // Row para el Título y la Fecha
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título con soporte de múltiples líneas
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppFonts.mina,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.blackColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),

                  // Fecha
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 0,
                    ),
                    child: Text(
                      date,
                      style: TextStyle(
                        fontFamily: AppFonts.mina,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Descripción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: description,
            ),

            // Agregar espacio extra en la parte inferior
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
