library cache;

import '../../common/shared_preferences.dart';
import '../../domain/entities/entities.dart';

part 'methods.dart';

part 'auth.dart';
part 'gym.dart';
part 'profile_picture.dart';
part 'user.dart';

abstract class _Keys {
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';
  static const email = 'email';
  static const password = 'password';
  static const userId = 'user.id';
  static const userCognitoId = 'user.cognitoId';
  static const userFirstName = 'user.firstName';
  static const userLastName = 'user.lastName';
  static const userConfirmed = 'user.confirmed';
  static const profilePictureUrl = 'profilePictureUrl';
  static const gymId = 'gym.id';
  static const gymName = 'gym.name';
  static const gymAddressCity = 'gym.address.city';
  static const gymAddressState = 'gym.address.state';
  static const gymAddressZipCode = 'gym.address.zipCode';
  static const gymAddressStreet = 'gym.address.street';
  static const gymLocationLongitude = 'gym.location.longitude';
  static const gymLocationLatitude = 'gym.location.latitude';
}

abstract class Cache {
  static String? get accessToken => _accessToken;
  static const cacheAccessToken = _cacheAccessToken;
  static String? get refreshToken => _refreshToken;
  static const cacheRefreshToken = _cacheRefreshToken;
  static String? get password => _password;
  static const cachePassword = _cachePassword;

  static GymEntity? get gym => _gym;
  static const cacheGym = _cacheGym;

  static UserEntity? get user => _user;
  static const cacheUser = _cacheUser;

  static String? get profilePictureUrl => _profilePictureUrl;
  static const cacheProfilePictureUrl = _cacheProfilePictureUrl;
}
