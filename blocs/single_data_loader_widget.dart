import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/ui/widgets/loading_widget.dart';

import 'failure_handling_bloc_listener.dart';
import 'single_data_loader_bloc.dart';

typedef SingleDataLoaderBlocWidgetBuilder<S> = Widget Function(
    BuildContext context, S state, Widget dataDisplayingWidget);

class SingleDataLoaderWidget<
    B extends SingleDataLoaderBloc<SingleDataLoaderEvent, S, T>,
    S extends SingleDataLoaderState<T>,
    T> extends StatelessWidget {
  final BlocWidgetBuilder<S> builderIfSuccess;
  final BlocWidgetBuilder<S>? builderIfFailure;
  final SingleDataLoaderBlocWidgetBuilder<S>? customBuilder;
  final BlocWidgetListener<S>? listener;
  final bool Function(S, S)? listenWhen;
  final bool useDefaultBuilderIfSuccess;

  const SingleDataLoaderWidget({
    Key? key,
    required this.builderIfSuccess,
    this.useDefaultBuilderIfSuccess = false,
    this.builderIfFailure,
    this.listener,
    this.listenWhen,
  })  : customBuilder = null,
        super(key: key);

  const SingleDataLoaderWidget.custom({
    Key? key,
    required this.customBuilder,
    required this.builderIfSuccess,
    this.useDefaultBuilderIfSuccess = false,
    this.builderIfFailure,
    this.listener,
    this.listenWhen,
  })  : assert(customBuilder != null),
        super(key: key);

  Widget dataDisplayingWidgetBuilder(context, S state) {
    if (state.status == Status.initial) {
      return const SizedBox.shrink();
    } else if (state.status == Status.loading) {
      return const LoadingWidget();
    } else if (state.status == Status.success) {
      return builderIfSuccess(context, state);
    } else if (state.status == Status.failure) {
      return builderIfFailure?.call(context, state) ??
          ConstrainedBox(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: const SingleChildScrollView(
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
            ),
          );
    }
    throw AssertionError('Unknown status');
  }

  bool buildWhen(S previous, S current) {
    if (current.status == Status.failure &&
        !(previous.status == Status.loading)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FailureHandlingBlocListener<B, S>(
      listener: listener,
      listenWhen: listenWhen,
      child: BlocBuilder<B, S>(
        buildWhen: buildWhen,
        builder: (context, S state) {
          final widget = customBuilder?.call(context, state,
                  dataDisplayingWidgetBuilder(context, state)) ??
              dataDisplayingWidgetBuilder(context, state);
          if (state.status == Status.failure ||
              state.status == Status.success) {
            return _RefreshIndicator<B, S, T>(
              child: widget,
              useDefaultBuilderIfSuccess: useDefaultBuilderIfSuccess,
            );
          }
          return widget;
        },
      ),
    );
  }
}

class _RefreshIndicator<
    B extends SingleDataLoaderBloc<SingleDataLoaderEvent, S, T>,
    S extends SingleDataLoaderState<T>,
    T> extends StatelessWidget {
  final Widget child;
  final bool useDefaultBuilderIfSuccess;

  const _RefreshIndicator({
    Key? key,
    required this.child,
    required this.useDefaultBuilderIfSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => BlocProvider.of<B>(context).add(GetSingleData()),
      child: useDefaultBuilderIfSuccess
          ? SizedBox.expand(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: child,
              ),
            )
          : child,
    );
  }
}
