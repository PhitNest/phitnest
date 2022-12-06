import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../failures/failures.dart';

abstract class ILocationRepository {
  Future<Either<LocationEntity, LocationFailure>> getLocation();
}
