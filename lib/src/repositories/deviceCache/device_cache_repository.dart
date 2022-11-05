import 'package:shared_preferences/shared_preferences.dart';

import '../repositories.dart';

class DeviceCacheRepository extends Repository {
  static late SharedPreferences _storage;

  static init() async {
    _storage = await SharedPreferences.getInstance();
  }

  static const String _kCompletedOnBoarding = 'completedOnBoarding';
  static const String _kRefreshToken = 'refreshToken';
  static const String _kAccessToken = 'accessToken';
  static const String _kEmail = 'email';
  static const String _kPassword = 'password';

  bool get completedOnBoarding => _storage.containsKey(_kCompletedOnBoarding);

  Future<bool> completeOnBoarding() =>
      _storage.setString(_kCompletedOnBoarding, 'true');

  String? get refreshToken => _storage.getString(_kRefreshToken);

  Future<bool> cacheRefreshToken(String? newRefreshToken) =>
      _storage.setString(_kRefreshToken, newRefreshToken!);

  String? get accessToken => _storage.getString(_kAccessToken);

  Future<bool> cacheAccessToken(String? newAccessToken) =>
      _storage.setString(_kAccessToken, newAccessToken!);

  String? get email => _storage.getString(_kEmail);

  Future<bool> cacheEmail(String? newEmail) =>
      _storage.setString(_kEmail, newEmail!);

  String? get password => _storage.getString(_kPassword);

  Future<bool> cachePassword(String? newPassword) =>
      _storage.setString(_kPassword, newPassword!);
}
