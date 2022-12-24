import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class SendDirectMessageUseCase implements ISendDirectMessageUseCase {
  Future<Either<Tuple2<ConversationEntity, MessageEntity>, Failure>>
      sendDirectMessage(
    String recipientCognitoId,
    String message,
  ) =>
          getAuthTokenUseCase.getAccessToken().then(
                (either) => either.fold(
                  (accessToken) => messageRepo.sendDirectMessage(
                    accessToken,
                    recipientCognitoId,
                    message,
                  ),
                  (failure) => Right(failure),
                ),
              );
}
