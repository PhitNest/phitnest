import '../../repositories/repositories.dart';
import '../use_cases.dart';

class SkipOnBoardingUseCase implements ISkipOnBoardingUseCase {
  @override
  Future<bool> shouldSkip() async {
    return deviceCacheRepo.shouldSkipOnBoarding();
  }

  @override
  Future<void> setShouldSkip() {
    return deviceCacheRepo.setShouldSkipOnBoarding(true);
  }
}
