import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class ISendMessageUseCase {
  Future<Either<MessageEntity, Failure>> sendMessage(
    String conversationId,
    String message,
  );
}
