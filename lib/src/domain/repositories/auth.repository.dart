import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/adapters/adapters.dart';
import '../../data/data_sources/backend/backend.dart';
import '../../data/data_sources/cache/cache.dart';

abstract class AuthRepository {
  static FEither<LoginResponse, Failure> login(
    String email,
    String password,
  ) async {
    final response = await httpAdapter.request(
      kLoginRoute,
      LoginRequest(
        email: email,
        password: password,
      ),
    );
    if (response.isLeft()) {
      await cacheEmail(email);
      await cachePassword(password);
      await response.fold(
        (response) async {
          await cacheUser(response.user);
          await cacheAccessToken(response.session.accessToken);
          await cacheRefreshToken(response.session.refreshToken);
        },
        (failure) => throw Exception("This should not happen."),
      );
    }
    return response;
  }

  static FEither<RegisterResponse, Failure> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gymId,
  ) async {
    final response = await httpAdapter.request(
      kRegisterRoute,
      RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        gymId: gymId,
      ),
    );
    if (response.isLeft()) {
      await cacheEmail(email);
      await cachePassword(password);
      await cacheUser(
        response
            .swap()
            .getOrElse(() => throw Exception("This should not happen."))
            .user,
      );
    }
    return response;
  }

  static FEither<ProfilePictureUserEntity, Failure> confirmRegister(
    String email,
  ) async {
    final result = await httpAdapter.request(
      kForgotPasswordRoute,
      ForgotPasswordRequest(
        email: email,
      ),
    );
    if (result.isLeft()) {
      await cacheProfilePictureUser(
        result.swap().getOrElse(
              () => throw Exception("This should not happen."),
            ),
      );
    }
    return result;
  }

  static FEither<RefreshSessionResponse, Failure> refreshSession(
    String email,
    String refreshToken,
  ) async {
    final result = await httpAdapter.request(
      kRefreshSessionRoute,
      RefreshSessionRequest(
        email: email,
        refreshToken: refreshToken,
      ),
    );

    if (result.isLeft()) {
      await cacheRefreshToken(refreshToken);
    }

    return result;
  }

  static Future<Failure?> signOut(
    bool allDevices,
  ) =>
      httpAdapter
          .requestVoid(
        kSignOutRoute,
        SignOutRequest(
          allDevices: allDevices,
        ),
      )
          .then(
        (failure) async {
          if (failure == null) {
            await Future.wait(
              [
                cacheAccessToken(null),
                cacheRefreshToken(null),
                cacheUser(null),
                cacheEmail(null),
                cacheGym(null),
              ],
            );
          }
          return failure;
        },
      );
}
