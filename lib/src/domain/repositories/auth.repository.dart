import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/backend/backend.dart';
import '../../data/data_sources/cache/cache.dart';

class AuthRepository {
  const AuthRepository();

  Future<Either<LoginResponse, Failure>> login(
    String email,
    String password,
  ) async {
    final response = await authBackend.login(email, password);
    if (response.isLeft()) {
      await deviceCache.cacheEmail(email);
      await deviceCache.cachePassword(password);
      await response.fold(
        (response) async {
          await deviceCache.cacheUser(response.user);
          await deviceCache.cacheAccessToken(response.session.accessToken);
          await deviceCache.cacheRefreshToken(response.session.refreshToken);
        },
        (failure) => throw Exception("This should not happen."),
      );
    }
    return response;
  }

  Future<Either<RegisterResponse, Failure>> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String gymId,
  ) async {
    final response = await authBackend.register(
      firstName,
      lastName,
      email,
      password,
      gymId,
    );
    if (response.isLeft()) {
      await deviceCache.cacheEmail(email);
      await deviceCache.cachePassword(password);
      await deviceCache.cacheUser(response
          .swap()
          .getOrElse(() => throw Exception("This should not happen.")));
    }
    return response;
  }
}

const authRepo = AuthRepository();
