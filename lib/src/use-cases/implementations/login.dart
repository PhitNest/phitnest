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
              (session) {
                memoryCacheRepo.email = email;
                memoryCacheRepo.password = password;
                memoryCacheRepo.accessToken = session.accessToken;
                memoryCacheRepo.refreshToken = session.refreshToken;
                deviceCacheRepo.email = email;
                deviceCacheRepo.password = password;
                deviceCacheRepo.accessToken = session.accessToken;
                deviceCacheRepo.refreshToken = session.refreshToken;
                return Left(session);
              },
              (failure) => Right(failure),
            ),
          );
}
