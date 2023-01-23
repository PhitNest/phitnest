import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../common/failure.dart';
import '../../../common/logger.dart';
import '../interfaces/socketio.adapter.dart';

class SocketIOAdapter implements ISocketIOAdapter {
  static IO.Socket? _socket;

  bool get connected => _socket != null && _socket!.connected;

  @override
  Future<Either<IO.Socket, Failure>> socketConnection(
    String path,
    String authorization,
  ) async {
    try {
      logger.d("Connecting to the websocket server...");
      _socket = IO.io(
        path,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'token': authorization})
            .build(),
      );
      _socket!.connect();

      final completer = Completer();

      _socket!.onConnect((_) {
        if (completer.isCompleted) {
          logger.d("Connected to the websocket server.");
          completer.complete();
          return Left(_socket);
        }
      });

      _socket!.onDisconnect((_) {
        logger.d("Disconnected from the websocket server.");
        _socket = null;
      });

      return await completer.future
          .timeout(Duration(seconds: 10))
          .whenComplete(() {
        return Left(_socket);
      }).onError((error, _) {
        logger.e('Socket connection error occurred : $error');
        return Right(
          Failure('SocketConnectionFailure', 'Failed to connect to websocket.'),
        );
      });
    } catch (err) {
      logger.e("Failed to connect to the websocket: $err");
      return Right(
        Failure('SocketConnectionFailure', 'Failed to connect to websocket.'),
      );
    }
  }

  @override
  Future<Either<Stream<dynamic>, Failure>> stream(
    SocketEvent event,
    String authorization,
  ) async {
    final streamMessages = () {
      final streamController = StreamController<dynamic>();
      logger.d('Opening stream for event: $event.name');

      final handler = (data) {
        logger.d("Received event: ${event.name}\n\tData: $data");
        streamController.add(data);
      };
      final disconnectHandler = (_) {
        logger.d('Closing event stream : ${event.name}');
        streamController.close();
      };

      _socket!.on(event.name, handler);

      _socket!.onDisconnect(disconnectHandler);

      streamController.onCancel = () {
        logger.d("Closing event stream: $event");
        if (connected) {
          _socket!.off(event.name, handler);
          _socket!.off(SocketEvent.disconnect.name, disconnectHandler);
        }
        streamController.close();
      };
      return streamController.stream;
    };

    if (connected) {
      return Left(streamMessages());
    } else {
      return Right(
        Failure('SocketConnectionFailure', 'Failed to connect to websocket.'),
      );
    }
  }

  @override
  Future<Either<dynamic, Failure>> emit(
    SocketEvent event,
    dynamic data,
  ) async {
    final emitMessage = () {
      logger.d('Emitting event: $event\n\tData: $data');

      _socket!.emit(event.name, data);

      final completer = Completer<Either<dynamic, Failure>>();

      _socket!.once(
        SocketEvent.success.name,
        (data) {
          if (!completer.isCompleted) {
            logger.d(
                "Successfully emitted event: $event\n\tReturned data: $data");
            completer.complete(Left(data));
          }
        },
      );

      _socket!.once(
        SocketEvent.error.name,
        (err) => !completer.isCompleted
            ? completer.complete(
                Right(
                  Failure("SocketIOError", err.toString()),
                ),
              )
            : () {},
      );
      return completer.future.timeout(Duration(seconds: 10));
    };

    if (connected) {
      return Left(emitMessage);
    } else {
      return Right(
        Failure('SocketConnectionFailure', 'Failed to connect to websocket.'),
      );
    }
  }
}
