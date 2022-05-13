import 'package:catchup/core/index.dart';
import 'package:catchup/data/models/index.dart';
import 'package:catchup/data/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

part 'calendar_tab_event.dart';
part 'calendar_tab_state.dart';

@injectable
class CalendarTabBloc extends SingleDataLoaderBloc<CalendarTabEvent,
    CalendarTabState, List<Event>> {
  final CalendarRepository _calendarRepository;

  CalendarTabBloc(
    this._calendarRepository,
    @factoryParam Event? newEvent,
  ) : super(CalendarTabState.initial(newEvent: newEvent));

  @override
  Stream<CalendarTabState> mapEventToState(SingleDataLoaderEvent event) async* {
    yield* super.mapEventToState(event);
    if (event is PickDate) {
      yield state.copyWith(pickedDate: event.pickedDate);
    } else if (event is OnPickedIntervals) {
      yield state.copyWith(
        isTimePicked: true,
        newEvent: state.newEvent!.copyWith(
          startAt: event.pickedIntervals.first.startAt,
          endAt: event.pickedIntervals.last.endAt,
        ),
      );
    } else if (event is OnDayLongPress) {
      final pickedDateNonWorkEvent = state.data!.where((element) =>
          element.startAt.isSameDate(event.pickedDate) &&
          element is NonWorkEvent);
      final isPickedDateNonWork = pickedDateNonWorkEvent.isNotEmpty;
      if (isPickedDateNonWork) {
        yield state.copyWith(
          data: [...?state.data]..remove(pickedDateNonWorkEvent.single),
        );
        await _calendarRepository.deleteEvent(pickedDateNonWorkEvent.single.id);
      } else {
        final nonWorkEvent =
            await _calendarRepository.createNonWorkDay(event.pickedDate);
        yield state.copyWith(
          data: [...?state.data, nonWorkEvent],
        );
      }
    }
  }

  @override
  Future<List<Event>> getDataFromRepository() async {
    return await _calendarRepository.getCalendarEvents();
  }
}
