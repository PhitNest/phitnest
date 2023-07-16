import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../failure.dart';
import '../logger.dart';

part 'response.dart';

/// Default HTTP timeout
const kDefaultTimeout = Duration(seconds: 30);

/// Default host
const kDefaultBackendHost = 'http://localhost';

/// Default port
const kDefaultBackendPort = '3000';

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
    '${overrideHost ?? _host}'
    '${(overridePort ?? _port).isEmpty ? "" : ":${overridePort ?? _port}"}'
    '$route';

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
  ResType? Function()? readFromCache,
  Future<void> Function(ResType)? writeToCache,
}) async {
  Future<HttpResponse<ResType>> requestData() async {
    // Record the start time of the request for logging purposes
    final startTime = DateTime.now();

    // Generate the URL for the request
    final String url = _createUrl(route, overrideHost, overridePort);

    // Helper function for generating log descriptions
    String descriptionLog(dynamic data) =>
        '\n\tmethod: $method${wrapText('\n\turl: $url')}'
        '${wrapText("\n\tdata: $data")}';

    // Log the request details
    prettyLogger.d('Request${authorization != null ? " (Authorized)" : ""}:'
        '${descriptionLog(data)}');

    int elapsedMs() =>
        DateTime.now().millisecondsSinceEpoch -
        startTime.millisecondsSinceEpoch;

    String responseLog(String situation, dynamic data) =>
        'Request $situation:${descriptionLog(data)}\n\telapsed: ${elapsedMs()} '
        'ms';

    // Check if the request should be read from cache
    if (readFromCache != null) {
      final cached = readFromCache();
      if (cached != null) {
        prettyLogger.d(responseLog('cached', cached));
        return HttpResponseOk(cached, Headers(), true);
      }
    }

    // Prepare the request headers
    final headerMap = {
      ...headers ?? Map<String, dynamic>.from({}),
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

    // Perform the request and handle the response
    try {
      return await switch (method) {
        HttpMethod.get => dio.get<dynamic>(url),
        HttpMethod.post => dio.post<dynamic>(url, data: data),
        HttpMethod.put => dio.put<dynamic>(url, data: data),
        HttpMethod.delete => dio.delete<dynamic>(url),
      }
          .timeout(_timeout)
          .then(
        (response) {
          // Handle successful responses
          if (response.statusCode == 200) {
            // Parse the response data
            final parsed = parser(response.data);
            // Log success
            prettyLogger.d(responseLog('success', parsed));
            return HttpResponseOk(parsed, response.headers, false);
          }
          // Handle unsuccessful responses
          final failure = Failure.fromJson(response.data);
          prettyLogger.e(responseLog('failure', failure));
          return HttpResponseFailure(failure, response.headers);
        },
      );
    } on TimeoutException {
      // Log and return a NetworkConnectionFailure on timeout
      prettyLogger.e(responseLog('timeout', data));
      return HttpResponseFailure(
          const Failure('Timeout', 'Request timeout'), Headers());
    } catch (e) {
      // Log and return failure by value
      final failure = invalidJson(e);
      prettyLogger.e(responseLog('failure', failure));
      return HttpResponseFailure(failure, Headers());
    }
  }

  final result = await requestData();
  if (writeToCache != null && result is HttpResponseOk<ResType>) {
    // Write the response to cache if the request was successful
    await writeToCache(result.data);
  }
  return result;
}
