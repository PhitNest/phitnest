part of backend;

const _timeout = Duration(seconds: 15);

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

Future<Either3<Map<String, dynamic>, List<dynamic>, Failure>> _requestRaw({
  required String route,
  required HttpMethod method,
  required Map<String, dynamic> data,
  Map<String, dynamic>? headers,
  String? authorization,
}) async {
  final startTime = DateTime.now();
  final String url =
      '${dotenv.get('BACKEND_HOST')}:${dotenv.get('BACKEND_PORT')}$route';
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
      validateStatus: (status) =>
          status == kStatusOK || status == kStatusInternalServerError);
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
        if (response.statusCode == kStatusOK) {
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
    if (e is Failure) {
      prettyLogger.e(
          "Response failure:${description(e)}\n\telapsed: ${(DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)} ms");
      return Third(e);
    } else {
      prettyLogger.e(e);
      return Third(Failures.networkFailure.instance);
    }
  }
}

@override
Future<Either<ResType, Failure>> _requestJson<ResType>({
  required String route,
  required HttpMethod method,
  required ResType Function(Map<String, dynamic> json) parser,
  required Map<String, dynamic> data,
  Map<String, dynamic>? headers,
  String? authorization,
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
        (list) => Right(Failures.networkFailure.instance),
        (failure) => Right(failure),
      ),
    );

@override
Future<Either3<LeftResType, RightResType, Failure>>
    _requestEither<LeftResType, RightResType>({
  required String route,
  required HttpMethod method,
  required LeftResType Function(Map<String, dynamic> json) parserLeft,
  required RightResType Function(Map<String, dynamic> json) parserRight,
  required Map<String, dynamic> data,
  Map<String, dynamic>? headers,
  String? authorization,
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
            (list) => Third(Failures.networkFailure.instance),
            (failure) => Third(failure),
          ),
        );

@override
Future<Either<List<ResType>, Failure>> _requestList<ResType>({
  required String route,
  required HttpMethod method,
  required ResType Function(Map<String, dynamic> json) parser,
  required Map<String, dynamic> data,
  Map<String, dynamic>? headers,
  String? authorization,
}) =>
    _requestRaw(
      route: route,
      method: method,
      data: data,
      headers: headers,
      authorization: authorization,
    ).then(
      (either) => either.fold(
        (json) => Right(Failures.networkFailure.instance),
        (list) => Left(list.map((json) => parser(json)).toList()),
        (failure) => Right(failure),
      ),
    );

Future<Failure?> _request({
  required String route,
  required HttpMethod method,
  required Map<String, dynamic> data,
  Map<String, dynamic>? headers,
  String? authorization,
}) =>
    _requestJson(
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
