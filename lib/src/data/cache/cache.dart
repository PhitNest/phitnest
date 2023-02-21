library cache;

import '../../common/secure_storage.dart';
import '../../domain/entities/entities.dart';

part 'auth.dart';
part 'gym.dart';
part 'profile_picture.dart';
part 'user.dart';

abstract class _Keys {
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';
  static const password = 'password';
  static const user = 'user';
  static const profilePicture = 'profilePicture';
  static const profilePictureImage = 'profilePictureImage';
  static const gym = 'gym';
  static const userExplore = 'user.explore';
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
  static List<ProfilePicturePublicUserEntity>? get userExplore =>
      _userExploreResponse;
  static const cacheUserExplore = _cacheUserExploreResponse;

  static String? get profilePictureUrl => _profilePictureUrl;
  static const cacheProfilePictureUrl = _cacheProfilePictureUrl;

  static String get profilePictureImageCache => _Keys.profilePictureImage;
}
