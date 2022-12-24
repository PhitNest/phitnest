import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class ISendDirectMessageUseCase {
  Future<Either<Tuple2<ConversationEntity, MessageEntity>, Failure>>
      sendDirectMessage(
    String recipientCognitoId,
    String message,
  );
}
