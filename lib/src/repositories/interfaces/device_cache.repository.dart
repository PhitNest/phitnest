abstract class IDeviceCacheRepository {
  bool get shouldSkipOnBoarding;
  set shouldSkipOnBoarding(bool shouldSkipOnBoarding);
  String? get accessToken;
  set accessToken(String? accessToken);
  String? get refreshToken;
  set refreshToken(String? refreshToken);
  String? get email;
  set email(String? email);
  String? get password;
  set password(String? password);
}
