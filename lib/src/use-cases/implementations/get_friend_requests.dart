import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class GetFriendRequestsUseCase implements IGetFriendRequestsUseCase {
  Future<Either<Stream<PublicUserEntity>, Failure>> friendRequestStream() =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) =>
                  relationshipRepo.friendRequestStream(accessToken),
              (failure) => Right(failure),
            ),
          );

  Future<Either<List<PublicUserEntity>, Failure>> getFriendRequests() =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) =>
                  relationshipRepo.getIncomingFriendRequests(accessToken),
              (failure) => Right(failure),
            ),
          );
}
