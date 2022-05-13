import 'package:catchup/app/theme_config.dart';
import 'package:catchup/core/index.dart';
import 'package:catchup/data/models/index.dart';
import 'package:catchup/features/calendar_tab/bloc/calendar_tab_bloc.dart';
import 'package:catchup/features/calendar_tab/ui/widgets/calendar/calendar.dart';
import 'package:catchup/features/calendar_tab/ui/widgets/timeline/timeline_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarTabScreen extends StatelessWidget {
  CalendarTabScreen({Key? key}) : super(key: key);

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final calendarTabBloc = context.read<CalendarTabBloc>();
    return Scaffold(
      body: SafeArea(
        child: SingleDataLoaderWidget<CalendarTabBloc, CalendarTabState,
            List<Event>>(
          builderIfSuccess: (context, state) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Calendar(
                    events: state.data!,
                    pickedDate: state.pickedDate,
                    onDaySelected: (pickedDate) {
                      calendarTabBloc.add(PickDate(pickedDate));
                    },
                    onDayLongPressed: (pickedDate) {
                      calendarTabBloc.add(OnDayLongPress(pickedDate));
                    },
                  ),
                  SizedBox(height: 30.h),
                  Divider(
                    height: 0,
                    thickness: 1.r,
                    color: AppColors.grey20,
                  ),
                  TimelineWidget(
                    scrollController: scrollController,
                    events: state.currentDateEvents,
                    pickedDate: state.pickedDate,
                    onDateChanged: (changedDate) {
                      calendarTabBloc.add(PickDate(changedDate));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
