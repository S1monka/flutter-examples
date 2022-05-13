import 'package:catchup/app/theme_config.dart';
import 'package:flutter/material.dart';

class Marker extends StatelessWidget {
  final double width;

  Marker({Key? key, required this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 1,
        width: width,
        color: AppColors.orange,
      ),
    );
  }
}
