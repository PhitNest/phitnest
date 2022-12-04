import '../../repositories/repositories.dart';
import '../use_cases.dart';

class SkipOnBoardingUseCase implements ISkipOnBoardingUseCase {
  @override
  bool shouldSkip() {
    return repositories<IDeviceCacheRepository>().shouldSkipOnBoarding;
  }

  @override
  void setShouldSkip() {
    repositories<IDeviceCacheRepository>().shouldSkipOnBoarding = true;
  }
}
