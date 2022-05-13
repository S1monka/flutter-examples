import 'package:catchup/app/theme_config.dart';
import 'package:flutter/material.dart';

class Dow extends StatelessWidget {
  final String dayOfWeek;

  Dow({Key? key, required this.dayOfWeek}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: Text(
          dayOfWeek,
          style: Theme.of(context).textTheme.subtitle1!,
        ),
      ),
    );
  }
}
