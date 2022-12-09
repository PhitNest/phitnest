import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class LoginUseCase implements ILoginUseCase {
  @override
  Future<Either<AuthTokensEntity, Failure>> login({
    required String email,
    required String password,
  }) =>
      authRepo.login(email, password).then(
            (either) => either.fold(
              (session) async {
                memoryCacheRepo.email = email;
                memoryCacheRepo.password = password;
                memoryCacheRepo.accessToken = session.accessToken;
                memoryCacheRepo.refreshToken = session.refreshToken;
                await deviceCacheRepo.setEmail(email);
                await deviceCacheRepo.setPassword(password);
                await deviceCacheRepo.setAccessToken(session.accessToken);
                await deviceCacheRepo.setRefreshToken(session.refreshToken);
                return Left(session);
              },
              (failure) => Right(failure),
            ),
          );
}
