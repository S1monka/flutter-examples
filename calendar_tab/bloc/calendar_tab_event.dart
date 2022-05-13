part of 'calendar_tab_bloc.dart';

abstract class CalendarTabEvent extends SingleDataLoaderEvent {}

class PickDate extends CalendarTabEvent {
  final DateTime pickedDate;

  PickDate(this.pickedDate);
}

class OnPickedIntervals extends CalendarTabEvent {
  final List<EmptyEvent> pickedIntervals;

  OnPickedIntervals(this.pickedIntervals);
}

class OnDayLongPress extends CalendarTabEvent {
  final DateTime pickedDate;

  OnDayLongPress(this.pickedDate);
}
