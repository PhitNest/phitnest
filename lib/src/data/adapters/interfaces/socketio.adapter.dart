import 'package:dartz/dartz.dart';

import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';

abstract class ISocketIOAdapter {
  Future<Either<dynamic, Failure>> emit(
    SocketEvent event,
    dynamic data,
  );

  Future<Either<Stream<T>, Failure>> stream<T>(SocketEvent event);

  Future<Failure?> connect(String authorization);
}
