import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';
import '../services.dart';

class EventService implements IEventService {
  IO.Socket? _socket;

  @override
  bool get connected => _socket != null && _socket!.connected;

  @override
  Future<void> connect(String accessToken) async {
    _socket = IO.io(
      '${environmentService.backendHost}:${environmentService.backendPort}',
      {
        "extraHeaders": {
          "token": "Bearer $accessToken",
        },
      },
    );
    final completer = Completer();
    _socket!.onConnect(
      (_) => completer.complete(),
    );
    _socket!.onDisconnect(
      (_) => _socket = null,
    );
    return completer.future;
  }

  @override
  void disconnect() async {
    if (connected) {
      _socket!.disconnect();
    }
  }

  @override
  Either<Stream<dynamic>, Failure> stream(String event) {
    if (connected) {
      final streamController = StreamController<dynamic>();
      final handler = (data) => streamController.add(data);
      final disconnectHandler = (_) => streamController.close();
      _socket!.on(
        event,
        handler,
      );
      _socket!.onDisconnect(
        disconnectHandler,
      );
      streamController.onCancel = () {
        if (connected) {
          _socket!.off(
            event,
            handler,
          );
          _socket!.off(
            'disconnect',
            disconnectHandler,
          );
        }
        streamController.close();
      };
      return Left(streamController.stream);
    } else {
      return Right(
        Failure("Not connected to the server."),
      );
    }
  }

  @override
  Future<Either<dynamic, Failure>> emit(
    String event,
    dynamic data, {
    Duration? timeout,
  }) async {
    if (connected) {
      _socket!.emit(event, data);
      final completer = Completer<Either<dynamic, Failure>>();
      _socket!.once(
        'success',
        (data) => !completer.isCompleted
            ? completer.complete(
                Left(data),
              )
            : () {},
      );
      _socket!.once(
        'error',
        (error) => !completer.isCompleted
            ? completer.complete(
                Right(
                  Failure(error),
                ),
              )
            : () {},
      );
      return completer.future.timeout(requestTimeout);
    } else {
      return Right(
        Failure("Not connected to the server."),
      );
    }
  }
}
