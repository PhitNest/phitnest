import '../../common/shared_preferences.dart';
import '../../domain/entities/entities.dart';

UserEntity? get cachedUser {
  final userId = sharedPreferences.getString('user.id');
  final cognitoId = sharedPreferences.getString('user.cognitoId');
  final gymId = sharedPreferences.getString('gym.id');
  final confirmed = sharedPreferences.getBool('user.confirmed');
  final firstName = sharedPreferences.getString('user.firstName');
  final lastName = sharedPreferences.getString('user.lastName');
  final email = sharedPreferences.getString('user.email');
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
      sharedPreferences.setString('user.email', user.email),
      sharedPreferences.setString('gym.id', user.gymId),
      sharedPreferences.setBool('user.confirmed', user.confirmed),
    ]).then((_) => true);
  } else {
    return Future.wait([
      sharedPreferences.remove('user.id'),
      sharedPreferences.remove('user.cognitoId'),
      sharedPreferences.remove('user.firstName'),
      sharedPreferences.remove('user.lastName'),
      sharedPreferences.remove('user.email'),
      sharedPreferences.remove('gym.id'),
      sharedPreferences.remove('user.confirmed'),
    ]).then((_) => true);
  }
}

Future<bool> cacheProfilePictureUser(ProfilePictureUserEntity? user) async {
  return Future.wait([
    cacheUser(user),
    user != null
        ? sharedPreferences.setString(
            'user.profilePictureUrl', user.profilePictureUrl)
        : sharedPreferences.remove('user.profilePictureUrl'),
  ]).then((_) => true);
}
