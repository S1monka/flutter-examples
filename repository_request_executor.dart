import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/data/failures.dart';
import '../api/api_provider.dart';
import '../api/api_service.dart';

@injectable
class RepositoryRequestExecutor {
  final ApiServiceProvider _apiServiceProvider;

  RepositoryRequestExecutor(this._apiServiceProvider);

  Future<T> execute<T>(Future<T> Function(ApiService apiService) getFromRemote,
      {bool useToken = true}) async {
    const debug = false;
    try {
      final dataFromRemote = await getFromRemote(
        _apiServiceProvider.getApiService(useToken: useToken),
      );
      // ignore: avoid_print
      if (debug) print('Obtained $T successfully from remote source');
      return dataFromRemote;
    } on DioError catch (e) {
      if (e.error is SocketException ||
          e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw const ConnectionFailure();
      }
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          throw const TokenInvalidFailure();
        }
        if (e.response!.statusCode == 422) {
          final errors = e.response!.data['errors'];
          if (errors is Map) {
            final errorsText =
                errors.entries.map((error) => error.value.first).join('\n');
            if (errorsText.isNotEmpty) throw Failure(errorsText);
          } else if (errors is List) {
            if (errors.isNotEmpty) throw Failure(errors.first);
          }
        }

        if (e.response!.statusCode == 500) {
          final response = e.response!.data;
          if (response is String) {
            if (response.contains('Route [login] not defined')) {
              throw const TokenInvalidFailure();
            }
          }
        }

        if (e.response!.statusCode == 400) {
          final message = e.response!.data['message'];
          if (message == DeliveryNotSupported.infoMessage) {
            throw const DeliveryNotSupported();
          }
          throw Failure(message);
        }

        throw ServerFailure(e.response!.statusCode as int);
      }
      throw const UnknownFailure();
    }
  }
}
