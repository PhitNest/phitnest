import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/logger.dart';
import '../../../common/utils/utils.dart';
import '../interfaces/http.adapter.dart';

const _timeout = Duration(seconds: 15);

class DioHttpAdapter implements IHttpAdapter {
  FEither3<Map<String, dynamic>, List<dynamic>, Failure> request(
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
            } else if (response.data is String) {
              if (response.data.isEmpty) {
                return First(Map<String, dynamic>.from({}));
              } else {
                throw Exception("Invalid response: $response.data");
              }
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
}
