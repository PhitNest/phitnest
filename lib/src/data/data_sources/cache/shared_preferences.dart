import '../../../common/shared_preferences.dart';
import '../../../domain/entities/entities.dart';

class DeviceCache {
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
      ? sharedPreferences.setString('email', email)
      : sharedPreferences.remove('email');

  String? get cachedPassword => sharedPreferences.getString('password');

  Future<bool> cachePassword(String? password) => password != null
      ? sharedPreferences.setString('password', password)
      : sharedPreferences.remove('password');

  UserEntity? get cachedUser {
    final userId = sharedPreferences.getString('user.id');
    final cognitoId = sharedPreferences.getString('user.cognitoId');
    final gymId = sharedPreferences.getString('gym.id');
    final confirmed = sharedPreferences.getBool('user.confirmed');
    final firstName = sharedPreferences.getString('user.firstName');
    final lastName = sharedPreferences.getString('user.lastName');
    final email = cachedEmail;
    if (userId != null &&
        cognitoId != null &&
        gymId != null &&
        confirmed != null &&
        firstName != null &&
        lastName != null &&
        email != null) {
      return UserEntity(
        id: userId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        cognitoId: cognitoId,
        gymId: gymId,
        confirmed: confirmed,
      );
    } else {
      return null;
    }
  }

  Future<bool> cacheUser(UserEntity? user) async {
    if (user != null) {
      return Future.wait([
        sharedPreferences.setString('user.id', user.id),
        sharedPreferences.setString('user.cognitoId', user.cognitoId),
        sharedPreferences.setString('user.firstName', user.firstName),
        sharedPreferences.setString('user.lastName', user.lastName),
        sharedPreferences.setString('email', user.email),
        sharedPreferences.setString('gym.id', user.gymId),
        sharedPreferences.setBool('user.confirmed', user.confirmed),
      ]).then((_) => true);
    } else {
      return Future.wait([
        sharedPreferences.remove('user.id'),
        sharedPreferences.remove('user.cognitoId'),
        sharedPreferences.remove('user.firstName'),
        sharedPreferences.remove('user.lastName'),
        sharedPreferences.remove('email'),
        sharedPreferences.remove('gym.id'),
        sharedPreferences.remove('user.confirmed'),
      ]).then((_) => true);
    }
  }
}

final deviceCache = DeviceCache();
