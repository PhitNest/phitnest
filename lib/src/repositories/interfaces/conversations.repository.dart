import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IConversationRepository {
  Future<Either<List<Tuple2<ConversationEntity, MessageEntity>>, Failure>>
      getRecents(String accessToken);
}
