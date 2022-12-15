import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../interfaces/interfaces.dart';

class GetAuthTokenUseCase implements IGetAuthTokenUseCase {
  @override
  Future<Either<String, Failure>> getAccessToken() async {
    // Check if we have a valid access token cached
    String? memoryCache = memoryCacheRepo.accessToken;
    if (memoryCache != null) {
      if (await authRepo.validAccessToken(memoryCache)) {
        return Left(memoryCache);
      }
    } else {
      String? deviceCache = await deviceCacheRepo.accessToken();
      if (deviceCache != null) {
        if (await authRepo.validAccessToken(deviceCache)) {
          memoryCacheRepo.accessToken = deviceCache;
          return Left(deviceCache);
        }
      }
    }
    memoryCacheRepo.accessToken = null;
    await deviceCacheRepo.setAccessToken(null);
    // Check if we have a valid email cached
    String? email = memoryCacheRepo.email;
    if (email == null) {
      email = await deviceCacheRepo.email();
      if (email != null) {
        memoryCacheRepo.email = email;
      } else {
        return Right(
          Failure("No email cached"),
        );
      }
    }
    String? refreshToken = memoryCacheRepo.refreshToken;
    if (refreshToken == null) {
      refreshToken = await deviceCacheRepo.refreshToken();
      if (refreshToken != null) {
        memoryCacheRepo.refreshToken = refreshToken;
      }
    }
    if (refreshToken != null) {
      final refreshResult = await authRepo.refreshSession(
        email,
        refreshToken,
        timeout: const Duration(milliseconds: 750),
      );
      if (refreshResult.isLeft()) {
        return refreshResult.fold(
          (session) async {
            if (await authRepo.validAccessToken(session.accessToken)) {
              memoryCacheRepo.accessToken = session.accessToken;
              await deviceCacheRepo.setAccessToken(session.accessToken);
              return Left(session.accessToken);
            } else {
              memoryCacheRepo.refreshToken = null;
              await deviceCacheRepo.setRefreshToken(null);
              return await getAccessToken();
            }
          },
          (failure) => Right(failure),
        );
      }
    }
    // If we don't have a valid refresh token, we need to login again
    String? password = memoryCacheRepo.password;
    if (password == null) {
      password = await deviceCacheRepo.password();
      if (password != null) {
        memoryCacheRepo.password = password;
      }
    }
    if (password != null) {
      final loginResult = await authRepo.login(
        email,
        password,
        timeout: const Duration(milliseconds: 750),
      );
      if (loginResult.isLeft()) {
        return loginResult.fold(
          (session) async {
            await deviceCacheRepo.setAccessToken(session.accessToken);
            await deviceCacheRepo.setRefreshToken(session.refreshToken);
            memoryCacheRepo.accessToken = session.accessToken;
            memoryCacheRepo.refreshToken = session.refreshToken;
            return Left(session.accessToken);
          },
          (failure) => Right(failure),
        );
      }
    }
    return Right(
      Failure("No auth credentials in the cache"),
    );
  }
}
