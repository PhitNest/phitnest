import 'package:dartz/dartz.dart';

import '../../entities/entities.dart';

abstract class IGymRepository {
  Future<Either<List<GymEntity>, String>> getNearestGyms(
      {required LocationEntity location, required int distance, int? amount});
}
