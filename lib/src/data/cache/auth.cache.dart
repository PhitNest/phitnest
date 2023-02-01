import '../../common/shared_preferences.dart';

String? get cachedAccessToken => sharedPreferences.getString('accessToken');

Future<bool> cacheAccessToken(String? accessToken) => accessToken != null
    ? sharedPreferences.setString('accessToken', accessToken)
    : sharedPreferences.remove('accessToken');

String? get cachedRefreshToken => sharedPreferences.getString('refreshToken');

Future<bool> cacheRefreshToken(String? refreshToken) => refreshToken != null
    ? sharedPreferences.setString('refreshToken', refreshToken)
    : sharedPreferences.remove('refreshToken');

String? get cachedEmail => sharedPreferences.getString('email');

Future<bool> cacheEmail(String? email) => email != null
    ? sharedPreferences.setString('user.email', email)
    : sharedPreferences.remove('user.email');

String? get cachedPassword => sharedPreferences.getString('password');

Future<bool> cachePassword(String? password) => password != null
    ? sharedPreferences.setString('password', password)
    : sharedPreferences.remove('password');
