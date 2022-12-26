import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class StreamMessagesUseCase implements IStreamMessagesUseCase {
  @override
  Future<Either<Stream<MessageEntity>, Failure>> streamMessages(
          String conversationId) =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) =>
                  messageRepo.messageStream(accessToken, conversationId),
              (failure) => Right(failure),
            ),
          );
}
