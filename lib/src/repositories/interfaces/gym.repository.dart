import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGymRepository {
  Future<Either<List<GymEntity>, Failure>> getNearestGyms({
    required LocationEntity location,
    required double distance,
    int? amount,
  });

  Future<Either<GymEntity, Failure>> getGym(String accessToken);
}
