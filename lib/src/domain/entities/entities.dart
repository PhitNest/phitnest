import '../../common/utils/utils.dart';
import 'package:equatable/equatable.dart';

export 'address.entity.dart';
export 'auth.entity.dart';
export 'friend_request.entity.dart';
export 'friendship.entity.dart';
export 'gym.entity.dart';
export 'location.entity.dart';
export 'user.entity.dart';
export 'direct_message.entity.dart';

abstract class Entity extends Equatable with Writeable {
  const Entity() : super();
}
