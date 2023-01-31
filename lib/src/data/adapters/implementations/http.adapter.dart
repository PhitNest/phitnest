import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as env;

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/logger.dart';
import '../../../common/utils/utils.dart';
import '../../data_sources/backend/routes/routes.dart';
import '../interfaces/http.adapter.dart';

const _timeout = Duration(seconds: 15);

class DioHttpAdapter implements IHttpAdapter {
  FEither3<Map<String, dynamic>, List<dynamic>, Failure>
      _request<ReqType extends Writeable>(
    Route<ReqType, dynamic> route,
    ReqType data, {
    Map<String, dynamic>? headers,
    String? authorization,
  }) async {
    final String url =
        '${env.dotenv.get('BACKEND_HOST')}:${env.dotenv.get('BACKEND_PORT')}${route.path}';
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
      options.queryParameters = data.toJson();
    }
    final dio = Dio(options);
    try {
      return await () async {
        switch (route.method) {
          case HttpMethod.get:
            return dio.get(url);
          case HttpMethod.post:
            return dio.post(url, data: data);
          case HttpMethod.put:
            return dio.put(url, data: data);
          case HttpMethod.delete:
            return dio.delete(url);
        }
      }()
          .timeout(_timeout)
          .then(
        (response) {
          if (response.statusCode == kStatusOK) {
            prettyLogger.d("Response success:${description(response.data)}");
            if (response.data is List) {
              return Second(response.data);
            } else {
              return First(response.data);
            }
          } else {
            throw Failure.fromJson(response.data);
          }
        },
      );
    } catch (e) {
      final failure = e is Failure ? e : Failures.networkFailure.instance;
      prettyLogger.e("Response failure:${description(failure)}");
      return Third(failure);
    }
  }

  @override
  FEither<ResType, Failure> request<ResType, ReqType extends Writeable>(
    Route<ReqType, ResType> route,
    ReqType data, {
    Map<String, dynamic>? headers,
    String? authorization,
  }) =>
      _request(route, data, headers: headers, authorization: authorization)
          .then(
        (either) => either.fold(
          (json) => Left(route.parser.fromJson(json)),
          (list) => Right(Failures.networkFailure.instance),
          (failure) => Right(failure),
        ),
      );

  @override
  FEither<List<ResType>, Failure>
      requestList<ResType, ReqType extends Writeable>(
    Route<ReqType, ResType> route,
    ReqType data, {
    Map<String, dynamic>? headers,
    String? authorization,
  }) =>
          _request(route, data, headers: headers, authorization: authorization)
              .then(
            (either) => either.fold(
              (res) => Right(Failures.networkFailure.instance),
              (list) => Left(route.parser.fromList(list)),
              (failure) => Right(failure),
            ),
          );

  Future<Failure?> requestVoid<ReqType extends Writeable>(
    Route<ReqType, void> route,
    ReqType data, {
    Map<String, dynamic>? headers,
    String? authorization,
  }) =>
      request(route, data, headers: headers, authorization: authorization).then(
        (either) => either.fold(
          (_) => null,
          (failure) => failure,
        ),
      );
}
