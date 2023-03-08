import 'package:basic_utils/basic_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'failure.dart';
import 'logger.dart';

const _timeout = Duration(seconds: 30);

String _backendHost = "http://localhost";
String _backendPort = "3000";

void initializeHttpAdapter(String host, String port) {
  _backendHost = host;
  _backendPort = port;
}

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class NetworkConnectionFailure extends Failure {
  const NetworkConnectionFailure() : super("Network connection failure.");
}

Future<Either<ResType, NetworkConnectionFailure>> request<ResType>({
  required String route,
  required HttpMethod method,
  required Map<String, dynamic> data,
  required ResType? Function(Response) parser,
  Map<String, dynamic>? headers,
  String? authorization,
  String? overrideHost,
  String? overridePort,
}) async {
  final startTime = DateTime.now();
  final String url =
      '${overrideHost ?? _backendHost}${(overridePort ?? _backendPort).isEmpty ? "" : ":${overridePort ?? _backendPort}"}$route';
  final String Function(dynamic data) description = (data) =>
      '\n\tmethod: $method\n\tpath: $route${StringUtils.addCharAtPosition("\n\tdata: $data", '\n\t', 100, repeat: true)}';
  prettyLogger.d(
      'Request${authorization != null ? " (Authorized)" : ""}:${description(data)}');
  final headerMap = {
    ...headers ?? Map<String, dynamic>.from({}),
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br",
    "Connection": "keep-alive",
    ...authorization != null
        ? {'Authorization': authorization}
        : Map<String, dynamic>.from({}),
  };
  final options =
      BaseOptions(headers: headerMap, validateStatus: (status) => true);
  if (method == HttpMethod.get || method == HttpMethod.delete) {
    options.queryParameters = data;
  }
  final dio = Dio(options);
  try {
    return await () async {
      switch (method) {
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
        if (ResType == Null &&
            response.data == null &&
            response.statusCode == 200) {
          prettyLogger.d(
              "Response success:${description(null)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
          return Left(null as ResType);
        }
        final parsed = parser(response);
        if (parsed != null) {
          if (parsed is Failure) {
            prettyLogger.e(
                "Response failure:${description(parsed)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
          } else {
            prettyLogger.d(
                "Response success:${description(parsed)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
          }
          return Left(parsed);
        } else {
          throw response.data;
        }
      },
    );
  } catch (e) {
    prettyLogger.e(
        "Request failure:${description(e)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
    return Right(const NetworkConnectionFailure());
  }
}
