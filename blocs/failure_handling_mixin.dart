import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/failures.dart';
import 'state_with_failure.dart';

mixin FailureHandlingMixin<S extends StateWithFailure> on BlocBase<S> {
  @override
  void onError(Object error, StackTrace stackTrace) {
    emit(stateToCopyWithFailure.copyWith(
        failure: (error is Failure) ? error : const UnknownFailure()) as S);
    super.onError(error, stackTrace);
  }

  @protected
  S get stateToCopyWithFailure => state;
}
