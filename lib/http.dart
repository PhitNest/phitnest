import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:sealed_unions/sealed_unions.dart';

import 'failure.dart';
import 'logger.dart';

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

/// Custom Failure class for network connection issues
class HttpFailure extends Failure {
  final dynamic _error;

  dynamic get error => _error;

  const HttpFailure(dynamic error)
      : _error = error,
        super("Network connection failure.");
}

/// Http class for handling HTTP requests
class Http {
  final String _host;
  final String _port;
  final Duration _timeout;

  /// Constructor with optional parameters for customization
  const Http({String? host, String? port, Duration? timeout})
      : _host = host ?? kDefaultBackendHost,
        _port = port ?? kDefaultBackendPort,
        _timeout = timeout ?? kDefaultTimeout;

  /// Helper method to create the URL for the request
  String createUrl(
    String route,
    String? overrideHost,
    String? overridePort,
  ) =>
      '${overrideHost ?? _host}${(overridePort ?? _port).isEmpty ? "" : ":${overridePort ?? _port}"}$route';

  /// Asynchronous method to perform the HTTP request and handle the response
  Future<Union2<ResType, HttpFailure>> request<ResType>({
    required String route,
    required HttpMethod method,
    required ResType? Function(Response) parser,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    String? authorization,
    String? overrideHost,
    String? overridePort,
  }) async {
    // Record the start time of the request for logging purposes
    final startTime = DateTime.now();

    // Generate the URL for the request
    final String url = createUrl(route, overrideHost, overridePort);

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

    // Perform the request and handle the response
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
          // Handle successful responses
          if (ResType == Null &&
              response.data == null &&
              response.statusCode == 200) {
            prettyLogger.d(
                "Response success:${descriptionLog(null)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
            return Union2First(null as ResType);
          }
          // Parse the response data
          final parsed = parser(response);
          if (parsed != null) {
            // Log success or failure based on the parsed data
            if (parsed is Failure) {
              prettyLogger.e(
                  "Response failure:${descriptionLog(parsed)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
            } else {
              prettyLogger.d(
                  "Response success:${descriptionLog(parsed)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
            }
            return Union2First(parsed);
          } else {
            // Throw an exception if the response cannot be parsed
            throw response.data;
          }
        },
      );
    } catch (e) {
      // Log and return a NetworkConnectionFailure on request failure
      prettyLogger.e(
          "Request failure:${descriptionLog(e)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
      return Union2Second(HttpFailure(e));
    }
  }
}

// Initialize a default Http instance
Http instance = Http();

/// Initialize the Http instance with custom settings
void initializeHttp({String? host, String? port, Duration? timeout}) {
  instance = Http(host: host, port: port, timeout: timeout);
}

/// Shortcut function for making requests using the Http instance
Future<Union2<ResType, HttpFailure>> Function<ResType>({
  required String route,
  required HttpMethod method,
  required ResType? Function(Response) parser,
  Map<String, dynamic>? data,
  Map<String, dynamic>? headers,
  String? authorization,
  String? overrideHost,
  String? overridePort,
}) request = instance.request;
