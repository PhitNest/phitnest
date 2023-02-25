library repository;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../../common/utils/utils.dart';
import '../../data/backend/backend.dart';
import '../../data/cache/cache.dart';
import '../entities/entities.dart';

part 'auth.dart';
part 'direct_message.dart';
part 'friendship.dart';
part 'user.dart';
part 'friend_request.dart';

abstract class Repositories {
  static const auth = Auth();
  static const user = User();
  static const friendship = Friendship();
  static const directMessage = DirectMessage();
  static const friendRequest = FriendRequest();
}
