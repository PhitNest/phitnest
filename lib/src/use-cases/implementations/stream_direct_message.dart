import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class StreamDirectMessageUseCase implements IStreamDirectMessageUseCase {
  @override
  Future<Either<Stream<Tuple2<ConversationEntity, MessageEntity>>, Failure>>
      streamDirectMessage() => getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => messageRepo.directMessageStream(
                accessToken,
              ),
              (failure) => Right(failure),
            ),
          );
}
