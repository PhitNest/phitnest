library backend;

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../common/constants/constants.dart';
import '../../common/failure.dart';
import '../../common/logger.dart';
import '../../common/utils/utils.dart';
import '../../domain/entities/entities.dart';

part 'adapter.dart';

part 'auth/auth.dart';
part 'directMessage/direct_message.dart';
part 'friendRequest/friend_request.dart';
part 'friendship/friendship.dart';
part 'gym/gym.dart';
part 'profilePicture/profile_picture.dart';
part 'user/user.dart';
part 'friendRequest/stream.dart';
part 'friendship/stream.dart';
part 'directMessage/stream.dart';

// ====== AUTH ======
part 'auth/login.dart';
part 'auth/confirm_register.dart';
part 'auth/forgot_password_submit.dart';
part 'auth/forgot_password.dart';
part 'auth/register.dart';
part 'auth/resend_confirmation.dart';
part 'auth/refresh_session.dart';
part 'auth/sign_out.dart';

// ====== DIRECT MESSAGE ======
part 'directMessage/get_direct_messages.dart';

// ====== FRIEND REQUEST ======
part 'friendRequest/deny.dart';
part 'friendRequest/send.dart';

// ====== FRIENDSHIP ======
part 'friendship/friends_and_messages.dart';
part 'friendship/friends_and_requests.dart';
part 'friendship/remove.dart';

// ====== GYM ======
part 'gym/nearest.dart';

// ====== PROFILE PICTURE ======
part 'profilePicture/unauthorized.dart';
part 'profilePicture/upload.dart';

// ====== USER ======
part 'user/get.dart';
part 'user/explore.dart';

abstract class Backend {
  static const auth = Auth._();
  static const directMessage = DirectMessage._();
  static const friendRequest = FriendRequest._();
  static const friendship = Friendship._();
  static const gym = Gym._();
  static const profilePicture = ProfilePicture._();
  static const user = User._();
}
