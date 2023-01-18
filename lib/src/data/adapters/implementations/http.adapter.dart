import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../common/constants.dart';
import '../../../common/failure.dart';
import '../../../common/logger.dart';
import '../interfaces/http.adapter.dart';

String get _backendUrl =>
    '${dotenv.get('BACKEND_HOST')}:${dotenv.get('BACKEND_PORT')}';

class DioHttpAdapter implements IHttpAdapter {
  Future<Either<Either<Map<String, dynamic>, List<dynamic>>, Failure>> request(
    HttpMethod method,
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? authorization,
  }) async {
    logger.d(
        'Request${authorization != null ? " (Authorized)" : ""}:\n\tmethod: $method\n\tpath: $path\n\tdata: $data');
    final headerMap = {
      ...headers ?? Map<String, dynamic>.from({}),
      ...authorization != null
          ? {'authorization': authorization}
          : Map<String, dynamic>.from({}),
    };
    final options = BaseOptions(
        headers: headerMap,
        validateStatus: (status) => status == 200 || status == 500);
    if (method == HttpMethod.get || method == HttpMethod.delete) {
      options.queryParameters = data ?? Map<String, dynamic>.from({});
    }
    final dio = Dio(options);
    Future<Either<dynamic, Failure>> result;
    switch (method) {
      case HttpMethod.get:
        result = dio.get('$_backendUrl$path').then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(
                      Failure.fromJson(response.data),
                    ),
            );
        break;
      case HttpMethod.post:
        result = dio.post('$_backendUrl$path', data: data).then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(
                      Failure.fromJson(response.data),
                    ),
            );
        break;
      case HttpMethod.put:
        result = dio.put('$_backendUrl$path', data: data).then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(
                      Failure.fromJson(response.data),
                    ),
            );
        break;
      case HttpMethod.delete:
        result = dio.delete('$_backendUrl$path').then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(
                      Failure.fromJson(response.data),
                    ),
            );
        break;
    }
    try {
      return await result.timeout(const Duration(seconds: 15)).then(
            (res) => res.fold(
              (success) {
                logger.d(
                    "Response success:\n\tmethod: $method\n\tpath: $path\n\tdata: $success");
                if (success is List) {
                  return Left(Right(success));
                } else {
                  return Left(Left(success));
                }
              },
              (failure) {
                logger.e(
                    "Response failure:\n\tmethod: $method\n\tpath: $path\n\tdata: $failure");
                return Right(failure);
              },
            ),
          );
    } catch (e) {
      final failure;
      if (e is DioError) {
        failure = Failure.fromJson(e.response!.data);
      } else {
        failure = Failure("NetworkError", "Failed to connect to the network.");
      }
      logger.e(
          "Response failure:\n\tmethod: $method\n\tpath: $path\n\tdata: $failure");
      return Future.value(
        Right(failure),
      );
    }
  }
}
