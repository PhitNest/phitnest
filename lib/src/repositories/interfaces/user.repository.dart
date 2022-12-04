import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../failures/failures.dart';

abstract class IUserRepository {
  Future<Either<UserEntity, Failure>> getUser(String accessToken);
}
