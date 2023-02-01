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
                  cacheEmail(email),
                  cachePassword(password),
                  cacheUser(response.user),
                  cacheAccessToken(response.accessToken),
                  cacheRefreshToken(response.refreshToken),
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
                  cacheEmail(email),
                  cachePassword(password),
                  cacheUser(response.user),
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
                  cacheEmail(email),
                  cacheProfilePictureUser(user),
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
                  cacheEmail(email),
                  cacheRefreshToken(refreshToken),
                  cacheAccessToken(user.accessToken),
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
          if (failure != null) {
            return Future.wait(
              [
                cacheEmail(null),
                cachePassword(null),
                cacheAccessToken(null),
                cacheRefreshToken(null),
                cacheProfilePictureUser(null),
              ],
            ).then((_) => null);
          }
          return failure;
        },
      );
}
