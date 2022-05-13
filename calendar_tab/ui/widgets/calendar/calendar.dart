import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:catchup/app/theme_config.dart';
import 'package:catchup/core/index.dart';
import 'package:catchup/data/models/index.dart';

import 'index.dart';

class Calendar extends StatefulWidget {
  final DateTime pickedDate;
  final List<Event> events;
  final Function(DateTime pickedDate) onDaySelected;
  final Function(DateTime pickedDate)? onDayLongPressed;
  Calendar({
    Key? key,
    required this.pickedDate,
    required this.onDaySelected,
    required this.events,
    this.onDayLongPressed,
  }) : super(key: key);

  static final firstDay = DateTime(currentDay.year, currentDay.month);
  static final currentDay = DateTime.now();
  static final lastDay =
      DateTime(currentDay.year + 1, currentDay.month, currentDay.day);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  final DateTime _focusedDay = Calendar.currentDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Event>(
      daysOfWeekHeight: 50.h,
      availableGestures: AvailableGestures.all,

      ///locale
      locale: context.locale.toStringWithSeparator(),

      ///days
      firstDay: Calendar.firstDay,
      lastDay: Calendar.lastDay,
      focusedDay: _focusedDay,

      startingDayOfWeek: StartingDayOfWeek.monday,

      selectedDayPredicate: (day) {
        return isSameDay(widget.pickedDate, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        widget.onDaySelected(selectedDay);
      },

      onDayLongPressed: (selectedDay, focusedDay) {
        if (widget.onDayLongPressed != null) {
          widget.onDayLongPressed!(selectedDay);
        }
      },

      currentDay: Calendar.currentDay,

      calendarFormat: _calendarFormat,

      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: Theme.of(context).textTheme.bodyText1!,
        weekendStyle: Theme.of(context).textTheme.bodyText1!,
      ),

      headerStyle: HeaderStyle(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        leftChevronIcon: const Icon(
          Icons.chevron_left_rounded,
          color: AppColors.grey,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.grey,
        ),
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) {
          final dateString = DateFormat.yMMM(locale).format(date).toUpperCase();
          return dateString.substring(0, dateString.length - 3);
        },
        titleTextStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w500,
            ),
        headerPadding: EdgeInsets.symmetric(horizontal: 10.w),
        leftChevronPadding: EdgeInsets.symmetric(horizontal: 16.r),
        rightChevronPadding: EdgeInsets.symmetric(horizontal: 16.r),
        headerMargin: EdgeInsets.symmetric(vertical: 10.h),
        leftChevronMargin: EdgeInsets.zero,
        rightChevronMargin: EdgeInsets.zero,
      ),

      eventLoader: (date) {
        return widget.events;
      },

      calendarBuilders: CalendarBuilders(
        ///marker builder
        markerBuilder: (context, date, events) {
          final currentDateEvents =
              events.where((event) => event.startAt.isSameDate(date)).toList();

          if (currentDateEvents.isNotEmpty) {
            if (currentDateEvents.first is NonWorkEvent) {
              return const SizedBox();
            }
            final eventsDuration =
                currentDateEvents.fold<int>(0, (previousValue, event) {
              return previousValue +
                  event.endAt.difference(event.startAt).inMinutes;
            });
            final p = eventsDuration / (32 * 30);
            return LinearProgressIndicator(
              value: p,
              color: AppColors.orange,
              minHeight: 1.h,
              backgroundColor: Colors.white,
            );
          }

          return const SizedBox();
        },

        ///headerTitleBuilder
        headerTitleBuilder: (context, day) {
          return Header(
            month: DateFormat.MMMM(context.locale.toStringWithSeparator())
                .format(day)
                .toUpperCase(),
            year: DateFormat.y(context.locale.toStringWithSeparator())
                .format(day)
                .toUpperCase(),
          );
        },

        ///default builder
        defaultBuilder: (context, currentDate, nextDate) {
          final isNonWorkDay = widget.events
              .where((event) =>
                  event.startAt.isSameDate(currentDate) &&
                  event is NonWorkEvent)
              .isNotEmpty;
          return DefaultCell(
            date: currentDate,
            nonWorkDay: isNonWorkDay,
          );
        },

        ///today builder
        todayBuilder: (context, date, focusedDay) {
          return DefaultCell(
            date: date,
            isToday: true,
          );
        },

        ///builder for days not in current month
        outsideBuilder: (
          context,
          date,
          focusedDay,
        ) {
          return DefaultCell(
            date: date,
            isInCurrentMonth: false,
          );
        },

        ///dow builder(Mn,Tu,We,Th,Fr,St,Su)
        dowBuilder: (
          context,
          day,
        ) {
          return Dow(
            dayOfWeek:
                "${DateFormat.E(context.locale.toStringWithSeparator()).format(day)[0]}${DateFormat.E(context.locale.toStringWithSeparator()).format(day)[1]}"
                    .toUpperCase(),
          );
        },
        //builder for selected days
        selectedBuilder: (
          context,
          currentDate,
          prevDate,
        ) {
          return DefaultCell(
            date: currentDate,
            isPicked: true,
            isToday: isSameDay(currentDate, Calendar.currentDay),
          );
        },
      ),

      calendarStyle: const CalendarStyle(
        isTodayHighlighted: true,
        todayDecoration: BoxDecoration(
          color: AppColors.orange,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
