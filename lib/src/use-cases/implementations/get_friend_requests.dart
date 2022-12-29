import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class GetFriendRequestsUseCase implements IGetFriendRequestsUseCase {
  Future<Either<List<PublicUserEntity>, Failure>> getIncomingFriendRequests() =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) =>
                  relationshipRepo.getIncomingFriendRequests(accessToken),
              (failure) => Right(failure),
            ),
          );
}
