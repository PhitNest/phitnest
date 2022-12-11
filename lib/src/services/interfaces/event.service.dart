import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IEventService {
  bool get connected;

  Future<void> connect();

  Future<void> disconnect();

  Stream<Failure> errors();

  Either<Stream<T>, Failure> stream<T>(String event);

  Either<void, Failure> emit(String event, dynamic data);
}
