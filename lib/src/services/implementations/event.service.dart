import 'package:dartz/dartz.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';

class EventService implements IEventService {
  Socket? _socket;

  @override
  bool get connected => throw UnimplementedError();

  @override
  Future<void> connect() {
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() {
    throw UnimplementedError();
  }

  @override
  Stream<Failure> errors() {
    throw UnimplementedError();
  }

  @override
  Either<Stream<T>, Failure> stream<T>(String event) {
    throw UnimplementedError();
  }

  @override
  Either<void, Failure> emit(String event, dynamic data) {
    throw UnimplementedError();
  }
}
