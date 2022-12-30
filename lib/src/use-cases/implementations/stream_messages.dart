import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class StreamMessagesUseCase implements IStreamMessagesUseCase {
  @override
  Future<Either<Stream<MessageEntity>, Failure>> streamMessages() =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => messageRepo.messageStream(accessToken),
              (failure) => Right(failure),
            ),
          );
}
