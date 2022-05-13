import 'package:equatable/equatable.dart';

import '../data/failures.dart';

class StateWithFailure extends Equatable {
  final Failure? failure;

  const StateWithFailure(this.failure);

  const StateWithFailure.initial() : failure = null;

  StateWithFailure copyWith({Failure? failure}) {
    return StateWithFailure(failure ?? this.failure);
  }

  @override
  List<Object?> get props => [failure];
}
