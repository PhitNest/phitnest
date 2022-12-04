import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../failures/failures.dart';
import '../../repositories/repositories.dart';
import '../interfaces/interfaces.dart';

class LoginWithCacheUseCase implements ILoginWithCacheUseCase {
  @override
  Future<Either<UserEntity, Failure>> login() async {
    String? accessToken = repositories<IMemoryCacheRepository>().accessToken;
    if (accessToken == null) {
      accessToken = repositories<IDeviceCacheRepository>().accessToken;
    }
    if (accessToken != null) {
      final result = await repositories<IUserRepository>().getUser(accessToken);
      if (result.isLeft()) {
        return result;
      }
    }
    String? email = repositories<IMemoryCacheRepository>().email;
    if (email == null) {
      email = repositories<IDeviceCacheRepository>().email;
    }
    if (email == null) {
      return Right(AuthenticationFailure());
    }
    String? refreshToken = repositories<IMemoryCacheRepository>().refreshToken;
    if (refreshToken == null) {
      refreshToken = repositories<IDeviceCacheRepository>().refreshToken;
    }
    if (refreshToken != null) {
      final result = await repositories<IAuthRepository>()
          .refreshSession(email, refreshToken);
      if (result.isLeft()) {
        final folded = await result.fold<Future<Either<UserEntity, Failure>>>(
          (session) =>
              repositories<IUserRepository>().getUser(session.accessToken),
          (failure) => Future(() => Right(failure)),
        );
        if (folded.isLeft()) {
          return folded;
        }
      }
    }
    String? password = repositories<IMemoryCacheRepository>().password;
    if (password == null) {
      password = repositories<IDeviceCacheRepository>().password;
    }
    if (password != null) {
      return await (await repositories<IAuthRepository>()
              .login(email, password))
          .fold<Future<Either<UserEntity, Failure>>>(
        (session) =>
            repositories<IUserRepository>().getUser(session.accessToken),
        (failure) => Future(
          () => Right(failure),
        ),
      );
    }
    return Right(AuthenticationFailure());
  }
}
