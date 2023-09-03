import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../config/aws.dart';
import '../aws/aws.dart';
import '../failure.dart';
import '../logger.dart';

part 'response.dart';

/// Default HTTP timeout
const kDefaultTimeout = Duration(seconds: 30);

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
) {
  final port = overridePort ?? _port;
  return '${overrideHost ?? _host}'
      '${port.isEmpty || port == "443" || port == "80" ? "" : ""
          ":${overridePort ?? _port}"}'
      '$route';
}

String _host = kHost;
String _port = kPort;
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
  required ResType Function(dynamic) parse,
  Map<String, dynamic>? data,
  Map<String, dynamic>? headers,
  Session? session,
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
    List<String> details(dynamic data) =>
        ['method: $method', 'url: $url', 'data: $data'];

    // Log the request details
    debug('Request${session != null ? " (Authorized)" : ""}:',
        details: details(data));

    int elapsedMs() =>
        DateTime.now().millisecondsSinceEpoch -
        startTime.millisecondsSinceEpoch;

    List<String> responseDetails(dynamic data) =>
        [...details(data), 'elapsed: ${elapsedMs()} ms'];

    // Check if the request should be read from cache
    if (readFromCache != null) {
      final cached = readFromCache();
      if (cached != null) {
        debug('Request cached:', details: [cached.toString()]);
        return HttpResponseCache(cached);
      }
    }

    // Prepare the request headers
    final headerMap = {
      ...headers ?? Map<String, dynamic>.from({}),
      ...session != null
          ? {
              'Authorization': session.cognitoSession.idToken.jwtToken,
            }
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
          .then((response) {
        final jsonData = response.data;
        if (jsonData is Map<String, dynamic> || jsonData is List<dynamic>) {
          // Handle successful responses
          if (response.statusCode == 200) {
            // Parse the response data
            final parsed = parse(jsonData);
            // Log success
            debug('Request success:', details: responseDetails(parsed));
            return HttpResponseOk(parsed, response.headers);
          } else {
            // Handle unsuccessful responses
            final parsed = Failure.parse(jsonData as Map<String, dynamic>);
            error('Request failure:', details: responseDetails(parsed));
            return HttpResponseFailure(parsed, response.headers);
          }
        } else {
          throw Failure.populated('Invalid response', jsonData.toString());
        }
      });
    } on TimeoutException {
      // Log and return a NetworkConnectionFailure on timeout
      error('Request timeout:', details: responseDetails(data));
      return HttpResponseFailure(
          Failure.populated('Timeout', 'Request timeout'), Headers());
    } on Failure catch (failure) {
      error('Request failure:', details: responseDetails(failure));
      return HttpResponseFailure(failure, Headers());
    } catch (e) {
      // Log and return failure by value
      final failure = Failure.populated('UnknownFailure', e.toString());
      error('Request failure:', details: responseDetails(failure));
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
