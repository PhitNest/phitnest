import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class GetFriendsUseCase implements IGetFriendsUseCase {
  @override
  Future<Either<List<FriendEntity>, Failure>> friends() =>
      getAuthTokenUseCase.getAccessToken().then(
            (either) => either.fold(
              (accessToken) => relationshipRepo.getFriends(accessToken),
              (failure) => Right(failure),
            ),
          );
}
