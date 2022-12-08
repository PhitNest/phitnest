import '../../entities/entities.dart';

abstract class IGetNearestGymsUseCase {
  Future<List<GymEntity>> get({
    required LocationEntity location,
    required int maxDistance,
    int? limit,
  });
}
