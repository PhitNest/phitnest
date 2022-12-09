import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IUserRepository {
  Future<Either<UserEntity, Failure>> getUser(String accessToken);

  Future<Either<List<ExploreUserEntity>, Failure>> getTutorialExploreUsers(
    String gymId, {
    int? skip,
    int? limit,
  });

  Future<Either<List<ExploreUserEntity>, Failure>> getExploreUsers(
    String accessToken, {
    int? skip,
    int? limit,
  });
}
