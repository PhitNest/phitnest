import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';

import 'either3.dart';
import 'either4.dart';
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

class NetworkConnectionFailure {
  static const String message = "Network connection failed. Please try again.";

  const NetworkConnectionFailure() : super();
}

Future<
    Either4<Map<String, dynamic>, List<dynamic>, FailType,
        NetworkConnectionFailure>> _requestRaw<FailType extends Object>({
  required String route,
  required HttpMethod method,
  required Map<String, dynamic> data,
  required FailType Function(Map<String, dynamic> json) failureParser,
  Map<String, dynamic>? headers,
  String? authorization,
  String? overrideHost,
  String? overridePort,
}) async {
  final startTime = DateTime.now();
  final String url =
      '$_backendHost${_backendPort.isEmpty ? "" : ":$_backendPort"}$route';
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
        if (response.statusCode == 200) {
          prettyLogger.d(
              "Response success:${description(response.data)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
          if (response.data is List) {
            return Second(response.data);
          } else if (response.data is Map<String, dynamic>) {
            return First(response.data);
          } else {
            return First(Map<String, dynamic>.from({}));
          }
        } else {
          throw failureParser(response.data);
        }
      },
    );
  } catch (e) {
    prettyLogger.e(
        "Response failure:${description(e)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
    return e is FailType ? Third(e) : Fourth(const NetworkConnectionFailure());
  }
}

@override
Future<Either3<ResType, FailType, NetworkConnectionFailure>>
    requestJson<ResType, FailType extends Object>({
  required String route,
  required HttpMethod method,
  required ResType Function(Map<String, dynamic> json) successParser,
  required FailType Function(Map<String, dynamic> json) failureParser,
  required Map<String, dynamic> data,
  Map<String, dynamic>? headers,
  String? authorization,
  String? overrideHost,
  String? overridePort,
}) =>
        _requestRaw(
          route: route,
          method: method,
          data: data,
          headers: headers,
          authorization: authorization,
          failureParser: failureParser,
        ).then(
          (either) => either.fold(
            (success) => Alpha(successParser(success)),
            (list) => Gamma(const NetworkConnectionFailure()),
            (failure) => Beta(failure),
            (networkFailure) => Gamma(networkFailure),
          ),
        );

@override
Future<Either3<List<ResType>, FailType, NetworkConnectionFailure>>
    requestList<ResType, FailType extends Object>({
  required String route,
  required HttpMethod method,
  required ResType Function(Map<String, dynamic> json) successParser,
  required FailType Function(Map<String, dynamic> json) failureParser,
  required Map<String, dynamic> data,
  Map<String, dynamic>? headers,
  String? authorization,
  String? overrideHost,
  String? overridePort,
}) =>
        _requestRaw(
          route: route,
          method: method,
          data: data,
          headers: headers,
          authorization: authorization,
          failureParser: failureParser,
        ).then(
          (either) => either.fold(
            (json) => Gamma(const NetworkConnectionFailure()),
            (list) => Alpha(list.map((json) => successParser(json)).toList()),
            (failure) => Beta(failure),
            (networkFailure) => Gamma(networkFailure),
          ),
        );

Future<Either3<void, FailType, NetworkConnectionFailure>>
    request<FailType extends Object>({
  required String route,
  required HttpMethod method,
  required Map<String, dynamic> data,
  required FailType Function(Map<String, dynamic> json) failureParser,
  Map<String, dynamic>? headers,
  String? authorization,
  String? overrideHost,
  String? overridePort,
}) =>
        requestJson(
          route: route,
          method: method,
          data: data,
          successParser: (json) {},
          failureParser: failureParser,
          headers: headers,
          authorization: authorization,
        ).then(
          (either) => either.fold(
            (json) => Alpha(null),
            (failure) => Beta(failure),
            (networkFailure) => Gamma(networkFailure),
          ),
        );
