import '../../entities/entities.dart';

abstract class IMemoryCacheRepository {
  set myGym(GymEntity? gym);

  GymEntity? get myGym;
}
