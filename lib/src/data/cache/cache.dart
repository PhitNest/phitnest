library cache;

import 'package:cached_network_image/cached_network_image.dart';

import '../../common/secure_storage.dart';
import '../../domain/entities/entities.dart';
import '../backend/backend.dart';

part 'auth.dart';
part 'direct_messages.dart';
part 'friendship.dart';
part 'gym.dart';
part 'profile_picture.dart';
part 'user.dart';

abstract class Cache {
  static const auth = _AuthCache();
  static const gym = _GymCache();
  static const user = _UserCache();
  static const profilePicture = _ProfilePictureCache();
  static const friendship = _FriendshipCache();
  static const directMessage = _DirectMessageCache();
}
