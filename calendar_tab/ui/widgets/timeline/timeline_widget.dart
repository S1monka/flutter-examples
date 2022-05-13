import 'package:catchup/core/index.dart';
import 'package:catchup/features/calendar_tab/ui/widgets/timeline/empty_event_widget.dart';
import 'package:catchup/features/calendar_tab/ui/widgets/timeline/timeline_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timelines/timelines.dart';

import 'package:catchup/app/theme_config.dart';
import 'package:catchup/data/models/index.dart';

class TimelineWidget extends StatefulWidget {
  final ScrollController scrollController;
  final DateTime pickedDate;
  final List<Event> events;
  final Function(DateTime changedDate)? onDateChanged;
  final bool useIntervals;

  final Function(List<EmptyEvent> pickedIntervals)? onPickedIntervals;

  const TimelineWidget({
    Key? key,
    required this.scrollController,
    required this.pickedDate,
    required this.events,
    this.onDateChanged,
    this.useIntervals = false,
    this.onPickedIntervals,
  }) : super(key: key);

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  List<EmptyEvent> pickedIntervals = [];

  List<EmptyEvent> get _dayIntervals {
    final intervals = <EmptyEvent>[];
    for (var i = 0; i <= 31; i++) {
      final startAt = DateTime(widget.pickedDate.year, widget.pickedDate.month,
              widget.pickedDate.day, 8)
          .add(
        Duration(minutes: i * 30),
      );
      final endAt = startAt.add(const Duration(minutes: 30));
      intervals.add(EmptyEvent(startAt: startAt, endAt: endAt));
    }
    return intervals;
  }

  @override
  Widget build(BuildContext context) {
    final timelineIntervales = <EmptyEvent>[];
    if (widget.useIntervals) {
      timelineIntervales.addAll(_dayIntervals);
      for (var event in widget.events) {
        for (var interval in _dayIntervals) {
          if (interval.startAt.hour == event.startAt.hour &&
              interval.startAt.minute == event.startAt.minute) {
            final intervalIndex = timelineIntervales.indexOf(interval);
            timelineIntervales
              ..removeAt(intervalIndex)
              ..insert(intervalIndex, event);
          } else if (interval.startAt.isBefore(event.endAt) &&
              interval.startAt.isAfter(event.startAt)) {
            timelineIntervales.remove(interval);
          }
        }
      }
    } else {
      timelineIntervales.addAll(widget.events);
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimelineHeader(
            pickedDate: widget.pickedDate,
            onDateChanged: widget.onDateChanged,
          ),
          SizedBox(height: 15.h),
          ListView.builder(
            shrinkWrap: true,
            controller: widget.scrollController,
            itemBuilder: (context, index) {
              final event = timelineIntervales[index];
              if (event is NonWorkEvent) {
                return const SizedBox();
              }
              final isEvent = event is Event;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30.h,
                        width: 11.r,
                        child: const Center(
                          child: SolidLineConnector(
                            color: AppColors.grey20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DotIndicator(
                        size: 11.r,
                        color: isEvent ? Colors.black : Colors.white,
                        border: isEvent
                            ? null
                            : Border.all(color: AppColors.grey50),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      if (isEvent)
                        Text(
                          (event as Event).title,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        )
                      else
                        EmptyEventWidget(
                          event: event,
                          isPicked: pickedIntervals.contains(event),
                          onTap: (EmptyEvent interval) {
                            if (pickedIntervals.contains(interval)) {
                              final removeIndex =
                                  pickedIntervals.indexOf(interval);

                              if (pickedIntervals.isEmpty ||
                                  removeIndex == 0 ||
                                  removeIndex == pickedIntervals.length - 1) {
                                pickedIntervals.remove(interval);
                              } else {
                                pickedIntervals.removeRange(
                                  removeIndex + 1,
                                  pickedIntervals.length,
                                );
                              }
                            } else {
                              pickedIntervals.add(interval);
                              pickedIntervals.sort(
                                  (a, b) => a.startAt.compareTo(b.startAt));
                              if (pickedIntervals.length > 1) {
                                final iterableIntervals =
                                    timelineIntervales.where((interval) =>
                                        interval.startAt.isAfter(
                                            pickedIntervals.first.startAt));
                                for (var timeInterval in iterableIntervals) {
                                  if (timeInterval is Event) {
                                    pickedIntervals.remove(interval);
                                    break;
                                  }
                                  final isAfter = timeInterval.startAt
                                      .isAfter(pickedIntervals.first.startAt);
                                  final isBefore = timeInterval.startAt
                                      .isBefore(pickedIntervals.last.startAt);

                                  if (isAfter &&
                                      isBefore &&
                                      !pickedIntervals.contains(timeInterval)) {
                                    pickedIntervals.insert(
                                      pickedIntervals.length ~/ 2,
                                      timeInterval,
                                    );
                                  }
                                  if (!isBefore) {
                                    break;
                                  }
                                }
                              }
                            }
                            setState(() {
                              pickedIntervals.sort(
                                  (a, b) => a.startAt.compareTo(b.startAt));
                            });
                            if (widget.onPickedIntervals != null) {
                              widget.onPickedIntervals!(pickedIntervals);
                            }
                          },
                        ),
                    ],
                  ),
                  if (isEvent)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.Hm(
                                      context.locale.toStringWithSeparator())
                                  .format(event.startAt),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              DateFormat.Hm(
                                      context.locale.toStringWithSeparator())
                                  .format(event.endAt),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                        SizedBox(width: 10.w),
                        Flexible(
                          child: UserListTile(
                            user: (event as Event).order.client,
                            dense: true,
                            onTap: () {
                              UserListTile.onTilePressed(
                                context,
                                (event).order.client.id,
                                const ClientType(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10.h),
                ],
              );
            },
            itemCount: timelineIntervales.length,
          ),
        ],
      ),
    );
  }
}
