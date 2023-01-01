import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetUserUseCase {
  Future<Either<UserEntity, Failure>> getUser();
}
