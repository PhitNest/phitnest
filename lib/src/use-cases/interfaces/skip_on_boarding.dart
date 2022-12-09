abstract class ISkipOnBoardingUseCase {
  Future<bool> shouldSkip();

  Future<void> setShouldSkip();
}
