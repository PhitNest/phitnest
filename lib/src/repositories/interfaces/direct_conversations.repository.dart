import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IDirectConversationRepository {
  Future<
      Either<List<Tuple2<DirectConversationEntity, DirectMessageEntity>>,
          Failure>> getRecents(String accessToken);
}
