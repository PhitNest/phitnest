import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../data/data_sources/backend/backend.dart';
import '../entities/entities.dart';

class GymRepository {
  Future<Either<List<GymEntity>, Failure>> getNearest(
          LocationEntity location, double meters,
          {int? amount}) =>
      gymDatabase.getNearest(location, meters, amount: amount);
}

final gymRepository = GymRepository();
