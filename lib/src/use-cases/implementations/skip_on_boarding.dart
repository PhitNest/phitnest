import '../../repositories/repositories.dart';
import '../use_cases.dart';

class SkipOnBoardingUseCase implements ISkipOnBoardingUseCase {
  @override
  bool shouldSkip() {
    return deviceCacheRepo.shouldSkipOnBoarding;
  }

  @override
  void setShouldSkip() {
    deviceCacheRepo.shouldSkipOnBoarding = true;
  }
}
