import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/backend/backend.dart';
import '../../data/data_sources/cache/cache.dart';

class AuthRepository {
  const AuthRepository();

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
