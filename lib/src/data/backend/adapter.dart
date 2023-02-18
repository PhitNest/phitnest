part of backend;

const _timeout = Duration(seconds: 15);

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class SocketConnection extends Equatable {
  final IO.Socket _socket;
  final Stream<void> onDisconnect;

  const SocketConnection._(this._socket, this.onDisconnect) : super();

  Future<Either<Stream<T>, Failure>> stream<T>(SocketEvent event) async {
    final streamController = StreamController<T>();
    prettyLogger.d('Opening stream for event: $event.name');
    final handler = (data) {
      prettyLogger.d("Received event: ${event.name}\n\tData: $data");
      streamController.add(data);
    };
    final disconnectHandler = (_) async {
      prettyLogger.d('Closing event stream : ${event.name}');
      await streamController.close();
    };
    _socket
      ..on(event.name, handler)
      ..onDisconnect(disconnectHandler);
    streamController.onCancel = () async {
      prettyLogger.d("Closing event stream: $event");
      if (_socket.connected) {
        _socket
          ..off(event.name, handler)
          ..off('disconnect', disconnectHandler);
      }
      await streamController.close();
    };
    return Left(streamController.stream);
  }

  Future<Either<dynamic, Failure>> emit(
    SocketEvent event,
    dynamic data,
  ) async {
    try {
      prettyLogger.d('Emitting event: $event\n\tData: $data');
      _socket.emit(event.name, data);
      final success = Completer<Either<dynamic, Failure>>();
      final error = Completer<Either<dynamic, Failure>>();
      _socket.once(
        SocketEvent.success.name,
        (data) {
          prettyLogger
              .d("Successfully emitted event: $event\n\tReturned data: $data");
          success.complete(Left(data));
        },
      );
      _socket.once(
        SocketEvent.error.name,
        (err) {
          prettyLogger.e("Failed to emit event: $event\n\tError: $err");
          error.complete(Right(Failure.fromJson(err)));
        },
      );
      return Left(
          await Future.any([success.future, error.future]).timeout(_timeout));
    } catch (err) {
      prettyLogger.e("Failed to emit event: $event\n\tError: $err");
      return Right(Failures.networkFailure.instance);
    }
  }

  @override
  List<Object> get props => [_socket.connected];
}

@override
Future<Either<SocketConnection, Failure>> connectSocket(
    String authorization) async {
  try {
    prettyLogger.d("Connecting to the websocket server...");
    final completer = Completer<SocketConnection>();
    final streamController = StreamController<void>();
    final IO.Socket _socket = IO.io(
      '${dotenv.get('BACKEND_HOST')}:${dotenv.get('BACKEND_PORT')}',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'token': authorization})
          .build(),
    )..connect();
    _socket
      ..onConnect((_) {
        prettyLogger.d("Connected to the websocket server.");
        completer.complete(
          SocketConnection._(
            _socket,
            streamController.stream.asBroadcastStream(),
          ),
        );
        return Left(_socket);
      })
      ..onDisconnect(
        (_) {
          prettyLogger.d("Disconnected from the websocket server.");
          streamController.add(null);
          streamController.close();
        },
      );
    return Left(await completer.future.timeout(_timeout));
  } catch (err) {
    prettyLogger.e("Failed to connect to the websocket: $err");
    return Right(Failures.networkFailure.instance);
  }
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
