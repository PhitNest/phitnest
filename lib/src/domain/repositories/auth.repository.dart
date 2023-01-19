import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/backend/backend.dart';

class AuthRepository {
  Future<Either<LoginResponse, Failure>> login(
          String email, String password) async =>
      authDatabase.login(email, password);

  Future<Either<RegisterResponse, Failure>> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gymId,
  ) async =>
      authDatabase.register(
        email,
        password,
        firstName,
        lastName,
        gymId,
      );
}

final authRepository = AuthRepository();
