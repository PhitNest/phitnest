import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetNearestGymsUseCase {
  Future<Either<List<GymEntity>, Failure>> get({
    required LocationEntity location,
    required double maxDistance,
    int? limit,
  });
}
