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
    String firstName,
    String lastName,
    String email,
    String password,
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
}
