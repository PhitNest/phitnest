import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../repository.dart';

class DeviceCacheRepository extends Repository {
  final _storage = new FlutterSecureStorage();

  static const String _kCompletedOnBoarding = 'completedOnBoarding';
  static const String _kRefreshToken = 'refreshToken';
  static const String _kEmail = 'email';
  static const String _kPassword = 'password';

  Future<bool> get completedOnBoarding =>
      _storage.read(key: _kCompletedOnBoarding).then((res) => res != null);

  completeOnBoarding() =>
      _storage.write(key: _kCompletedOnBoarding, value: 'true');

  Future<String?> get refreshToken => _storage.read(key: _kRefreshToken);

  cacheRefreshToken(String? newRefreshToken) =>
      _storage.write(key: _kRefreshToken, value: newRefreshToken);

  Future<String?> get email => _storage.read(key: _kEmail);

  cacheEmail(String? newEmail) => _storage.write(key: _kEmail, value: newEmail);

  Future<String?> get password => _storage.read(key: _kPassword);

  cachePassword(String? newPassword) =>
      _storage.write(key: _kPassword, value: newPassword);
}
