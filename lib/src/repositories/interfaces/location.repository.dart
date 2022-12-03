import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class ILocationRepository {
  /// Will either return a valid user location as a [LocationEntity], or
  /// return a [String] if there is an error.
  Future<Either<LocationEntity, String>> getLocation();
}
