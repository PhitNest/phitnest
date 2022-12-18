import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetMessagesUseCase {
  Future<Either<List<MessageEntity>, Failure>> getMessages(
      String conversationId);
}
