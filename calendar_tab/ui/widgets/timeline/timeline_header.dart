import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:catchup/app/theme_config.dart';

class TimelineHeader extends StatelessWidget {
  final DateTime pickedDate;
  final Function(DateTime changedDate)? onDateChanged;
  const TimelineHeader({
    Key? key,
    required this.pickedDate,
    this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    DateFormat('d MMMM', context.locale.toStringWithSeparator())
                        .format(pickedDate),
                style: Theme.of(context).textTheme.headline1,
              ),
              const TextSpan(
                text: " ",
              ),
              TextSpan(
                text: DateFormat.y(context.locale.toStringWithSeparator())
                    .format(pickedDate),
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
        if (onDateChanged != null)
          Row(
            children: [
              InkWell(
                onTap: () {
                  onDateChanged!(pickedDate.subtract(const Duration(days: 1)));
                },
                child: SizedBox(
                  width: 48.r,
                  height: 48.r,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.grey,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  onDateChanged!(pickedDate.add(const Duration(days: 1)));
                },
                child: SizedBox(
                  width: 48.r,
                  height: 48.r,
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
