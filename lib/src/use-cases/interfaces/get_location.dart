import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGetLocationUseCase {
  Future<Either<LocationEntity, Failure>> get();
}
