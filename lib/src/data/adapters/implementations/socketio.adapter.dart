import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/logger.dart';
import '../../../common/utils/utils.dart';
import '../interfaces/socketio.adapter.dart';

const _timeout = Duration(seconds: 15);

class SocketIOAdapter implements ISocketIOAdapter {
  IO.Socket? _socket;

  bool get connected => _socket != null && _socket!.connected;

  @override
  Future<Failure?> connect(String authorization) async {
    try {
      prettyLogger.d("Connecting to the websocket server...");
      final completer = Completer();
      _socket = IO.io(
        '${dotenv.get('BACKEND_HOST')}:${dotenv.get('BACKEND_PORT')}',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'token': authorization})
            .build(),
      )
        ..connect()
        ..onConnect((_) {
          prettyLogger.d("Connected to the websocket server.");
          completer.complete();
          return Left(_socket);
        })
        ..onDisconnect(
          (_) {
            prettyLogger.d("Disconnected from the websocket server.");
            _socket = null;
          },
        );
      return await completer.future.timeout(_timeout);
    } catch (err) {
      prettyLogger.e("Failed to connect to the websocket: $err");
      return Failures.networkFailure.instance;
    }
  }

  @override
  FEither<Stream<T>, Failure> stream<T>(SocketEvent event) async {
    if (connected) {
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
      _socket!
        ..on(event.name, handler)
        ..onDisconnect(disconnectHandler);
      streamController.onCancel = () async {
        prettyLogger.d("Closing event stream: $event");
        if (connected) {
          _socket!
            ..off(event.name, handler)
            ..off('disconnect', disconnectHandler);
        }
        await streamController.close();
      };
      return Left(streamController.stream);
    } else {
      return Right(Failures.networkFailure.instance);
    }
  }

  @override
  FEither<dynamic, Failure> emit(
    SocketEvent event,
    dynamic data,
  ) async {
    if (connected) {
      try {
        prettyLogger.d('Emitting event: $event\n\tData: $data');
        _socket!.emit(event.name, data);
        final success = Completer<Either<dynamic, Failure>>();
        final error = Completer<Either<dynamic, Failure>>();
        _socket!.once(
          SocketEvent.success.name,
          (data) {
            prettyLogger.d(
                "Successfully emitted event: $event\n\tReturned data: $data");
            success.complete(Left(data));
          },
        );
        _socket!.once(
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
    } else {
      return Right(Failures.networkFailure.instance);
    }
  }
}
