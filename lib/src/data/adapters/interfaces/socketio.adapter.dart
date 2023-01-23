import 'package:dartz/dartz.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../common/failure.dart';

enum SocketEvent {
  friendRequest,
  directMessage,
  friendship,
  disconnect,
  success,
  error
}

abstract class ISocketIOAdapter {
  Future<Either<dynamic, Failure>> emit(
    SocketEvent event,
    dynamic data,
  );

  Future<Either<Stream<dynamic>, Failure>> stream(
    SocketEvent event,
    String authorization,
  );

  Future<Either<IO.Socket, Failure>> socketConnection(
    String path,
    String authorization,
  );
}
