import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../failures/failures.dart';

abstract class ILoginWithCacheUseCase {
  Future<Either<UserEntity, Failure>> login();
}
