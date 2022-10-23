import 'package:shared_preferences/shared_preferences.dart';

import '../repositories.dart';

class DeviceCacheRepository extends Repository {
  static late SharedPreferences _storage;

  static init() async {
    _storage = await SharedPreferences.getInstance();
  }

  static const String _kCompletedOnBoarding = 'completedOnBoarding';
  static const String _kRefreshToken = 'refreshToken';
  static const String _kEmail = 'email';
  static const String _kPassword = 'password';

  bool get completedOnBoarding => _storage.containsKey(_kCompletedOnBoarding);

  completeOnBoarding() => _storage.setString(_kCompletedOnBoarding, 'true');

  String? get refreshToken => _storage.getString(_kRefreshToken);

  cacheRefreshToken(String? newRefreshToken) =>
      _storage.setString(_kRefreshToken, newRefreshToken!);

  String? get email => _storage.getString(_kEmail);

  cacheEmail(String? newEmail) => _storage.setString(_kEmail, newEmail!);

  String? get password => _storage.getString(_kPassword);

  cachePassword(String? newPassword) =>
      _storage.setString(_kPassword, newPassword!);
}
