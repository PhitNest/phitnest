library cache;

import 'package:cached_network_image/cached_network_image.dart';

import '../../common/secure_storage.dart';
import '../../domain/entities/entities.dart';
import '../backend/backend.dart';

part 'auth.dart';
part 'gym.dart';
part 'profile_picture.dart';
part 'user.dart';
part 'friendship.dart';

abstract class Cache {
  static const auth = _AuthCache();
  static const gym = _GymCache();
  static const user = _UserCache();
  static const profilePicture = _ProfilePictureCache();
  static const friendship = _FriendshipCache();
}
