library backend;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:basic_utils/basic_utils.dart';

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

part 'auth/login.dart';
part 'auth/confirm_register.dart';
part 'auth/forgot_password_submit.dart';
part 'auth/forgot_password.dart';
part 'auth/register.dart';
part 'auth/resend_confirmation.dart';
part 'auth/refresh_session.dart';
part 'auth/sign_out.dart';

part 'directMessage/get_direct_messages.dart';

part 'friendRequest/deny.dart';
part 'friendRequest/send.dart';

part 'friendship/friends_and_messages.dart';
part 'friendship/friends_and_requests.dart';

part 'gym/nearest.dart';

part 'profilePicture/unauthorized.dart';
part 'profilePicture/upload.dart';

part 'user/get.dart';
part 'user/explore.dart';

abstract class Backend {
  static const auth = _Auth._();
  static const directMessage = _DirectMessage._();
  static const friendRequest = _FriendRequest._();
  static const friendship = _Friendship._();
  static const gym = _Gym._();
  static const profilePicture = _ProfilePicture._();
  static const user = _User._();
}
