import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/interfaces.dart';

class DeviceCacheRepository implements IDeviceCacheRepository {
  Future<SharedPreferences> _storage() => SharedPreferences.getInstance();

  @override
  Future<bool> shouldSkipOnBoarding() async {
    return (await _storage()).getBool('shouldSkipOnBoarding') ?? false;
  }

  @override
  Future<void> setShouldSkipOnBoarding(bool shouldSkipOnBoarding) async {
    await (await _storage())
        .setBool('shouldSkipOnBoarding', shouldSkipOnBoarding);
  }

  @override
  Future<String?> accessToken() async {
    return (await _storage()).getString('accessToken');
  }

  @override
  Future<void> setAccessToken(String? accessToken) async {
    if (accessToken == null) {
      await (await _storage()).remove('accessToken');
    } else {
      await (await _storage()).setString('accessToken', accessToken);
    }
  }

  @override
  Future<String?> refreshToken() async {
    return (await _storage()).getString('refreshToken');
  }

  @override
  Future<void> setRefreshToken(String? refreshToken) async {
    if (refreshToken == null) {
      await (await _storage()).remove('refreshToken');
    } else {
      await (await _storage()).setString('refreshToken', refreshToken);
    }
  }

  @override
  Future<String?> password() async {
    return (await _storage()).getString('password');
  }

  @override
  Future<void> setPassword(String? password) async {
    if (password == null) {
      await (await _storage()).remove('password');
    } else {
      await (await _storage()).setString('password', password);
    }
  }

  @override
  Future<String?> email() async {
    return (await _storage()).getString('email');
  }

  @override
  Future<void> setEmail(String? email) async {
    if (email == null) {
      await (await _storage()).remove('email');
    } else {
      await (await _storage()).setString('email', email);
    }
  }
}
