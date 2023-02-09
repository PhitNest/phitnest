part of repository;

class _User {
  const _User();

  Future<Either<GetUserResponse, Failure>> getUser({
    required String accessToken,
  }) =>
      Backend.user.get(accessToken).then(
            (either) => either.fold(
              (response) => Future.wait(
                [
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
}
