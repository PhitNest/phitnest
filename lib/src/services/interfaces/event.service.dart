import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IEventService {
  bool get connected;

  void disconnect();

  Future<Either<Stream<dynamic>, Failure>> stream(
    String event,
    String accessToken,
  );

  Future<Either<dynamic, Failure>> emit(
    String event,
    dynamic data,
    String accessToken, {
    Duration? timeout,
  });
}
