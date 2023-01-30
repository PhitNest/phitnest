import 'package:equatable/equatable.dart';

import '../../../../common/utils/utils.dart';

export 'auth/auth.dart';
export 'directMessage/direct_message.dart';
export 'empty.request.dart';
export 'friendRequest/friend_request.dart';
export 'gym/gym.dart';
export 'profilePicture/profile_picture.dart';
export 'user/user.dart';

abstract class Request extends Equatable with Writeable {
  const Request() : super();
}
