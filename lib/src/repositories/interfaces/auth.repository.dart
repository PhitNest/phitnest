import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IAuthRepository {
  Future<Either<AuthTokensEntity, Failure>> login(
      String email, String password);

  Future<Failure?> register(String email, String password, String gymId,
      String firstName, String lastName);

  Future<Either<SessionRefreshTokensEntity, Failure>> refreshSession(
      String email, String refreshToken);

  Future<bool> validAccessToken(String accessToken);
}
