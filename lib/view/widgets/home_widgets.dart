import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';

Widget buildEventSection(String? title, String? description, IconData? icon) {
  return Container(
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
        FaIcon(icon, size: 25, color: AppColor.primaryColor),
        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: TextStyle(
                  fontFamily: AppFonts.Mina,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
              ),
              if (description != null)
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: AppFonts.Mina,
                      fontSize: 14,
                      color: AppColor.greyColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
            ],
          ),
        ),
      ],
    ),
  );
}
