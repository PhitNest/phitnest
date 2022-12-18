import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class GetMessagesUseCase implements IGetMessagesUseCase {
  @override
  Future<Either<List<MessageEntity>, Failure>> getMessages(
          String conversationId) =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) =>
                  messageRepo.getMessages(accessToken, conversationId),
              (failure) => Right(failure),
            ),
          );
}
