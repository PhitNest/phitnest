import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../common/utils/utils.dart';
import 'entities.dart';

export 'address.entity.dart';
export 'auth.entity.dart';
export 'friend_request.entity.dart';
export 'friendship.entity.dart';
export 'gym.entity.dart';
export 'location.entity.dart';
export 'user.entity.dart';
export 'direct_message.entity.dart';

final empties = GetIt.instance;

void injectEntities() {
  empties.registerSingleton(AddressEntity.kEmpty);
  empties.registerSingleton(AuthEntity.kEmpty);
  empties.registerSingleton(DirectMessageEntity.kEmpty);
  empties.registerSingleton(FriendRequestEntity.kEmpty);
  empties.registerSingleton(UserEntity.kEmpty);
  empties.registerSingleton(PublicUserEntity.kEmpty);
  empties.registerSingleton(PopulatedFriendRequestEntity.kEmpty);
  empties.registerSingleton(PopulatedFriendshipEntity.kEmpty);
  empties.registerSingleton(FriendshipEntity.kEmpty);
  empties.registerSingleton(LocationEntity.kEmpty);
  empties.registerSingleton(GymEntity.kEmpty);
}

abstract class Entity<EntityType> extends Equatable
    with FromJson<EntityType>, ToJson {
  const Entity();

  static EntityType jsonFactory<EntityType extends Entity>(
          Map<String, dynamic> json) =>
      empties.get<EntityType>().fromJson(json);

  static List<EntityType> listFactory<EntityType extends Entity>(
      List<dynamic> jsonList) {
    return jsonList.map((json) => jsonFactory<EntityType>(json)).toList();
  }
}
