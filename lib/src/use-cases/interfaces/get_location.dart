import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../failures/failures.dart';

abstract class IGetLocationUseCase {
  Future<Either<LocationEntity, Failure>> get();
}
