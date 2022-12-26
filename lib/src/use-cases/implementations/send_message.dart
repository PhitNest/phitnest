import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class SendMessageUseCase implements ISendMessageUseCase {
  Future<Either<MessageEntity, Failure>> sendMessage(
    String conversationId,
    String message,
  ) =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => messageRepo.sendMessage(
                accessToken,
                conversationId,
                message,
              ),
              (failure) => Right(failure),
            ),
          );
}
