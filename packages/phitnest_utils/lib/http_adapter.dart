import 'package:basic_utils/basic_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'either3.dart';
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

const kNetworkConnectionFailure = Failure("NetworkConnectionFailure",
    "Could not connect to the server. Please check your internet connection.");

Future<Either3<Map<String, dynamic>, List<dynamic>, Failure>> _requestRaw({
  required String route,
  required HttpMethod method,
  required Map<String, dynamic> data,
  Map<String, dynamic>? headers,
  String? authorization,
  String? overrideHost,
  String? overridePort,
}) async {
  final startTime = DateTime.now();
  final String url = '$_backendHost:$_backendPort$route';
  final String Function(dynamic data) description = (data) =>
      '\n\tmethod: $method\n\tpath: $route${StringUtils.addCharAtPosition("\n\tdata: $data", '\n\t', 100, repeat: true)}';
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
      validateStatus: (status) => status == 200 || status == 500);
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
          throw Failure.fromJson(response.data);
        }
      },
    );
  } catch (e) {
    prettyLogger.e(
        "Response failure:${description(e)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
    return e is Failure ? Third(e) : Third(kNetworkConnectionFailure);
  }
}

@override
Future<Either<ResType, Failure>> requestJson<ResType>({
  required String route,
  required HttpMethod method,
  required ResType Function(Map<String, dynamic> json) parser,
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
    ).then(
      (either) => either.fold(
        (json) => Left(parser(json)),
        (list) => Right(kNetworkConnectionFailure),
        (failure) => Right(failure),
      ),
    );

@override
Future<Either3<LeftResType, RightResType, Failure>>
    requestEither<LeftResType, RightResType>({
  required String route,
  required HttpMethod method,
  required LeftResType Function(Map<String, dynamic> json) parserLeft,
  required RightResType Function(Map<String, dynamic> json) parserRight,
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
        ).then(
          (either) => either.fold(
            (json) {
              try {
                return First(parserLeft(json));
              } catch (_) {
                return Second(parserRight(json));
              }
            },
            (list) => Third(kNetworkConnectionFailure),
            (failure) => Third(failure),
          ),
        );

@override
Future<Either<List<ResType>, Failure>> requestList<ResType>({
  required String route,
  required HttpMethod method,
  required ResType Function(Map<String, dynamic> json) parser,
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
    ).then(
      (either) => either.fold(
        (json) => Right(kNetworkConnectionFailure),
        (list) => Left(list.map((json) => parser(json)).toList()),
        (failure) => Right(failure),
      ),
    );

Future<Failure?> request({
  required String route,
  required HttpMethod method,
  required Map<String, dynamic> data,
  Map<String, dynamic>? headers,
  String? authorization,
  String? overrideHost,
  String? overridePort,
}) =>
    requestJson(
      route: route,
      method: method,
      data: data,
      parser: (json) {},
      headers: headers,
      authorization: authorization,
    ).then(
      (either) => either.fold(
        (json) => null,
        (failure) => failure,
      ),
    );
