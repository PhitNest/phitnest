import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../interfaces/interfaces.dart';

class GetNearestGymsUseCase implements IGetNearestGymsUseCase {
  @override
  Future<Either<List<GymEntity>, Failure>> get({
    required LocationEntity location,
    required double maxDistance,
    int? limit,
  }) =>
      gymRepo.getNearestGyms(
        location: location,
        distance: maxDistance,
        amount: limit,
      );
}
