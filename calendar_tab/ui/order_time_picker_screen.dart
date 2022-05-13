import 'package:catchup/app/theme_config.dart';
import 'package:catchup/data/models/calendar/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:catchup/core/index.dart';
import 'package:catchup/features/calendar_tab/bloc/calendar_tab_bloc.dart';
import 'package:catchup/features/calendar_tab/ui/widgets/timeline/timeline_widget.dart';

class OrderTimePickerScreen extends StatefulWidget {
  static const routeName = '/orderTimePickerScreen';

  final CalendarTabBloc calendarTabBloc;

  OrderTimePickerScreen({
    Key? key,
    required this.calendarTabBloc,
  }) : super(key: key);

  @override
  State<OrderTimePickerScreen> createState() => _OrderTimePickerScreenState();
}

class _OrderTimePickerScreenState extends State<OrderTimePickerScreen> {
  List<EmptyEvent> pickedIntervals = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'orderTime',
      ),
      floatingActionButton: pickedIntervals.isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.done,
                color: AppColors.orange,
              ),
              onPressed: () {
                widget.calendarTabBloc.add(OnPickedIntervals(pickedIntervals));
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<CalendarTabBloc, CalendarTabState>(
            listener: (context, state) {
              Navigator.of(context).pop();
            },
            listenWhen: (prev, current) => prev.newEvent != current.newEvent,
            bloc: widget.calendarTabBloc,
            builder: (context, state) {
              return TimelineWidget(
                scrollController: ScrollController(),
                pickedDate: state.pickedDate,
                events: state.currentDateEvents,
                useIntervals: true,
                onPickedIntervals: (picked) {
                  setState(() {
                    pickedIntervals = picked;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
