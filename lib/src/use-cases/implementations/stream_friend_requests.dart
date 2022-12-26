import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class StreamFriendRequestsUseCase implements IStreamFriendRequestsUseCase {
  @override
  Future<Either<Stream<PublicUserEntity>, Failure>> streamFriendRequests() =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) =>
                  relationshipRepo.friendRequestStream(accessToken),
              (failure) => Right(failure),
            ),
          );
}
