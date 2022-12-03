import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IAuthRepository {
  Future<Either<AuthTokensEntity, String>> login(String email, String password);
  Future<String?> register(String email, String password, String gymId,
      String firstName, String lastName);
}
