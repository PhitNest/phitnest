import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class GetConversationsUseCase implements IGetConversationsUseCase {
  @override
  Future<Either<List<Tuple2<ConversationEntity, MessageEntity>>, Failure>>
      recents() => getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => conversationRepo.getRecents(accessToken),
              (failure) => Right(failure),
            ),
          );
}
