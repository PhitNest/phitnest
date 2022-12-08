import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class ILoginUseCase {
  Future<Either<AuthTokensEntity, Failure>> login({
    required String email,
    required String password,
  });
}
