import '../../entities/entities.dart';
import '../interfaces/interfaces.dart';

class MemoryCacheRepository implements IMemoryCacheRepository {
  GymEntity? _myGym;

  @override
  GymEntity? get myGym => _myGym;

  @override
  set myGym(GymEntity? gym) => _myGym = gym;
}
