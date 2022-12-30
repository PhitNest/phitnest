import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IStreamDirectMessageUseCase {
  Future<Either<Stream<Tuple2<ConversationEntity, MessageEntity>>, Failure>>
      streamDirectMessage();
}
