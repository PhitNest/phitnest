import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class ILocationRepository {
  Future<Either<LocationEntity, Failure>> getLocation();
}
