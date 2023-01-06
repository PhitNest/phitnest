import '../../repositories/repositories.dart';
import '../use_cases.dart';

class SkipOnBoardingUseCase implements ISkipOnBoardingUseCase {
  @override
  Future<bool> shouldSkip() async {
    return false; // This will make it so we never skip the on boarding screen
    // return deviceCacheRepo.shouldSkipOnBoarding();
  }

  @override
  Future<void> setShouldSkip() {
    return deviceCacheRepo.setShouldSkipOnBoarding(true);
  }
}