import '../../../common/constants/constants.dart';
import '../../../common/failure.dart';
import '../../../common/utils/utils.dart';

abstract class ISocketIOAdapter {
  FEither<dynamic, Failure> emit(
    SocketEvent event,
    dynamic data,
  );

  FEither<Stream<T>, Failure> stream<T>(SocketEvent event);

  Future<Failure?> connect(String authorization);
}
