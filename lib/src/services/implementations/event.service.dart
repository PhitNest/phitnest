import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';
import '../services.dart';

class EventService implements IEventService {
  IO.Socket? _socket;

  @override
  bool get connected => _socket != null && _socket!.connected;

  @override
  Future<Failure?> connect(String accessToken) async {
    try {
      _socket = IO.io(
        '${environmentService.useHttps ? "https" : "http"}://${environmentService.backendHost}:${environmentService.backendPort}',
        OptionBuilder().setTransports(['websocket']).setExtraHeaders(
          {
            "token": "Bearer $accessToken",
          },
        ).build(),
      );
      final completer = Completer();
      _socket!.onConnect(
        (_) => completer.complete(),
      );
      _socket!.onDisconnect(
        (_) => _socket = null,
      );
      await completer.future.timeout(requestTimeout);
      if (!connected) {
        return Failure("Failed to connect to the network.");
      }
      return null;
    } catch (error) {
      return Failure("Failed to connect to the network.");
    }
  }

  @override
  void disconnect() async {
    if (connected) {
      _socket!.disconnect();
    }
  }

  @override
  Future<Either<Stream<dynamic>, Failure>> stream(
    String event,
    String accessToken,
  ) async {
    final streamMessages = () {
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
      return streamController.stream;
    };
    if (connected) {
      return Left(streamMessages());
    } else {
      await connect(accessToken);
      if (connected) {
        return Left(streamMessages());
      } else {
        return Right(
          Failure("Not connected to the server."),
        );
      }
    }
  }

  @override
  Future<Either<dynamic, Failure>> emit(
    String event,
    dynamic data,
    String accessToken, {
    Duration? timeout,
  }) async {
    final emitMessage = () {
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
    };
    if (connected) {
      return await emitMessage();
    } else {
      await connect(accessToken);
      if (connected) {
        return await emitMessage();
      } else {
        return Right(
          Failure("Not connected to the server."),
        );
      }
    }
  }
}
