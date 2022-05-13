import 'package:catchup/core/index.dart';
import 'package:catchup/data/models/index.dart';
import 'package:catchup/features/calendar_tab/bloc/calendar_tab_bloc.dart';
import 'package:catchup/features/calendar_tab/ui/order_time_picker_screen.dart';
import 'package:catchup/features/calendar_tab/ui/widgets/calendar/calendar.dart';
import 'package:catchup/features/calendar_tab/ui/widgets/order_calendar_widget.dart';
import 'package:catchup/features/order_generation/ui/order_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarTabOrderScreen extends StatelessWidget {
  static const routeName = '/calendarTabOrderScreen';
  CalendarTabOrderScreen({Key? key}) : super(key: key);

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final calendarTabBloc = context.read<CalendarTabBloc>();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'calendar',
      ),
      body: SafeArea(
        child: SingleDataLoaderWidget<CalendarTabBloc, CalendarTabState,
            List<Event>>(
          bloc: calendarTabBloc,
          builderIfSuccess: (context, state) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Calendar(
                    pickedDate: state.pickedDate,
                    events: state.data!,
                    onDaySelected: (selectedDate) {
                      calendarTabBloc.add(PickDate(selectedDate));
                      Navigator.of(context).pushNamed(
                        OrderTimePickerScreen.routeName,
                        arguments: calendarTabBloc,
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                  OrderCalendarWidget(
                    orderEvent: state.newEvent!,
                    isTimePicked: state.isTimePicked,
                  ),
                  SizedBox(height: 30.h),
                  if (state.isTimePicked)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CustomRoundButton(
                          color: Colors.black,
                          title: 'next'.tr(),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              OrderDetailsScreen.routeName,
                              arguments: state.newEvent!,
                            );
                          }),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
