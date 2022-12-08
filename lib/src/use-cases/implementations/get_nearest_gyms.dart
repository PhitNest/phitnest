import '../../entities/entities.dart';
import '../../repositories/repositories.dart';
import '../interfaces/interfaces.dart';

class GetNearestGymsUseCase implements IGetNearestGymsUseCase {
  @override
  Future<List<GymEntity>> get({
    required LocationEntity location,
    required int maxDistance,
    int? limit,
  }) =>
      gymRepo.getNearestGyms(
        location: location,
        distance: maxDistance,
        amount: limit,
      );
}
