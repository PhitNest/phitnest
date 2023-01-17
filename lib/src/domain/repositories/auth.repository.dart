import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/backend/backend.dart';

class AuthRepository {
  Future<Either<LoginResponse, Failure>> login(
          String email, String password) async =>
      authDatabase.login(email, password);
}

final authRepository = AuthRepository();
