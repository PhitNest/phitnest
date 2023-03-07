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
  static const message = "Network connection failure.";

  const NetworkConnectionFailure() : super();
}

class InvalidResponseFailure {
  static const String message = "Invalid response from server.";

  const InvalidResponseFailure() : super();
}

Future<Either3<SuccessType, FailType, NetworkConnectionFailure>>
    _requestRaw<SuccessType, FailType extends Object>({
  required String route,
  required HttpMethod method,
  required Map<String, dynamic> data,
  required SuccessType Function(dynamic response) successParser,
  required FailType Function(Map<String, dynamic> json) failureParser,
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
        if (response.statusCode == 200) {
          prettyLogger.d(
              "Response success:${description(response.data)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
          return Alpha(successParser(response.data));
        } else {
          throw failureParser(response.data);
        }
      },
    );
  } catch (e) {
    prettyLogger.e(
        "Response failure:${description(e)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
    if (e is InvalidResponseFailure) {
      throw e;
    }
    return e is FailType ? Beta(e) : Gamma(const NetworkConnectionFailure());
  }
}

@override
Future<
        Either4<ResType, FailType, InvalidResponseFailure,
            NetworkConnectionFailure>>
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
}) async {
  try {
    return await _requestRaw(
      route: route,
      method: method,
      data: data,
      headers: headers,
      authorization: authorization,
      successParser: (response) {
        if (response is Map<String, dynamic>) {
          return successParser(response);
        } else {
          throw const InvalidResponseFailure();
        }
      },
      failureParser: failureParser,
    ).then(
      (either) => either.fold(
        (success) => First(success),
        (failure) => Second(failure),
        (networkFailure) => Fourth(networkFailure),
      ),
    );
  } catch (_) {
    return Third(const InvalidResponseFailure());
  }
}

@override
Future<
        Either4<List<ResType>, FailType, InvalidResponseFailure,
            NetworkConnectionFailure>>
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
}) async {
  try {
    return await _requestRaw(
      route: route,
      method: method,
      data: data,
      headers: headers,
      authorization: authorization,
      successParser: (response) => (response as List<dynamic>)
          .map((json) => successParser(json))
          .toList(),
      failureParser: failureParser,
    ).then(
      (either) => either.fold(
        (list) => First(list),
        (failure) => Second(failure),
        (networkFailure) => Fourth(networkFailure),
      ),
    );
  } catch (_) {
    return Third(const InvalidResponseFailure());
  }
}

Future<
    Either4<void, FailType, InvalidResponseFailure,
        NetworkConnectionFailure>> request<FailType extends Object>({
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
      successParser: (_) {},
      failureParser: failureParser,
      headers: headers,
      authorization: authorization,
    ).then(
      (either) => either.fold(
        (json) => First(null),
        (failure) => Second(failure),
        (invalidResponse) => Third(invalidResponse),
        (networkFailure) => Fourth(networkFailure),
      ),
    );
