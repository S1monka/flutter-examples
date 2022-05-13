import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/blocs/simple_data_loader_bloc.dart';
import 'package:food_app/core/blocs/single_data_loader_bloc.dart';
import 'package:food_app/core/blocs/single_data_loader_widget.dart';

class SimpleDataLoaderWidget<B extends SimpleDataLoaderBloc<T>, T>
    extends SingleDataLoaderWidget<B, SingleDataLoaderState<T>, T> {
  const SimpleDataLoaderWidget({
    Key? key,
    required BlocWidgetBuilder<SingleDataLoaderState<T>> builderIfSuccess,
    BlocWidgetBuilder<SingleDataLoaderState<T>>? builderIfFailure,
    BlocWidgetListener<SingleDataLoaderState<T>>? listener,
    bool useDefaultBuilderIfSuccess = false,
  }) : super(
          key: key,
          builderIfSuccess: builderIfSuccess,
          builderIfFailure: builderIfFailure,
          listener: listener,
          useDefaultBuilderIfSuccess: useDefaultBuilderIfSuccess,
        );

  const SimpleDataLoaderWidget.custom({
    Key? key,
    required BlocWidgetBuilder<SingleDataLoaderState<T>> builderIfSuccess,
    BlocWidgetBuilder<SingleDataLoaderState<T>>? builderIfFailure,
    SingleDataLoaderBlocWidgetBuilder<SingleDataLoaderState<T>>? customBuilder,
    BlocWidgetListener<SingleDataLoaderState<T>>? listener,
    bool useDefaultBuilderIfSuccess = false,
  }) : super.custom(
          key: key,
          builderIfSuccess: builderIfSuccess,
          builderIfFailure: builderIfFailure,
          customBuilder: customBuilder,
          listener: listener,
          useDefaultBuilderIfSuccess: useDefaultBuilderIfSuccess,
        );
}
