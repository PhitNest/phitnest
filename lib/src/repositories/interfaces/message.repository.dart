import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IMessageRepository {
  Future<Either<List<MessageEntity>, Failure>> getMessages(
    String accessToken,
    String conversationId,
  );
}
