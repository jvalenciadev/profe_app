import 'package:flutter/material.dart';

import '../res/colors/app_color.dart';

class LoadingContainer extends StatelessWidget {
  final double size;
  final Color color;
  final String message;

  const LoadingContainer({
    super.key,
    this.size = 40.0,
    this.color = Colors.blueAccent,
    this.message = 'Cargando...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              color: AppColor.grey2Color,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
