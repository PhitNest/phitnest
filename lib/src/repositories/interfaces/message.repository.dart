import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IMessageRepository {
  Future<Either<List<MessageEntity>, Failure>> getMessages(
    String accessToken,
    String conversationId,
  );

  Future<Either<Stream<MessageEntity>, Failure>> messageStream(
    String accessToken,
    String conversationId,
  );

  Future<Either<Tuple2<ConversationEntity, MessageEntity>, Failure>>
      sendDirectMessage(
    String accessToken,
    String recipientCognitoId,
    String text,
  );

  Future<Either<MessageEntity, Failure>> sendMessage(
    String accessToken,
    String conversationId,
    String text,
  );
}
