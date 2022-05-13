import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/features/auth/bloc/auth_bloc.dart';

import '../data/failures.dart';
import 'failure_handling_mixin.dart';
import 'state_with_failure.dart';

class FailureHandlingBlocListener<C extends FailureHandlingMixin<S>,
    S extends StateWithFailure> extends BlocListener<C, S> {
  FailureHandlingBlocListener({
    Key? key,
    BlocWidgetListener<S>? listener,
    C? cubit,
    BlocListenerCondition<S>? listenWhen,
    Widget? child,
  }) : super(
          key: key,
          child: child,
          listener: (BuildContext context, S state) {
            if (state.failure is TokenInvalidFailure) {
              BlocProvider.of<AuthBloc>(context).add(LoggedOut());
            }
            listener?.call(context, state);
          },
          bloc: cubit,
          listenWhen: listenWhen,
        );
}
