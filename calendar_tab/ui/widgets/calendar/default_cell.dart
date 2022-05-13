import 'package:catchup/app/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool isPicked;
  final bool isInCurrentMonth;
  final bool nonWorkDay;

  DefaultCell({
    Key? key,
    required this.date,
    this.isToday = false,
    this.isPicked = false,
    this.isInCurrentMonth = true,
    this.nonWorkDay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: isInCurrentMonth
            ? Border.all(
                color: AppColors.grey20,
                width: 0.5.r,
              )
            : null,
      ),
      child: Center(
        child: Builder(builder: (context) {
          final textWidget = Text(date.day.toString(),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: isToday || isPicked
                        ? Colors.white
                        : isInCurrentMonth && !nonWorkDay
                            ? AppColors.black
                            : AppColors.grey50,
                  ));
          if (isToday) {
            return Container(
              padding: EdgeInsets.all(15.r),
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
              child: textWidget,
            );
          } else if (isPicked) {
            return Container(
              padding: EdgeInsets.all(15.r),
              decoration: const BoxDecoration(
                color: AppColors.grey20,
                shape: BoxShape.circle,
              ),
              child: textWidget,
            );
          } else {
            return textWidget;
          }
        }),
      ),
    );
  }
}
