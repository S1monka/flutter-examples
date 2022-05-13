import 'single_data_loader_bloc.dart';

abstract class SimpleDataLoaderBloc<T> extends SingleDataLoaderBloc<
    SingleDataLoaderEvent, SingleDataLoaderState<T>, T> {
  SimpleDataLoaderBloc() : super(SingleDataLoaderState<T>.initial());
}
