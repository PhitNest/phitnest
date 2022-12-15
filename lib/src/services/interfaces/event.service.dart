import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IEventService {
  bool get connected;

  Future<void> connect(String accessToken);

  void disconnect();

  Either<Stream<dynamic>, Failure> stream(String event);

  Future<Either<dynamic, Failure>> emit(
    String event,
    dynamic data, {
    Duration? timeout,
  });
}
