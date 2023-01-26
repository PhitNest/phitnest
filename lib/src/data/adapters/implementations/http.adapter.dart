import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/logger.dart';
import '../interfaces/http.adapter.dart';

const _timeout = Duration(seconds: 15);

class DioHttpAdapter implements IHttpAdapter {
  Future<Either<Either<Map<String, dynamic>, List<dynamic>>, Failure>> request(
    Route route, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? authorization,
  }) async {
    final String url =
        '${dotenv.get('BACKEND_HOST')}:${dotenv.get('BACKEND_PORT')}${route.path}';
    final String Function(dynamic data) description = (data) =>
        '\n\tmethod: ${route.method}\n\tpath: ${route.path}\n\tdata: $data';
    prettyLogger.d(
        'Request${authorization != null ? " (Authorized)" : ""}:${description(data)}');
    final headerMap = {
      ...headers ?? Map<String, dynamic>.from({}),
      ...authorization != null
          ? {'authorization': authorization}
          : Map<String, dynamic>.from({}),
    };
    final options = BaseOptions(
        headers: headerMap,
        validateStatus: (status) =>
            status == kStatusOK || status == kStatusInternalServerError);
    if (route.method == HttpMethod.get || route.method == HttpMethod.delete) {
      options.queryParameters = data ?? Map<String, dynamic>.from({});
    }
    final dio = Dio(options);
    Future<Either<dynamic, Failure>> result;
    switch (route.method) {
      case HttpMethod.get:
        result = dio.get(url).then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(Failure.fromJson(response.data)),
            );
        break;
      case HttpMethod.post:
        result = dio.post(url, data: data).then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(Failure.fromJson(response.data)),
            );
        break;
      case HttpMethod.put:
        result = dio.put(url, data: data).then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(Failure.fromJson(response.data)),
            );
        break;
      case HttpMethod.delete:
        result = dio.delete(url).then(
              (response) => response.statusCode == kStatusOK
                  ? Left(response.data)
                  : Right(Failure.fromJson(response.data)),
            );
        break;
    }
    try {
      return await result.timeout(_timeout).then(
            (res) => res.fold(
              (success) {
                prettyLogger.d("Response success:${description(success)}");
                if (success is List) {
                  return Left(Right(success));
                } else if (success is String) {
                  if (success.isEmpty) {
                    return Left(Left(Map<String, dynamic>.from({})));
                  } else {
                    throw Exception("Invalid response: $success");
                  }
                } else {
                  return Left(Left(success));
                }
              },
              (failure) {
                prettyLogger.e("Response failure:${description(failure)}");
                return Right(failure);
              },
            ),
          );
    } catch (e) {
      final Failure failure;
      print(e);
      if (e is DioError) {
        failure = Failure.fromJson(e.response!.data);
      } else {
        failure = Failures.networkFailure.instance;
      }
      prettyLogger.e("Response failure:${description(failure)}");
      return Right(failure);
    }
  }
}
