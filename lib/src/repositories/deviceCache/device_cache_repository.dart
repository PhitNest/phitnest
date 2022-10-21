import '../repositories.dart';

class DeviceCacheRepository extends Repository {
  static const String _kCompletedOnBoarding = 'completedOnBoarding';
  static const String _kRefreshToken = 'refreshToken';
  static const String _kEmail = 'email';
  static const String _kPassword = 'password';

  bool get completedOnBoarding => storage!.containsKey(_kCompletedOnBoarding);

  completeOnBoarding() => storage!.setString(_kCompletedOnBoarding, 'true');

  String? get refreshToken => storage!.getString(_kRefreshToken);

  cacheRefreshToken(String? newRefreshToken) =>
      storage!.setString(_kRefreshToken, newRefreshToken!);

  String? get email => storage!.getString(_kEmail);

  cacheEmail(String? newEmail) => storage!.setString(_kEmail, newEmail!);

  String? get password => storage!.getString(_kPassword);

  cachePassword(String? newPassword) =>
      storage!.setString(_kPassword, newPassword!);
}
