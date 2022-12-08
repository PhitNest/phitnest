import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../use_cases.dart';

class GetLocationUseCase implements IGetLocationUseCase {
  @override
  Future<Either<LocationEntity, Failure>> get() => locationRepo.getLocation();
}
