abstract class IDeviceCacheRepository {
  Future<bool> shouldSkipOnBoarding();
  Future<void> setShouldSkipOnBoarding(bool shouldSkipOnBoarding);
  Future<String?> accessToken();
  Future<void> setAccessToken(String? accessToken);
  Future<String?> refreshToken();
  Future<void> setRefreshToken(String? refreshToken);
  Future<String?> email();
  Future<void> setEmail(String? email);
  Future<String?> password();
  Future<void> setPassword(String? password);
}
