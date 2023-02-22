part of repository;

class Auth {
  const Auth();

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
                  Cache.auth.cachePassword(password),
                  Cache.user.cacheUser(response.user),
                  Cache.profilePicture
                      .cacheProfilePictureUrl(response.user.profilePictureUrl),
                  Cache.auth.cacheAccessToken(response.accessToken),
                  Cache.auth.cacheRefreshToken(response.refreshToken),
                  Cache.gym.cacheGym(response.gym),
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
                  Cache.auth.cachePassword(password),
                  Cache.user.cacheUser(response.user),
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
                  Cache.user.cacheUser(user),
                  Cache.profilePicture
                      .cacheProfilePictureUrl(user.profilePictureUrl),
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
                  Cache.auth.cacheRefreshToken(refreshToken),
                  Cache.auth.cacheAccessToken(user.accessToken),
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
                Cache.auth.cachePassword(null),
                Cache.auth.cacheAccessToken(null),
                Cache.auth.cacheRefreshToken(null),
                Cache.user.cacheUser(null),
                Cache.profilePicture.cacheProfilePictureUrl(null),
                Cache.gym.cacheGym(null),
                Cache.user.cacheUserExplore(null),
              ],
            ).then((_) => null);
          }
          return failure;
        },
      );
}
