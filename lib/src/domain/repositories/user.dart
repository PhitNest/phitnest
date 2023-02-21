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
                      Cache.profilePictureImageCache),
                  Cache.cacheGym(response.gym),
                  Cache.cacheUser(response),
                  Cache.cacheProfilePictureUrl(response.profilePictureUrl),
                ],
              ).then(
                (_) => Left(response),
              ),
              (failure) => Right(failure),
            ),
          );

  Future<Either<UserExploreResponse, Failure>> exploreUsers({
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
              (response) =>
                  // TODO: Cache profile pictures with CachedNetworkImage
                  Cache.cacheUserExplore(response).then((_) => Left(response)),
              (failure) => Right(failure),
            ),
          );
}
