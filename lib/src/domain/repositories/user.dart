part of repository;

class User {
  const User();

  Future<Either<GetUserResponse, Failure>> getUser({
    required String accessToken,
  }) =>
      Backend.user.get(accessToken).then(
            (either) => either.fold(
              (response) => Future.wait(
                [
                  CachedNetworkImage.evictFromCache(
                      Cache.profilePicture.profilePictureImageCacheKey),
                  Cache.gym.cacheGym(response.gym),
                  Cache.user.cacheUser(response),
                  Cache.profilePicture
                      .cacheProfilePictureUrl(response.profilePictureUrl),
                ],
              ).then(
                (_) => Left(response),
              ),
              (failure) => Right(failure),
            ),
          );

  Future<Either<List<ProfilePicturePublicUserEntity>, Failure>> exploreUsers({
    required String accessToken,
    required String gymId,
  }) =>
      Backend.user
          .explore(
            accessToken: accessToken,
            gymId: gymId,
          )
          .then(
            (either) => either.fold(
              (response) => Future.value(
                [
                  Cache.user
                      .cacheUserExplore(response)
                      .then((_) => Left(response)),
                  ...response.map(
                    (user) => CachedNetworkImage.evictFromCache(
                      Cache.profilePicture
                          .getUserProfilePictureImageCacheKey(user.id),
                    ),
                  ),
                ],
              ).then((_) => Left(response)),
              (failure) => Right(failure),
            ),
          );
}
