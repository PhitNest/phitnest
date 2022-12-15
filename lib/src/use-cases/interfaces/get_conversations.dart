import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetConversationsUseCase {
  Future<Either<List<Tuple2<ConversationEntity, MessageEntity>>, Failure>>
      recents();
}
