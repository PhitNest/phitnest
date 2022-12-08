import '../../entities/entities.dart';

abstract class IGymRepository {
  Future<List<GymEntity>> getNearestGyms({
    required LocationEntity location,
    required int distance,
    int? amount,
  });
}
