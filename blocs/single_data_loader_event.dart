part of 'single_data_loader_bloc.dart';

abstract class SingleDataLoaderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

abstract class BasicSingleDataLoaderEvent extends SingleDataLoaderEvent {}

class GetSingleData extends BasicSingleDataLoaderEvent {}
