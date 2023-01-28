import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/data_sources/gym/gym.dart';
import '../entities/entities.dart';

abstract class GymRepository {
  static FEither<List<GymEntity>, Failure> getNearest(
    LocationEntity location,
    double meters, {
    int? amount,
  }) =>
      GymDataSource.getNearest(
        location,
        meters,
        amount: amount,
      );
}
