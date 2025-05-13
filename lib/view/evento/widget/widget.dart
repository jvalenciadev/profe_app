import 'package:flutter/material.dart';

import '../../../res/colors/app_color.dart';
import '../../../res/fonts/app_fonts.dart';

Widget buildCertRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            fontFamily: AppFonts.mina,
            color: AppColor.blackColor,
          ),
        ),
      ),
      Expanded(
        flex: 5,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontFamily: AppFonts.mina,
            color: AppColor.blackColor,
          ),
        ),
      ),
    ],
  );
}

Widget buildField({
  TextEditingController? controller,
  String? initialValue,
  required String hint,
  required String label,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  Color labelColor = AppColor.primaryColor,
  bool readOnly = false,
}) {
  final inputDecoration = InputDecoration(
    hintText: readOnly ? null : hint,
    prefixIcon: Icon(icon, color: AppColor.greyColor),
    filled: true,
    fillColor: readOnly ? AppColor.grey3Color : AppColor.whiteColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColor.grey2Color, width: 1.5),
    ),
  );

  final textStyle = const TextStyle(fontFamily: AppFonts.mina, fontSize: 15);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.mina,
          fontWeight: FontWeight.w500,
          color: labelColor,
          fontSize: 15,
        ),
      ),
      const SizedBox(height: 2),
      TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        keyboardType: keyboardType,
        style: textStyle,
        cursorColor: AppColor.primaryColor,
        decoration: inputDecoration,
        readOnly: readOnly,
        enabled: !readOnly,
        validator:
            readOnly
                ? null
                : (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
      ),
      const SizedBox(height: 8),
    ],
  );
}
