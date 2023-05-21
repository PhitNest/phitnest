import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../failure.dart';
import '../logger.dart';

part 'response.dart';

/// Default HTTP timeout
const kDefaultTimeout = Duration(seconds: 30);

/// Default host
const kDefaultBackendHost = "http://localhost";

/// Default port
const kDefaultBackendPort = "3000";

/// Enum for supported HTTP methods
enum HttpMethod {
  get,
  post,
  put,
  delete,
}

/// Helper method to create the URL for the request
String _createUrl(
  String route,
  String? overrideHost,
  String? overridePort,
) =>
    '${overrideHost ?? _host}${(overridePort ?? _port).isEmpty ? "" : ":${overridePort ?? _port}"}$route';

String _host = kDefaultBackendHost;
String _port = kDefaultBackendPort;
Duration _timeout = kDefaultTimeout;

/// Initialize the Http instance with custom settings
void initializeHttp({String? host, String? port, Duration? timeout}) {
  _host = host ?? _host;
  _port = port ?? _port;
  _timeout = timeout ?? _timeout;
}

/// Shortcut function for making requests using the Http instance
Future<HttpResponse<ResType>> request<ResType>({
  required String route,
  required HttpMethod method,
  required ResType Function(dynamic) parser,
  Map<String, dynamic>? data,
  Map<String, dynamic>? headers,
  String? authorization,
  String? overrideHost,
  String? overridePort,
}) async {
  // Record the start time of the request for logging purposes
  final startTime = DateTime.now();

  // Generate the URL for the request
  final String url = _createUrl(route, overrideHost, overridePort);

  // Helper function for generating log descriptions
  final String Function(dynamic data) descriptionLog = (data) =>
      '\n\tmethod: $method\n\tpath: $route${StringUtils.addCharAtPosition("\n\tdata: $data", '\n\t', 100, repeat: true)}';

  // Log the request details
  prettyLogger.d(
      'Request${authorization != null ? " (Authorized)" : ""}:${descriptionLog(data)}');

  // Prepare the request headers
  final headerMap = {
    ...headers ?? Map<String, dynamic>.from({}),
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br",
    "Connection": "keep-alive",
    ...authorization != null
        ? {'Authorization': authorization}
        : Map<String, dynamic>.from({}),
  };

  // Create Dio instance with the prepared headers and options
  final options =
      BaseOptions(headers: headerMap, validateStatus: (status) => true);
  if (data != null &&
      (method == HttpMethod.get || method == HttpMethod.delete)) {
    options.queryParameters = data;
  }
  final dio = Dio(options);

  final String Function(
      String situation, dynamic data) responseLog = (situation,
          data) =>
      "Request $situation:${descriptionLog(data)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms";
  // Perform the request and handle the response
  try {
    return await switch (method) {
      HttpMethod.get => dio.get(url),
      HttpMethod.post => dio.post(url, data: data),
      HttpMethod.put => dio.put(url, data: data),
      HttpMethod.delete => dio.delete(url),
    }
        .timeout(_timeout)
        .then(
      (response) {
        // Handle successful responses
        if (response.statusCode == 200) {
          // Parse the response data
          final parsed = parser(response.data);
          // Log success
          prettyLogger.d(responseLog("success", parsed));
          return HttpResponseOk(parsed, response.headers);
        }
        // Handle unsuccessful responses
        final failure = Failure.fromJson(response.data);
        prettyLogger.e(responseLog("failure", failure));
        return HttpResponseFailure(failure, response.headers);
      },
    );
  } on TimeoutException {
    // Log and return a NetworkConnectionFailure on timeout
    prettyLogger.e(responseLog("timeout", data));
    return HttpResponseFailure(const Failure("Request timeout"), Headers());
  } catch (e) {
    // Log and return failure by value
    final failure = invalidFailure(e);
    prettyLogger.e(responseLog("failure", failure));
    return HttpResponseFailure(failure, Headers());
  }
}
