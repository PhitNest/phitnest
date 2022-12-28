import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetGymUseCase {
  Future<Either<GymEntity, Failure>> getGym();
}
