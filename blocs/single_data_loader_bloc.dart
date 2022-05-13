import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/failures.dart';
import 'failure_handling_mixin.dart';
import 'state_with_failure.dart';

part 'single_data_loader_event.dart';
part 'single_data_loader_state.dart';

abstract class SingleDataLoaderBloc<
    E extends SingleDataLoaderEvent,
    S extends SingleDataLoaderState<T>,
    T> extends Bloc<SingleDataLoaderEvent, S> with FailureHandlingMixin<S> {
  SingleDataLoaderBloc(S initialState) : super(initialState);

  @mustCallSuper
  @override
  Stream<S> mapEventToState(SingleDataLoaderEvent event) async* {
    if (event is GetSingleData) {
      yield state.copyWith(status: Status.loading) as S;
      final data = await getDataFromRepository();
      yield stateToCopyWithData.copyWith(status: Status.success, data: data)
          as S;
    }
  }

  @override
  void add(SingleDataLoaderEvent event) {
    assert(
      event is BasicSingleDataLoaderEvent || event is E,
      '${event.runtimeType} event is not supposed to be added to $runtimeType bloc',
    );
    super.add(event);
  }

  @override
  S get stateToCopyWithFailure => state.copyWith(status: Status.failure) as S;

  ///Override this to provide additional fields to success state
  @protected
  S get stateToCopyWithData => state;

  @protected
  Future<T> getDataFromRepository();
}
