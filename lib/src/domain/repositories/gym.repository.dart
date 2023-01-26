import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/gym/gym.dart';
import '../entities/entities.dart';

abstract class GymRepository {
  static Future<Either<List<GymEntity>, Failure>> getNearest(
    LocationEntity location,
    double meters, {
    int? amount,
  }) =>
      GymDataSource.getNearest(
        location,
        meters,
        amount: amount,
      );
}
