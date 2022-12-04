import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../failures/failures.dart';

abstract class IAuthRepository {
  Future<Either<AuthTokensEntity, Failure>> login(
      String email, String password);
  Future<String?> register(String email, String password, String gymId,
      String firstName, String lastName);
  Future<Either<SessionRefreshTokensEntity, Failure>> refreshSession(
      String email, String refreshToken);
}
