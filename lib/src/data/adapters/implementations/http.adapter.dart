import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../common/constants.dart';
import '../../../common/failure.dart';
import '../interfaces/http.adapter.dart';

String get _backendUrl =>
    '${dotenv.get('BACKEND_HOST')}:${dotenv.get('BACKEND_PORT')}';

class DioHttpAdapter implements IHttpAdapter {
  Future<Either<Map<String, dynamic>, Failure>> request(
    HttpMethod method,
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? authorization,
  }) async {
    final headerMap = {
      ...headers ?? Map<String, dynamic>.from({}),
      ...authorization != null
          ? {'authorization': authorization}
          : Map<String, dynamic>.from({}),
    };
    final options = BaseOptions(headers: headerMap);
    if (method == HttpMethod.get || method == HttpMethod.delete) {
      options.queryParameters = data ?? Map<String, dynamic>.from({});
    }
    final dio = Dio(options);
    switch (method) {
      case HttpMethod.get:
        return dio.get('$_backendUrl$path').then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(
                      Failure.fromJson(response.data),
                    ),
            );
      case HttpMethod.post:
        return dio.post('$_backendUrl$path', data: data).then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(
                      Failure.fromJson(response.data),
                    ),
            );
      case HttpMethod.put:
        return dio.put('$_backendUrl$path', data: data).then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(
                      Failure.fromJson(response.data),
                    ),
            );
      case HttpMethod.delete:
        return dio.delete('$_backendUrl$path').then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(
                      Failure.fromJson(response.data),
                    ),
            );
    }
  }
}
