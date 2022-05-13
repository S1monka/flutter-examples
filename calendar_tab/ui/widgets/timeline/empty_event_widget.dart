import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:catchup/app/theme_config.dart';
import 'package:catchup/data/models/calendar/events.dart';

class EmptyEventWidget extends StatelessWidget {
  final EmptyEvent event;
  final bool isPicked;
  final Function(EmptyEvent event) onTap;
  const EmptyEventWidget({
    Key? key,
    required this.event,
    this.isPicked = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(21.r),
      onTap: () {
        onTap(event);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isPicked ? AppColors.grey : Colors.white,
          border: Border.all(color: AppColors.grey50),
          borderRadius: BorderRadius.circular(21.r),
        ),
        padding: EdgeInsets.all(10.r),
        child: Text(
          DateFormat.Hm(context.locale.toStringWithSeparator())
                  .format(event.startAt) +
              ' - ' +
              DateFormat.Hm(context.locale.toStringWithSeparator())
                  .format(event.endAt),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
