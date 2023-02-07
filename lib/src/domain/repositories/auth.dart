part of repository;

class _Auth {
  const _Auth();

  Future<Either<LoginResponse, Failure>> login({
    required String email,
    required String password,
  }) =>
      Backend.auth
          .login(
            email: email,
            password: password,
          )
          .then(
            (either) => either.fold(
              (response) => Future.wait(
                [
                  Cache.cachePassword(password),
                  Cache.cacheUser(response.user),
                  Cache.cacheProfilePictureUrl(response.user.profilePictureUrl),
                  Cache.cacheAccessToken(response.accessToken),
                  Cache.cacheRefreshToken(response.refreshToken),
                  Cache.cacheGym(response.gym),
                ],
              ).then((_) => Left(response)),
              (failure) => Right(failure),
            ),
          );

  Future<Either<RegisterResponse, Failure>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gymId,
  }) =>
      Backend.auth
          .register(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            gymId: gymId,
          )
          .then(
            (either) => either.fold(
              (response) => Future.wait(
                [
                  Cache.cachePassword(password),
                  Cache.cacheUser(response.user),
                ],
              ).then((_) => Left(response)),
              (failure) => Right(failure),
            ),
          );

  Future<Either<ProfilePictureUserEntity, Failure>> confirmRegister({
    required String email,
    required String code,
  }) =>
      Backend.auth
          .confirmRegister(
            email: email,
            code: code,
          )
          .then(
            (either) => either.fold(
              (user) => Future.wait(
                [
                  Cache.cacheUser(user),
                  Cache.cacheProfilePictureUrl(user.profilePictureUrl),
                ],
              ).then((_) => Left(user)),
              (failure) => Right(failure),
            ),
          );

  Future<Either<RefreshSessionResponse, Failure>> refreshSession({
    required String email,
    required String refreshToken,
  }) =>
      Backend.auth
          .refreshSession(
            email: email,
            refreshToken: refreshToken,
          )
          .then(
            (either) => either.fold(
              (user) => Future.wait(
                [
                  Cache.cacheRefreshToken(refreshToken),
                  Cache.cacheAccessToken(user.accessToken),
                ],
              ).then((_) => Left(user)),
              (failure) => Right(failure),
            ),
          );

  Future<Failure?> signOut({
    required String accessToken,
    required bool allDevices,
  }) =>
      Backend.auth
          .signOut(
        allDevices: allDevices,
        accessToken: accessToken,
      )
          .then(
        (failure) {
          if (failure == null) {
            return Future.wait(
              [
                Cache.cachePassword(null),
                Cache.cacheAccessToken(null),
                Cache.cacheRefreshToken(null),
                Cache.cacheUser(null),
                Cache.cacheProfilePictureUrl(null),
                Cache.cacheGym(null),
              ],
            ).then((_) => null);
          }
          return failure;
        },
      );
}
