import 'package:catchup/core/index.dart';
import 'package:catchup/data/models/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:catchup/app/theme_config.dart';

class OrderCalendarWidget extends StatelessWidget {
  final Event orderEvent;
  final bool isTimePicked;
  const OrderCalendarWidget({
    Key? key,
    required this.orderEvent,
    required this.isTimePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.07),
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: 17.h,
                      width: 81.w,
                      decoration: const BoxDecoration(
                        color: AppColors.grey20,
                      ),
                    ),
                    Positioned(
                      left: 18.w,
                      top: -7.5.h,
                      child: Container(
                        width: 2.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: AppColors.grey70,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 18.w,
                      top: -7.5.h,
                      child: Container(
                        width: 2.w,
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: AppColors.grey70,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  width: 81.w,
                  height: 84.h,
                  color: Colors.white,
                  child: Builder(builder: (context) {
                    final day = orderEvent.startAt.day;
                    final formattedMonth = DateFormat(
                            'MMMM', context.locale.toStringWithSeparator())
                        .format(orderEvent.startAt);
                    return Column(
                      children: [
                        Text(
                          day.toString(),
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          formattedMonth,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (isTimePicked)
                  Text(
                    DateFormat.Hm(context.locale.toStringWithSeparator())
                            .format(orderEvent.startAt) +
                        ' - ' +
                        DateFormat.Hm(context.locale.toStringWithSeparator())
                            .format(orderEvent.endAt),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                UserListTile(
                  user: orderEvent.order.client,
                  dense: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            color: AppColors.grey40,
            iconSize: 24.r,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
