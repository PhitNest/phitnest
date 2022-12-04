import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/interfaces.dart';

class DeviceCacheRepository implements IDeviceCacheRepository {
  static late SharedPreferences _storage;

  static Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  @override
  String? get accessToken => _storage.getString('accessToken');

  @override
  String? get email => _storage.getString('email');

  @override
  String? get password => _storage.getString('password');

  @override
  String? get refreshToken => _storage.getString('refreshToken');

  @override
  set shouldSkipOnBoarding(bool shouldSkipOnBoarding) => _storage.setBool(
        'shouldSkipOnBoarding',
        shouldSkipOnBoarding,
      );

  @override
  bool get shouldSkipOnBoarding =>
      _storage.getBool('shouldSkipOnBoarding') ?? false;

  @override
  set accessToken(String? accessToken) => accessToken != null
      ? _storage.setString('refreshToken', accessToken)
      : _storage.remove('refreshToken');

  @override
  set email(String? email) => email != null
      ? _storage.setString('refreshToken', email)
      : _storage.remove('refreshToken');

  @override
  set password(String? password) => password != null
      ? _storage.setString('refreshToken', password)
      : _storage.remove('refreshToken');

  @override
  set refreshToken(String? refreshToken) => refreshToken != null
      ? _storage.setString('refreshToken', refreshToken)
      : _storage.remove('refreshToken');
}
