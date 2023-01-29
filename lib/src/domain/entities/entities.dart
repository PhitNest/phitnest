import 'package:get_it/get_it.dart';

import '../../data/data_sources/auth/requests/requests.dart';
import '../../data/data_sources/auth/responses/responses.dart';
import 'entities.dart';

export 'address.entity.dart';
export 'auth.entity.dart';
export 'friend_request.entity.dart';
export 'friendship.entity.dart';
export 'gym.entity.dart';
export 'location.entity.dart';
export 'user.entity.dart';
export 'direct_message.entity.dart';
export 'entity.dart';

final empties = GetIt.instance;

void injectEmpties() {
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
  empties.registerSingleton(LoginResponse.kEmpty);
  empties.registerSingleton(RegisterResponse.kEmpty);
  empties.registerSingleton(RefreshTokenResponse.kEmpty);
  empties.registerSingleton(LoginRequest.kEmpty);
  empties.registerSingleton(RegisterRequest.kEmpty);
  empties.registerSingleton(ForgotPasswordRequest.kEmpty);
  empties.registerSingleton(ResendConfirmationRequest.kEmpty);
  empties.registerSingleton(ConfirmRegisterRequest.kEmpty);
  empties.registerSingleton(ForgotPasswordSubmitRequest.kEmpty);
  empties.registerSingleton(RefreshSessionRequest.kEmpty);
}

abstract class Entities {
  static EntityType fromJson<EntityType extends Entity>(
          Map<String, dynamic> json) =>
      empties.get<EntityType>().fromJson(json);

  static List<EntityType> fromList<EntityType extends Entity>(
      List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson<EntityType>(json)).toList();
  }
}
