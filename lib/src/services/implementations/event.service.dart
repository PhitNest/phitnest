import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../common/logger.dart';
import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';
import '../services.dart';

class EventService implements IEventService {
  IO.Socket? _socket;

  @override
  bool get connected => _socket != null && _socket!.connected;

  Future<Failure?> _connect(String accessToken) async {
    try {
      logger.d("Connecting to the websocket server...");
      _socket = IO.io(
        '${environmentService.useHttps ? "wss" : "ws"}://${environmentService.backendHost}:${environmentService.backendPort}',
        OptionBuilder().setTransports(['websocket']).setExtraHeaders(
          {
            "token": "Bearer $accessToken",
          },
        ).build(),
      );
      final completer = Completer();
      _socket!.onConnect(
        (_) {
          if (!completer.isCompleted) {
            logger.d("Connected to the websocket server.");
            completer.complete();
          }
        },
      );
      _socket!.onDisconnect(
        (_) {
          logger.d("Disconnected from the websocket server.");
          _socket = null;
        },
      );
      await completer.future.timeout(requestTimeout);
      if (!connected) {
        return Failure("Failed to connect to the network.");
      }
      return null;
    } catch (error) {
      logger.e("Failed to connect to the websocket: $error");
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
      logger.d("Opening stream for event: $event");
      final handler = (data) {
        logger.d("Received event: $event\n\tData: $data");
        streamController.add(data);
      };
      final disconnectHandler = (_) {
        logger.d("Closing event stream due to disconnection: $event");
        streamController.close();
      };
      _socket!.on(
        event,
        handler,
      );
      _socket!.onDisconnect(
        disconnectHandler,
      );
      streamController.onCancel = () {
        logger.d("Closing event stream: $event");
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
      final failure = await _connect(accessToken);
      if (failure == null) {
        if (connected) {
          return Left(streamMessages());
        } else {
          return Right(Failure("Failed to connect to the network."));
        }
      } else {
        return Right(failure);
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
      logger.d("Emitting event: $event\n\tData: $data");
      _socket!.emit(event, data);
      final completer = Completer<Either<dynamic, Failure>>();
      _socket!.once(
        'success',
        (data) {
          if (!completer.isCompleted) {
            logger.d(
                "Successfully emitted event: $event\n\tReturned data: $data");
            completer.complete(Left(data));
          }
        },
      );
      _socket!.once(
        'error',
        (error) => !completer.isCompleted
            ? completer.complete(
                Right(
                  Failure(error.toString()),
                ),
              )
            : () {},
      );
      return completer.future.timeout(requestTimeout);
    };
    if (connected) {
      return await emitMessage();
    } else {
      final failure = await _connect(accessToken);
      if (failure == null) {
        if (connected) {
          return Left(emitMessage());
        } else {
          return Right(Failure("Failed to connect to the network."));
        }
      } else {
        return Right(failure);
      }
    }
  }
}
