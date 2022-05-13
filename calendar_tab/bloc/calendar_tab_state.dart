part of 'calendar_tab_bloc.dart';

class CalendarTabState extends SingleDataLoaderState<List<Event>> {
  final DateTime pickedDate;
  final Event? newEvent;
  final bool isTimePicked;
  CalendarTabState(
    Failure? failure,
    Status status,
    List<Event>? data,
    this.pickedDate,
    this.newEvent,
    this.isTimePicked,
  ) : super(
          failure,
          status,
          data,
        );

  CalendarTabState.initial({this.newEvent})
      : pickedDate = DateTime.now(),
        isTimePicked = false,
        super.initial();

  List<Event> get currentDateEvents =>
      data!.where((event) => event.startAt.isSameDate(pickedDate)).toList();

  @override
  List<Object?> get props => [
        ...super.props,
        pickedDate,
        newEvent,
        isTimePicked,
      ];

  @override
  CalendarTabState copyWith({
    Status? status,
    List<Event>? data,
    Failure? failure,
    DateTime? pickedDate,
    Event? newEvent,
    bool? isTimePicked,
  }) {
    return CalendarTabState(
      failure ?? this.failure,
      status ?? this.status,
      data ?? this.data,
      pickedDate ?? this.pickedDate,
      newEvent ?? this.newEvent,
      isTimePicked ?? this.isTimePicked,
    );
  }
}
