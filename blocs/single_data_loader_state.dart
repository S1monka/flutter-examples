part of 'single_data_loader_bloc.dart';

class SingleDataLoaderState<T> extends StateWithFailure {
  final Status status;
  final T? data;

  @protected
  const SingleDataLoaderState(Failure? failure, this.status, this.data)
      : super(failure);

  const SingleDataLoaderState.initial()
      : status = Status.initial,
        data = null,
        super.initial();

  const SingleDataLoaderState.success(this.data)
      : status = Status.success,
        super(null);

  const SingleDataLoaderState.loading()
      : status = Status.loading,
        data = null,
        super(null);

  const SingleDataLoaderState.failure(Failure failure)
      : status = Status.failure,
        data = null,
        super(failure);

  @override
  SingleDataLoaderState<T> copyWith(
      {Status? status, T? data, Failure? failure}) {
    return SingleDataLoaderState(
      failure ?? this.failure,
      status ?? this.status,
      data ?? this.data,
    );
  }

  @override
  List<Object?> get props => super.props.followedBy([status, data]).toList();
}

enum Status { initial, loading, success, failure }
